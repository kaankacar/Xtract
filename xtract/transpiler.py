from __future__ import annotations

import re
from pathlib import Path


SOLIDITY_TO_MVX_TYPE = {
    "uint256": "BigUint<Self::Api>",
    "address": "ManagedAddress<Self::Api>",
    "string": "ManagedBuffer<Self::Api>",
    "bool": "bool",
    "u8": "u8",
}


def camel_to_snake(name: str) -> str:
    s1 = re.sub("(.)([A-Z][a-z]+)", r"\1_\2", name)
    return re.sub("([a-z0-9])([A-Z])", r"\1_\2", s1).lower()


class Transpiler:
    def parse_contract_name(self, content: str) -> str | None:
        match = re.search(r"contract\s+(\w+)", content)
        return match.group(1) if match else None

    def parse_structs(self, content: str):
        structs = []
        for match in re.finditer(r"struct\s+(\w+)\s*{([^}]*)}", content):
            name = match.group(1)
            fields = match.group(2).strip()
            structs.append({"name": name, "fields": fields})
        return structs

    def parse_events(self, content: str):
        events = []
        for match in re.finditer(r"event\s+(\w+)\s*\(([^)]*)\)", content):
            name = match.group(1)
            params = match.group(2).strip()
            events.append({"name": name, "params": params})
        return events

    def parse_functions(self, content: str):
        functions = []
        for match in re.finditer(r"function\s+(\w+)\s*\((.*?)\)\s*([^\{]*)\{", content):
            name = match.group(1)
            params = match.group(2).strip()
            modifiers = match.group(3).strip()
            is_view = " view" in f" {modifiers} " or " view " in f" {modifiers} "
            returns_match = re.search(r"returns\s*\(([^)]*)\)", modifiers)
            return_type = returns_match.group(1).strip() if returns_match else None
            functions.append({
                "name": name,
                "params": params,
                "is_view": is_view,
                "return_type": return_type,
            })
        return functions

    def _map_type(self, solidity_type: str) -> str:
        t = solidity_type.strip()
        return SOLIDITY_TO_MVX_TYPE.get(t, t)

    def _format_params(self, param_str: str) -> list[str]:
        results: list[str] = []
        if not param_str:
            return results
        for raw in param_str.split(","):
            p = raw.strip()
            if not p:
                continue
            parts = p.split()
            if len(parts) < 2:
                continue
            p_type, p_name = parts[0], parts[1].rstrip(",")
            results.append(f"{p_name}: {self._map_type(p_type)}")
        return results

    def _format_return(self, return_type: str | None) -> str:
        if not return_type:
            return ""
        rt = return_type.split()[0]
        return f" -> {self._map_type(rt)}"

    def convert_struct(self, struct: dict) -> str:
        fields = []
        if struct["fields"]:
            for field in struct["fields"].split(";"):
                f = field.strip()
                if not f:
                    continue
                parts = f.split()
                if len(parts) < 2:
                    continue
                t, n = parts[0], parts[1]
                rust_t = self._map_type(t).replace("<Self::Api>", "<M>")
                fields.append(f"pub {n}: {rust_t}")
        fields_str = ",\n    ".join(fields)
        return (
            "#[derive(TypeAbi, TopEncode, TopDecode, NestedEncode, NestedDecode, ManagedVecItem)]\n"
            f"pub struct {struct['name']}<M: ManagedTypeApi> {{\n"
            f"    {fields_str}\n"
            "}"
        )

    def convert_event(self, event: dict) -> str:
        params: list[str] = []
        if event["params"]:
            for raw in event["params"].split(","):
                s = raw.strip()
                if not s:
                    continue
                is_indexed = " indexed" in f" {s} "
                s = s.replace("indexed", "").strip()
                parts = s.split()
                if len(parts) < 2:
                    continue
                t, n = parts[0], parts[1]
                idx = "#[indexed] " if is_indexed else ""
                params.append(f"{idx}{n}: {self._map_type(t)}")
        return f"#[event(\"{event['name']}\")]\n    fn {camel_to_snake(event['name'])}_event(&self{', ' if params else ''}{', '.join(params)});"

    def convert_function(self, func: dict) -> str:
        snake_name = camel_to_snake(func["name"]) if func["name"] else "init"
        annotation = (
            f"#[view({func['name']})]\n    " if func["is_view"] else ("#[endpoint]\n    " if func["name"] else "#[init]\n    ")
        )
        params = self._format_params(func["params"]) if func["name"] else []
        return_type = self._format_return(func.get("return_type"))
        return f"{annotation}fn {snake_name}(&self{', ' if params else ''}{', '.join(params)}){return_type} {{\n        // TODO: body\n    }}"

    def _extract_storage(self, content: str) -> list[tuple[str, str]]:
        vars: list[tuple[str, str]] = []
        for match in re.finditer(r"(uint256|string|address|bool|u8)(?:\s+(?:public|private|internal|external))?\s+(\w+)\s*;", content):
            vars.append((match.group(1), match.group(2)))
        return vars

    def convert(self, solidity_content: str) -> str:
        name = self.parse_contract_name(solidity_content) or "Contract"
        structs = self.parse_structs(solidity_content)
        events = self.parse_events(solidity_content)
        functions = self.parse_functions(solidity_content)
        storage = self._extract_storage(solidity_content)

        lines: list[str] = []
        lines.append("#![no_std]\n")
        lines.append("use multiversx_sc::imports::*;")
        lines.append("use multiversx_sc::derive_imports::*;\n")

        for s in structs:
            lines.append(self.convert_struct(s))
        if structs:
            lines.append("")

        lines.append("#[multiversx_sc::contract]")
        lines.append(f"pub trait {name} {{")

        for var_type, var_name in storage:
            mapper_t = self._map_type(var_type)
            lines.append(f"    #[storage_mapper(\"{var_name}\")]")
            lines.append(f"    fn {camel_to_snake(var_name)}(&self) -> SingleValueMapper<{mapper_t}>;")
            lines.append("")

        for e in events:
            lines.append(f"    {self.convert_event(e)}")
            lines.append("")

        # Ensure we have an init
        has_init = any(f.get("name", "") == "" for f in functions)
        if not has_init:
            lines.append("    #[init]")
            lines.append("    fn init(&self) {}")
            lines.append("")

        for f in functions:
            lines.append(f"    {self.convert_function(f)}")
            lines.append("")

        lines.append("}")
        return "\n".join(lines)


def transpile(input_path: Path, output_path: Path) -> bool:
    content = input_path.read_text()
    code = Transpiler().convert(content)
    output_path.write_text(code)
    return True


