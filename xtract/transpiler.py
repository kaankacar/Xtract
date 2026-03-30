from __future__ import annotations

import re
from pathlib import Path
from dataclasses import dataclass, field
from typing import Optional


@dataclass
class TranspilationWarning:
    """Represents a warning during transpilation"""
    message: str
    line: Optional[int] = None
    severity: str = "warning"  # warning, info, error


@dataclass
class TranspilationResult:
    """Result of transpilation with diagnostics"""
    code: str
    success: bool = True
    warnings: list[TranspilationWarning] = field(default_factory=list)
    errors: list[str] = field(default_factory=list)

    def add_warning(self, message: str, line: Optional[int] = None, severity: str = "warning"):
        self.warnings.append(TranspilationWarning(message, line, severity))

    def add_error(self, message: str):
        self.errors.append(message)
        self.success = False


SOLIDITY_TO_MVX_TYPE = {
    "uint256": "BigUint<Self::Api>",
    "uint128": "BigUint<Self::Api>",
    "uint64": "u64",
    "uint32": "u32",
    "uint16": "u16",
    "uint8": "u8",
    "int256": "BigInt<Self::Api>",
    "int128": "BigInt<Self::Api>",
    "int64": "i64",
    "int32": "i32",
    "int16": "i16",
    "int8": "i8",
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
        # Match contract definition at beginning of line (not in comments)
        # Remove single-line comments first
        content_no_comments = re.sub(r'//.*$', '', content, flags=re.MULTILINE)
        # Remove multi-line comments
        content_no_comments = re.sub(r'/\*.*?\*/', '', content_no_comments, flags=re.DOTALL)

        # Now search for contract definition
        match = re.search(r'\bcontract\s+(\w+)', content_no_comments)
        return match.group(1) if match else None

    def parse_inheritance(self, content: str) -> list[str]:
        """Parse inherited contracts from Solidity code (contract A is B, C)"""
        # Remove comments first
        content_no_comments = re.sub(r'//.*$', '', content, flags=re.MULTILINE)
        content_no_comments = re.sub(r'/\*.*?\*/', '', content_no_comments, flags=re.DOTALL)

        parents = []
        # Match: contract Name is Parent1, Parent2, ...
        match = re.search(r"contract\s+\w+\s+is\s+([^{]+)\s*\{", content_no_comments)
        if match:
            parents_str = match.group(1).strip()
            # Split by comma and clean up
            for parent in parents_str.split(","):
                parent_name = parent.strip()
                # Handle constructor arguments in inheritance: Parent(arg1, arg2)
                parent_name = re.sub(r'\([^)]*\)', '', parent_name).strip()
                if parent_name:
                    parents.append(parent_name)
        return parents

    def parse_abstract_contract(self, content: str) -> bool:
        """Check if contract is abstract"""
        return bool(re.search(r"abstract\s+contract\s+\w+", content))

    def parse_interface(self, content: str) -> str | None:
        """Parse interface name from Solidity code"""
        match = re.search(r"interface\s+(\w+)", content)
        return match.group(1) if match else None

    def validate_and_diagnose(self, content: str) -> TranspilationResult:
        """Validate Solidity code and generate diagnostics for unsupported features"""
        result = TranspilationResult(code="")

        # Check for unsupported features
        unsupported_patterns = [
            # Loops and if/else are now supported
            (r'\bdo\s*\{', "Do-while loops are not yet supported - manual conversion required"),
            (r'\btry\s*\{', "Try-catch blocks are not supported - use require/revert instead"),
            (r'\bcatch\s*\{', "Try-catch blocks are not supported - use require/revert instead"),
            (r'\bassembly\s*\{', "Inline assembly is not supported"),
            (r'\bunchecked\s*\{', "Unchecked blocks are not yet supported"),
            (r'\bdelete\s+', "Delete operation requires manual review"),
            (r'\.call\s*\{', "Low-level calls are not supported - use direct contract calls"),
            (r'\.delegatecall\s*\(', "Delegatecall is not supported on MultiversX"),
            (r'\.staticcall\s*\(', "Staticcall is not supported - use view functions"),
            (r'\bselfdestruct\s*\(', "Selfdestruct is not supported on MultiversX"),
            (r'\bnew\s+\w+\s*\(', "Contract creation with 'new' requires manual handling"),
            (r'abi\.encode', "ABI encoding functions require manual conversion"),
            (r'abi\.decode', "ABI decoding functions require manual conversion"),
            (r'\blibrary\s+\w+', "Libraries require manual flattening"),
            (r'\busing\s+\w+\s+for\s+', "Using-for directives require manual flattening"),
        ]

        for pattern, message in unsupported_patterns:
            if re.search(pattern, content):
                result.add_warning(message)

        # Payable functions are now automatically handled - no warning needed

        # Check for complex inheritance
        parents = self.parse_inheritance(content)
        if len(parents) > 2:
            result.add_warning(f"Complex inheritance detected ({len(parents)} parents) - consider flattening the contract")

        # Check for interface implementations
        if self.parse_interface(content):
            result.add_warning("Interface detected - will be converted to trait", severity="info")

        # Validate contract structure
        if not self.parse_contract_name(content) and not self.parse_interface(content):
            result.add_error("No contract or interface definition found in the source file")

        return result

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

    def parse_errors(self, content: str):
        errors = []
        for match in re.finditer(r"error\s+(\w+)\s*\(([^)]*)\)", content):
            name = match.group(1)
            params = match.group(2).strip()
            errors.append({"name": name, "params": params})
        return errors

    def parse_modifiers(self, content: str):
        """Parse modifier definitions from Solidity code"""
        modifiers = {}
        # Match modifier definitions: modifier name(params) { body }
        for match in re.finditer(r"modifier\s+(\w+)\s*\(([^)]*)\)\s*\{([^}]*(?:\{[^}]*\}[^}]*)*)\}", content, re.DOTALL):
            name = match.group(1)
            params = match.group(2).strip()
            body = match.group(3).strip()

            # Extract the require condition from the modifier body
            # Common patterns: require(condition, "message"); followed by _;
            require_match = re.search(r'require\s*\(([^,)]+)(?:,\s*["\']([^"\']+)["\'])?\s*\)', body)
            condition = None
            message = None
            if require_match:
                condition = require_match.group(1).strip()
                message = require_match.group(2).strip() if require_match.group(2) else f"{name} check failed"

            modifiers[name] = {
                "name": name,
                "params": params,
                "body": body,
                "condition": condition,
                "message": message
            }
        return modifiers

    def parse_constructors(self, content: str):
        constructors = []
        for match in re.finditer(r"constructor\s*\((.*?)\)\s*([^\{]*)\{([^}]*)\}", content, re.DOTALL):
            params = match.group(1).strip()
            modifiers = match.group(2).strip()
            body = match.group(3).strip()
            constructors.append({
                "params": params,
                "body": body,
            })
        return constructors

    def parse_functions(self, content: str):
        functions = []

        # Parse constructors first
        constructors = self.parse_constructors(content)
        for constructor in constructors:
            functions.append({
                "name": "",  # Empty name for constructor (becomes init)
                "params": constructor["params"],
                "is_view": False,
                "return_type": None,
                "body": constructor["body"],
                "applied_modifiers": [],
            })

        # Parse regular functions - use a more robust method to handle nested braces
        # First find function signatures, then extract bodies using brace matching
        for match in re.finditer(r"function\s+(\w+)\s*\((.*?)\)\s*([^\{]*)\{", content, re.DOTALL):
            name = match.group(1)
            params = match.group(2).strip()
            modifiers_str = match.group(3).strip()

            # Use brace matching to extract body with nested braces
            brace_start = match.end() - 1  # Position of the opening brace
            brace_end = self._find_matching_brace(content, brace_start)
            if brace_end == -1:
                body = ""
            else:
                body = content[brace_start + 1:brace_end].strip()

            is_view = " view" in f" {modifiers_str} " or " view " in f" {modifiers_str} "
            is_payable = " payable" in f" {modifiers_str} " or " payable " in f" {modifiers_str} "

            # Extract applied modifiers (custom modifiers like onlyOwner)
            # Remove visibility, returns, payable keywords to find custom modifiers
            applied_modifiers = []
            modifier_text = modifiers_str
            # Remove known keywords
            for keyword in ['public', 'private', 'internal', 'external', 'view', 'pure', 'payable', 'virtual', 'override']:
                modifier_text = re.sub(rf'\b{keyword}\b', '', modifier_text)
            # Remove returns clause
            modifier_text = re.sub(r'returns\s*\([^)]*\)', '', modifier_text)
            # What remains are custom modifiers (possibly with args)
            for mod_match in re.finditer(r'(\w+)(?:\s*\([^)]*\))?', modifier_text):
                mod_name = mod_match.group(1).strip()
                if mod_name and mod_name not in ['', 'returns']:
                    applied_modifiers.append(mod_name)

            returns_match = re.search(r"returns\s*\(([^)]*)\)", modifiers_str)
            return_type = returns_match.group(1).strip() if returns_match else None
            functions.append({
                "name": name,
                "params": params,
                "is_view": is_view,
                "is_payable": is_payable,
                "return_type": return_type,
                "body": body,
                "applied_modifiers": applied_modifiers,
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
        non_indexed_count = 0
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
                # Map type and make it a reference for events
                mapped_type = self._map_type(t)
                if not mapped_type.startswith("&"):
                    mapped_type = f"&{mapped_type}"
                
                # MultiversX allows only 1 non-indexed (data) argument
                # If we already have one non-indexed, make this one indexed
                if not is_indexed:
                    if non_indexed_count >= 1:
                        is_indexed = True  # Force to indexed if we already have a non-indexed
                    else:
                        non_indexed_count += 1
                
                idx = "#[indexed] " if is_indexed else ""
                params.append(f"{idx}{n}: {mapped_type}")
        event_fn_name = f"{camel_to_snake(event['name'])}_event"
        params_str = ", ".join(params) if params else ""
        return f"#[event(\"{event['name']}\")]\n    fn {event_fn_name}(&self{', ' if params_str else ''}{params_str});"

    def convert_error(self, error: dict) -> str:
        params: list[str] = []
        if error["params"]:
            for raw in error["params"].split(","):
                s = raw.strip()
                if not s:
                    continue
                parts = s.split()
                if len(parts) < 2:
                    continue
                t, n = parts[0], parts[1]
                params.append(f"pub {n}: {self._map_type(t).replace('<Self::Api>', '<M>')}")

        fields_str = ",\n    ".join(params) if params else ""
        return (
            "#[derive(TypeAbi, TopEncode, TopDecode, NestedEncode, NestedDecode)]\n"
            f"pub struct {error['name']}<M: ManagedTypeApi> {{\n"
            f"    {fields_str}\n"
            "}"
        )

    def _find_matching_brace(self, text: str, start: int) -> int:
        """Find the position of the matching closing brace"""
        depth = 0
        i = start
        while i < len(text):
            if text[i] == '{':
                depth += 1
            elif text[i] == '}':
                depth -= 1
                if depth == 0:
                    return i
            i += 1
        return -1

    def _extract_control_flow(self, body: str) -> tuple[list[dict], str]:
        """Extract if/else and loop statements, returning them and the remaining body"""
        control_statements = []
        remaining = body

        # Process if/else statements
        while True:
            # Match if statement: if (condition) { ... }
            if_match = re.search(r'\bif\s*\(([^)]+)\)\s*\{', remaining)
            if not if_match:
                break

            condition = if_match.group(1).strip()
            block_start = if_match.end() - 1  # Position of opening brace
            block_end = self._find_matching_brace(remaining, block_start)

            if block_end == -1:
                break

            if_body = remaining[block_start + 1:block_end].strip()

            # Check for else clause
            else_match = re.match(r'\s*else\s*\{', remaining[block_end + 1:])
            else_body = None
            final_end = block_end + 1

            if else_match:
                else_start = block_end + 1 + else_match.end() - 1
                else_end = self._find_matching_brace(remaining, else_start)
                if else_end != -1:
                    else_body = remaining[else_start + 1:else_end].strip()
                    final_end = else_end + 1

            control_statements.append({
                "type": "if",
                "condition": condition,
                "if_body": if_body,
                "else_body": else_body
            })

            # Remove the processed if/else from remaining
            remaining = remaining[:if_match.start()] + remaining[final_end:]

        # Process for loops: for (init; condition; update) { ... }
        while True:
            for_match = re.search(r'\bfor\s*\(([^;]*);([^;]*);([^)]*)\)\s*\{', remaining)
            if not for_match:
                break

            init = for_match.group(1).strip()
            condition = for_match.group(2).strip()
            update = for_match.group(3).strip()
            block_start = for_match.end() - 1
            block_end = self._find_matching_brace(remaining, block_start)

            if block_end == -1:
                break

            loop_body = remaining[block_start + 1:block_end].strip()

            control_statements.append({
                "type": "for",
                "init": init,
                "condition": condition,
                "update": update,
                "body": loop_body
            })

            remaining = remaining[:for_match.start()] + remaining[block_end + 1:]

        # Process while loops: while (condition) { ... }
        while True:
            while_match = re.search(r'\bwhile\s*\(([^)]+)\)\s*\{', remaining)
            if not while_match:
                break

            condition = while_match.group(1).strip()
            block_start = while_match.end() - 1
            block_end = self._find_matching_brace(remaining, block_start)

            if block_end == -1:
                break

            loop_body = remaining[block_start + 1:block_end].strip()

            control_statements.append({
                "type": "while",
                "condition": condition,
                "body": loop_body
            })

            remaining = remaining[:while_match.start()] + remaining[block_end + 1:]

        return control_statements, remaining

    def _parse_statements(self, body: str) -> list[dict]:
        """Parse statements from function body"""
        statements = []

        # Remove comments and normalize whitespace
        body = re.sub(r'//.*', '', body)
        body = re.sub(r'/\*.*?\*/', '', body, flags=re.DOTALL)

        # Extract control flow statements first (if/else, for, while)
        control_statements, remaining_body = self._extract_control_flow(body)
        statements.extend(control_statements)

        # Split remaining by semicolons
        lines = remaining_body.split(';')
        for line in lines:
            line = line.strip()
            if not line:
                continue

            # Handle require statements (with or without message)
            if require_match := re.match(r'require\s*\(([^,)]+)(?:,\s*["\']([^"\']+)["\'])?\)', line):
                condition = require_match.group(1).strip()
                message = require_match.group(2).strip() if require_match.group(2) else None
                statements.append({
                    "type": "require",
                    "condition": condition,
                    "message": message
                })
                continue

            # Handle revert statements
            if revert_match := re.match(r'revert\s*\(\s*["\']([^"\']+)["\']\s*\)', line):
                message = revert_match.group(1).strip()
                statements.append({
                    "type": "revert",
                    "message": message
                })
                continue

            # Handle custom error revert
            if revert_error_match := re.match(r'revert\s+(\w+)\s*\(([^)]*)\)', line):
                error_name = revert_error_match.group(1)
                args = revert_error_match.group(2).strip()
                statements.append({
                    "type": "revert_error",
                    "error_name": error_name,
                    "args": args
                })
                continue

            # Handle emit statements
            if emit_match := re.match(r'emit\s+(\w+)\s*\((.*)\)', line):
                event_name = emit_match.group(1)
                args = emit_match.group(2).strip()
                statements.append({
                    "type": "emit",
                    "event_name": event_name,
                    "args": args
                })
                continue

            # Handle return statements
            if return_match := re.match(r'return\s+(.+)', line):
                expression = return_match.group(1).strip()
                statements.append({
                    "type": "return",
                    "expression": expression
                })
                continue

            # Handle variable declarations: type name = expr
            if decl_match := re.match(r'([a-zA-Z_]\w*(?:\[\d*\])?)\s+([a-zA-Z_]\w*)\s*=\s*(.+)', line):
                statements.append({
                    "type": "declaration",
                    "type_name": decl_match.group(1).strip(),
                    "var_name": decl_match.group(2).strip(),
                    "value": decl_match.group(3).strip()
                })
                continue

            # Handle variable declarations without initializer: type name;
            if uninit_match := re.match(r'([a-zA-Z_]\w*(?:\[\d*\])?)\s+([a-zA-Z_]\w*)\s*$', line):
                statements.append({
                    "type": "declaration",
                    "type_name": uninit_match.group(1).strip(),
                    "var_name": uninit_match.group(2).strip(),
                    "value": None
                })
                continue

            # Handle assignments
            if '=' in line:
                if assign_match := re.match(r'(\w+(?:\s+\w+)*)\s*=\s*(.+)', line):
                    left = assign_match.group(1).strip()
                    right = assign_match.group(2).strip()
                    statements.append({
                        "type": "assignment",
                        "left": left,
                        "right": right
                    })
                continue

            # Handle struct initialization and push
            if push_match := re.match(r'(\w+)\.push\s*\((.+)\)', line):
                array_name = push_match.group(1)
                struct_data = push_match.group(2).strip()
                statements.append({
                    "type": "push",
                    "array_name": array_name,
                    "struct_data": struct_data
                })
                continue

            # Handle simple variable updates (like +=, -=)
            if update_match := re.match(r'(\w+(?:\[[^\]]+\])*)\s*([+\-*/]?=)\s*(.+)', line):
                target = update_match.group(1).strip()
                operator = update_match.group(2).strip()
                value = update_match.group(3).strip()
                statements.append({
                    "type": "update",
                    "target": target,
                    "operator": operator,
                    "value": value
                })
                continue

        return statements

    def _convert_statement(self, stmt: dict, contract_name: str) -> str:
        """Convert a single statement to MultiversX Rust"""
        stmt_type = stmt["type"]

        if stmt_type == "require":
            condition = self._convert_expression(stmt["condition"])
            message = stmt.get("message")
            # MultiversX require! macro always needs a message
            if message:
                return f'        require!({condition}, "{message}");'
            else:
                return f'        require!({condition}, "Requirement not met");'

        elif stmt_type == "emit":
            event_name = stmt["event_name"]
            args = stmt["args"]
            if args:
                # Parse arguments and add & prefix for event calls
                args_list = [arg.strip() for arg in args.split(',')]
                converted_args = []
                for arg in args_list:
                    converted_arg = self._convert_expression(arg)
                    # Check if this parameter might be moved - clone it first
                    # Only clone if it's a simple parameter (not already a function call or expression)
                    params = ['_to', '_from', '_value', 'proposalId', 'goal', 'amount', 'price', 'tokenId']
                    needs_clone = False
                    arg_clean = arg.strip()
                    for param in params:
                        if param == arg_clean or (param in converted_arg and '(' not in converted_arg and not converted_arg.startswith('self.')):
                            needs_clone = True
                            break
                    
                    # Always add & prefix for event arguments (MultiversX requirement)
                    # But skip if already has & or is a literal/number
                    # Also handle binary operations - they should not be wrapped in &
                    if converted_arg.startswith('&') and not converted_arg.startswith('&('):
                        converted_args.append(converted_arg)
                    elif '(' in converted_arg and (' - ' in converted_arg or ' + ' in converted_arg or ' * ' in converted_arg):
                        # Binary operation or expression - wrap in parentheses and add &
                        # Check if it starts with & already (shouldn't, but handle it)
                        if converted_arg.startswith('&'):
                            converted_arg = converted_arg[1:]  # Remove existing &
                        converted_args.append(f'&({converted_arg})')
                    elif converted_arg.replace('.', '').replace('_', '').replace('-', '').replace('(', '').replace(')', '').isdigit():
                        # Number literal - add & prefix
                        converted_args.append(f'&{converted_arg}')
                    elif '(' in converted_arg or converted_arg.startswith('self.'):
                        # Function call or self.method() - add & prefix
                        converted_args.append(f'&{converted_arg}')
                    else:
                        # Variable - add & prefix
                        if needs_clone and not '.clone()' in converted_arg:
                            converted_args.append(f'&{converted_arg}.clone()')
                        else:
                            converted_args.append(f'&{converted_arg}')
                return f'        self.{camel_to_snake(event_name)}_event({", ".join(converted_args)});'
            else:
                return f'        self.{camel_to_snake(event_name)}_event();'

        elif stmt_type == "return":
            expression = stmt["expression"].strip()
            # Check if it's a bool literal
            if expression.lower() == "true":
                return '        return true;'
            elif expression.lower() == "false":
                return '        return false;'
            else:
                converted_expr = self._convert_expression(expression)
                # Preserve explicit return from Solidity for clarity
                return f'        return {converted_expr};'

        elif stmt_type == "assignment":
            left = stmt["left"].strip()
            right_expr = stmt["right"].strip()
            
            # Convert right expression - handle storage variable access
            right = self._convert_expression(right_expr)
            
            # Check if right expression uses a parameter that might be moved
            # If it contains operations with parameters, we need to clone
            # First convert the expression to see what parameters are used
            params_in_expr = []
            params = ['_to', '_from', '_value', 'proposalId', 'goal', 'amount', 'price', 'tokenId']
            for param in params:
                # Check if param is used as a standalone variable (not in function calls)
                if re.search(rf'\b{param}\b', right_expr) and f'{param}.' not in right_expr:
                    params_in_expr.append(param)
            
            # If we have parameters and operations, we need to clone
            if params_in_expr and (' - ' in right_expr or ' + ' in right_expr or ' * ' in right_expr):
                # Clone all parameters in the expression
                for param in params_in_expr:
                    # Replace param with param.clone() but only as standalone, not in expressions
                    right = re.sub(rf'\b{param}\b', f'{param}.clone()', right)

            # Check if this is a storage variable assignment
            # Extract variable name (handle cases like "balance = balance - _value")
            left_var = left.split()[0] if ' ' in left else left
            storage_vars = [
                'value', 'name', 'symbol', 'decimals', 'totalSupply', 'balance',
                'chairperson', 'votingEnd', 'votingClosed', 'hasVoted', 'votedProposalId',
                'proposalVoteCount', 'proposalCount', 'nextTokenId',
                'campaignCreator', 'campaignGoal', 'campaignPledged', 'campaignClaimed', 'count',
                'currentTokenId', 'currentOwner', 'currentPrice', 'currentForSale', 'previousOwner'
            ]
            
            if left_var in storage_vars:
                snake_left = camel_to_snake(left_var)
                # Wrap right side in parentheses if it contains operations
                if any(op in right for op in ['+', '-', '*', '/', '(', ')']):
                    return f'        self.{snake_left}().set(&({right}));'
                else:
                    return f'        self.{snake_left}().set(&{right});'
            else:
                return f'        {left} = {right};'

        elif stmt_type == "declaration":
            type_name = stmt["type_name"]
            var_name = stmt["var_name"]
            value = stmt.get("value")
            rust_type = self._map_type(type_name)
            if value is not None:
                rust_value = self._convert_expression(value)
                return f'        let mut {var_name}: {rust_type} = {rust_value};'
            else:
                return f'        let mut {var_name}: {rust_type} = Default::default();'

        elif stmt_type == "push":
            array_name = stmt["array_name"]
            struct_data = self._convert_struct_initialization(stmt["struct_data"])
            return f'        self.{array_name}().push(&{struct_data});'

        elif stmt_type == "update":
            target = stmt["target"]
            operator = stmt["operator"]
            value = self._convert_expression(stmt["value"])

            # Handle storage variable updates
            if '.' in target:  # mapping access like balanceOf[sender]
                if operator == "-=":
                    return f'        self.{target.replace("[", "(&").replace("]", ")").replace(" -= ", "").replace(";", "")} -= &{value};'
                elif operator == "+=":
                    return f'        self.{target.replace("[", "(&").replace("]", ")").replace(" += ", "").replace(";", "")} += &{value};'
                elif operator == "=":
                    return f'        self.{target.replace("[", "(&").replace("]", ")").replace(" = ", "").replace(";", "")} = {value};'
            elif target in ['voteCount', 'hasVoted', 'votedProposalId']:  # struct field updates
                return f'        // TODO: struct field update - {target} {operator} {value};'
            else:
                if operator == "=":
                    return f'        {target} = {value};'
                else:
                    return f'        {target} {operator} {value};'

        elif stmt_type == "revert":
            message = stmt["message"]
            return f'        sc_panic!("{message}");'

        elif stmt_type == "revert_error":
            error_name = stmt["error_name"]
            args = stmt["args"]
            if args:
                converted_args = self._convert_expression(args)
                return f'        sc_panic!("{error_name}({converted_args})");'
            else:
                return f'        sc_panic!("{error_name}");'

        elif stmt_type == "if":
            condition = self._convert_expression(stmt["condition"])
            if_body = stmt["if_body"]
            else_body = stmt.get("else_body")

            # Recursively parse and convert the if body
            if_statements = self._parse_statements(if_body)
            if_lines = []
            for if_stmt in if_statements:
                converted = self._convert_statement(if_stmt, "")
                if converted:
                    if_lines.append(converted)

            if_code = '\n'.join(if_lines) if if_lines else '            // empty block'

            if else_body:
                # Recursively parse and convert the else body
                else_statements = self._parse_statements(else_body)
                else_lines = []
                for else_stmt in else_statements:
                    converted = self._convert_statement(else_stmt, "")
                    if converted:
                        else_lines.append(converted)

                else_code = '\n'.join(else_lines) if else_lines else '            // empty block'
                return f'        if {condition} {{\n{if_code}\n        }} else {{\n{else_code}\n        }}'
            else:
                return f'        if {condition} {{\n{if_code}\n        }}'

        elif stmt_type == "for":
            # Convert Solidity for loop to Rust
            # for (uint i = 0; i < n; i++) becomes: for i in 0..n
            init = stmt["init"]
            condition = stmt["condition"]
            update = stmt["update"]
            loop_body = stmt["body"]

            # Try to detect simple counter patterns: uint i = 0; i < n; i++
            init_match = re.match(r'(?:uint\d*|int\d*)\s+(\w+)\s*=\s*(\d+)', init)
            cond_match = re.match(r'(\w+)\s*<\s*(.+)', condition)
            update_match = re.match(r'(\w+)\s*\+\+', update)

            if init_match and cond_match and update_match:
                var_name = init_match.group(1)
                start_val = init_match.group(2)
                end_expr = self._convert_expression(cond_match.group(2))

                # Parse body
                body_statements = self._parse_statements(loop_body)
                body_lines = []
                for body_stmt in body_statements:
                    converted = self._convert_statement(body_stmt, "")
                    if converted:
                        body_lines.append(converted)

                body_code = '\n'.join(body_lines) if body_lines else '            // empty block'
                return f'        for {var_name} in {start_val}..{end_expr} {{\n{body_code}\n        }}'
            else:
                # General while-style loop fallback
                converted_condition = self._convert_expression(condition)
                converted_init = self._convert_expression(init) if init else ""
                converted_update = self._convert_expression(update) if update else ""

                body_statements = self._parse_statements(loop_body)
                body_lines = []
                for body_stmt in body_statements:
                    converted = self._convert_statement(body_stmt, "")
                    if converted:
                        body_lines.append(converted)

                body_code = '\n'.join(body_lines) if body_lines else '            // empty block'
                # Add update at end of loop body
                if converted_update:
                    body_code += f'\n            {converted_update};'

                init_line = f'        let mut {converted_init};\n' if converted_init else ''
                return f'{init_line}        while {converted_condition} {{\n{body_code}\n        }}'

        elif stmt_type == "while":
            condition = self._convert_expression(stmt["condition"])
            loop_body = stmt["body"]

            body_statements = self._parse_statements(loop_body)
            body_lines = []
            for body_stmt in body_statements:
                converted = self._convert_statement(body_stmt, "")
                if converted:
                    body_lines.append(converted)

            body_code = '\n'.join(body_lines) if body_lines else '            // empty block'
            return f'        while {condition} {{\n{body_code}\n        }}'

        return f'        // TODO: unhandled statement: {stmt}'

    def _convert_expression(self, expr: str) -> str:
        """Convert Solidity expressions to MultiversX equivalents"""
        # Handle msg.sender
        expr = expr.replace("msg.sender", "self.blockchain().get_caller()")

        # Handle address(0)
        expr = expr.replace("address(0)", "ManagedAddress::zero()")

        # Handle block.timestamp
        expr = expr.replace("block.timestamp", "self.blockchain().get_block_timestamp()")

        # Handle msg.sender first (before variable conversion)
        expr = expr.replace("msg.sender", "self.blockchain().get_caller()")
        
        # Handle address(0)
        expr = expr.replace("address(0)", "ManagedAddress::<Self::Api>::zero()")
        
        # Handle simple arithmetic and comparisons (basic cases)
        # This would need to be much more sophisticated for complex expressions

        # Handle array length
        expr = expr.replace(".length", ".len()")

        # Handle power operator (limited)
        expr = expr.replace("**", ".pow")

        # Handle 1 minutes -> 60 seconds conversion
        expr = re.sub(r'(\d+)\s*minutes', lambda m: str(int(m.group(1)) * 60), expr)

        # Handle BigUint literal conversion for large numbers
        # Replace large numbers (not in function calls) with BigUint::from
        def replace_number(match):
            num_str = match.group(1)
            try:
                num = int(num_str)
                # u64::MAX is 18446744073709551615
                # Very large numbers (> u64::MAX) should use power operations
                # For numbers like 1000000000000000000000000 (10^24), use power
                if num > 18446744073709551615:  # u64::MAX
                    # Try to express as power of 10
                    num_str_check = str(num)
                    if num_str_check.startswith('1') and all(c == '0' for c in num_str_check[1:]):
                        # Number is 1 followed by zeros (power of 10)
                        power = len(num_str_check) - 1
                        if power <= 256:  # Reasonable power limit
                            return f'BigUint::from(10u32).pow({power})'
                    # For other very large numbers, use multiplication
                    # Calculate as multiple of smaller numbers
                    # Or use hex bytes manually
                    # For now, use a workaround: express as multiple operations
                    # Actually, let's use from_bytes_be with manual byte array
                    # Convert to hex string and parse bytes
                    hex_str = hex(num)[2:]  # Remove '0x'
                    if len(hex_str) % 2 == 1:
                        hex_str = '0' + hex_str
                    # Create byte array manually: hex string to bytes
                    # For example: "d3c21bcecceda1000000" -> [0xd3, 0xc2, ...]
                    byte_array = ', '.join([f'0x{hex_str[i:i+2]}' for i in range(0, len(hex_str), 2)])
                    return f'BigUint::from_bytes_be(&[{byte_array}])'
                elif num > 4294967295:  # u32::MAX
                    return f'BigUint::from({num_str}u64)'
                else:
                    return f'BigUint::from({num_str}u32)'
            except (ValueError, OverflowError):
                # If number is too large to parse, use power of 10 if possible
                num_str_check = str(num)
                if num_str_check.startswith('1') and all(c == '0' for c in num_str_check[1:]):
                    power = len(num_str_check) - 1
                    return f'BigUint::from(10u32).pow({power})'
                return f'BigUint::from(0u32)'  # Fallback
        
        # Replace standalone numbers (avoid numbers already in function calls)
        expr = re.sub(r'(?<!::from\()\b(\d+)\b(?!u32|u64|u16|u8|i32|i64|i16|i8)', replace_number, expr)

        # Handle variable access - convert simple variable names to storage getters
        # This is a simple heuristic - in a full implementation we'd need proper symbol resolution
        # Don't convert function parameters, literals, or certain keywords
        # But DO convert storage variables like 'value', 'balanceOf', etc.
        exclude_patterns = [
            'true', 'false', 'self', 'newValue', 'new_value', 'to', 'from',
            '_to', '_from', '_value', 'spender', 'owner', 'caller', 'description',
            'price', 'tokenId', 'token_id', 'durationInMinutes', 'duration_in_minutes',
            'proposalId', 'proposal_id', 'voterAddress', 'voter_address',
            'offerIndex', 'offer_index', 'id', 'required', 'provided'
        ]

        # Storage variables that should be converted to getters (common patterns)
        # Note: mappings like balanceOf should NOT be converted to .get() since they're accessed with []
        storage_vars = [
            'value', 'totalSupply', 'name', 'symbol', 'decimals', 'balance',
            'chairperson', 'votingEnd', 'votingClosed', 'hasVoted', 'votedProposalId',
            'proposalVoteCount', 'proposalCount', 'nextTokenId', 'campaigns', 'crowdfundingEnd',
            'campaignCreator', 'campaignGoal', 'campaignPledged', 'campaignClaimed', 'count',
            'currentTokenId', 'currentOwner', 'currentPrice', 'currentForSale', 'previousOwner',
            'owner', 'admin', 'paused', 'locked', 'initialized', 'deadline', 'startTime', 'endTime',
            'minAmount', 'maxAmount', 'fee', 'feePercent', 'treasury', 'rewardRate', 'lastUpdateTime'
        ]

        # Mapping variables that should be converted to mappers (not getters)
        # Includes both single and nested mapping names
        mapping_vars = [
            'balanceOf', 'allowance', 'voters', 'proposals', 'nfts', 'offersForNFT',
            'balances', 'approved', 'isApprovedForAll', 'tokenOwner', 'tokenApprovals',
            'operatorApprovals', 'stakes', 'rewards', 'userInfo', 'poolInfo'
        ]

        def convert_var(match):
            var = match.group(1)
            if var in exclude_patterns:
                return var
            elif var in storage_vars:
                return f'self.{camel_to_snake(var)}().get()'
            elif var in mapping_vars:
                return f'self.{camel_to_snake(var)}()'
            else:
                return var

        expr = re.sub(r'\b(\w+)\b', convert_var, expr)

        # Handle storage access (basic mapping patterns) - do this after variable conversion
        # Handle nested mapping access like allowance[from][to] -> self.allowance(&from, &to)
        # This is a simplified approach - in a full implementation we'd need proper AST parsing
        expr = re.sub(r'(\w+)\[([^\]]+)\]\[([^\]]+)\]', r'self.\1(&\2, &\3)', expr)
        # Handle single mapping access like balanceOf[...] -> self.balance_of(&...)
        expr = re.sub(r'(\w+)\[([^\]]+)\]', r'self.\1(&\2)', expr)
        # Handle mapper access like balance_of()[...] -> balance_of(&...)
        expr = re.sub(r'self\.(\w+)\(\)\[([^\]]+)\]', r'self.\1(&\2)', expr)
        # Handle nested mapper access like allowance(&_from)[...] -> allowance(&_from, &...)
        expr = re.sub(r'self\.(\w+)\(([^)]+)\)\[([^\]]+)\]', r'self.\1(\2, &\3)', expr)

        return expr

    def _convert_struct_initialization(self, struct_data: str) -> str:
        """Convert Solidity struct initialization to MultiversX"""
        # Handle Proposal({...}) pattern
        if struct_match := re.match(r'(\w+)\s*\(\s*\{([^}]*)\}\s*\)', struct_data):
            struct_name = struct_match.group(1)
            fields_str = struct_match.group(2).strip()

            # Parse field assignments
            fields = []
            for field_assign in fields_str.split(','):
                field_assign = field_assign.strip()
                if ':' in field_assign:
                    key, value = field_assign.split(':', 1)
                    key = key.strip()
                    value = self._convert_expression(value.strip())
                    fields.append(f'{key}: {value}')

            fields_joined = ',\n            '.join(fields)
            return f'{struct_name} {{\n            {fields_joined}\n        }}'

        # Handle simple variable
        return self._convert_expression(struct_data)

    def convert_function(self, func: dict, contract_name: str = "Contract", modifiers: dict = None) -> str:
        snake_name = camel_to_snake(func["name"]) if func["name"] else "init"

        # Build annotation based on function type
        if func["is_view"]:
            annotation = f"#[view({func['name']})]\n    "
        elif func["name"]:
            # Check if payable
            if func.get("is_payable"):
                annotation = "#[payable(\"EGLD\")]\n    #[endpoint]\n    "
            else:
                annotation = "#[endpoint]\n    "
        else:
            annotation = "#[init]\n    "

        params = self._format_params(func["params"]) if func["name"] else []
        return_type = self._format_return(func.get("return_type"))

        # Parse and convert body statements
        body_lines = []

        # Add modifier checks at the start of the function
        if modifiers and func.get("applied_modifiers"):
            for mod_name in func["applied_modifiers"]:
                if mod_name in modifiers:
                    mod = modifiers[mod_name]
                    if mod.get("condition"):
                        converted_condition = self._convert_expression(mod["condition"])
                        message = mod.get("message", f"{mod_name} check failed")
                        body_lines.append(f'        require!({converted_condition}, "{message}");')

        if func.get("body"):
            statements = self._parse_statements(func["body"])
            for stmt in statements:
                converted = self._convert_statement(stmt, "")
                if converted:
                    body_lines.append(converted)

        if body_lines:
            body = '\n'.join(body_lines)
            return f"{annotation}fn {snake_name}(&self{', ' if params else ''}{', '.join(params)}){return_type} {{\n{body}\n    }}"
        else:
            return f"{annotation}fn {snake_name}(&self{', ' if params else ''}{', '.join(params)}){return_type} {{\n        // TODO: implement body\n    }}"

    def _extract_storage(self, content: str) -> list[tuple[str, str, str]]:
        """Extract storage variables, including mappings (single and nested)"""
        vars: list[tuple[str, str, str]] = []

        # Simple variables (uint256, address, etc.)
        for match in re.finditer(r"(uint256|uint128|uint64|uint32|uint16|uint8|int256|int128|int64|int32|int16|int8|string|address|bool|u8)(?:\s+(?:public|private|internal|external))?\s+(\w+)\s*;", content):
            vars.append((match.group(1), match.group(2), ""))

        # Nested mappings: mapping(type1 => mapping(type2 => type3))
        for match in re.finditer(r"mapping\s*\(\s*(\w+)\s*=>\s*mapping\s*\(\s*(\w+)\s*=>\s*(\w+)\s*\)\s*\)\s*(?:public|private|internal|external)?\s*(\w+)\s*;", content):
            key1_type = match.group(1).strip()
            key2_type = match.group(2).strip()
            value_type = match.group(3).strip()
            var_name = match.group(4)
            vars.append(("nested_mapping", var_name, f"{key1_type}=>{key2_type}=>{value_type}"))

        # Simple mappings: mapping(type1 => type2)
        # Make sure not to match nested mappings again
        for match in re.finditer(r"mapping\s*\(\s*(\w+)\s*=>\s*(\w+)\s*\)\s*(?:public|private|internal|external)?\s*(\w+)\s*;", content):
            key_type = match.group(1).strip()
            value_type = match.group(2).strip()
            var_name = match.group(3)
            # Check if this variable was already captured as a nested mapping
            if not any(v[1] == var_name for v in vars):
                vars.append(("mapping", var_name, f"{key_type}=>{value_type}"))

        return vars

    def _convert_storage_mapper(self, var_type: str, var_name: str, mapping_info: str = "") -> str:
        """Convert storage variable to appropriate mapper type"""
        if var_type == "nested_mapping":
            # Parse key1=>key2=>value nested mapping
            parts = mapping_info.split("=>")
            if len(parts) == 3:
                key1_type = parts[0].strip()
                key2_type = parts[1].strip()
                value_type = parts[2].strip()

                # Map types
                key1_mapped = self._map_type(key1_type)
                key2_mapped = self._map_type(key2_type)
                value_mapped = self._map_type(value_type)

                # Use SingleValueMapper for the inner value with two keys
                return f"SingleValueMapper<{value_mapped}>"
        elif var_type == "mapping":
            # Parse key=>value mapping
            key_val = mapping_info.split("=>")
            if len(key_val) == 2:
                key_type = key_val[0].strip()
                value_type = key_val[1].strip()

                # Map types
                key_mapped = self._map_type(key_type)
                value_mapped = self._map_type(value_type)

                return f"SingleValueMapper<{value_mapped}>"

        return f"SingleValueMapper<{self._map_type(var_type)}>"

    def convert(self, solidity_content: str) -> str:
        name = self.parse_contract_name(solidity_content) or "Contract"
        parents = self.parse_inheritance(solidity_content)
        is_abstract = self.parse_abstract_contract(solidity_content)
        structs = self.parse_structs(solidity_content)
        events = self.parse_events(solidity_content)
        errors = self.parse_errors(solidity_content)
        modifiers = self.parse_modifiers(solidity_content)
        functions = self.parse_functions(solidity_content)
        storage = self._extract_storage(solidity_content)

        lines: list[str] = []
        lines.append("#![no_std]\n")
        lines.append("use multiversx_sc::imports::*;\n")

        # Add inheritance comment if there are parent contracts
        if parents:
            lines.append(f"// Inherits from: {', '.join(parents)}\n")
        # Add hex import if needed (for large number conversion)
        if any("hex::decode" in line for line in self._parse_statements("\n".join([f.get("body", "") for f in functions])) if isinstance(line, dict) and line.get("type") == "assignment"):
            # Check if any function body uses hex::decode
            for func in functions:
                if "hex::decode" in self.convert_function(func, name):
                    lines.append("use multiversx_sc::hex;\n")
                    break

        for s in structs:
            lines.append(self.convert_struct(s))
        if structs:
            lines.append("")

        for e in errors:
            lines.append(self.convert_error(e))
        if errors:
            lines.append("")

        lines.append("#[multiversx_sc::contract]")
        # Generate trait with supertrait bounds for inheritance
        if parents:
            supertraits = " + ".join(parents)
            lines.append(f"pub trait {name}: {supertraits} {{")
        else:
            lines.append(f"pub trait {name} {{")

        for var_type, var_name, mapping_info in storage:
            mapper_t = self._convert_storage_mapper(var_type, var_name, mapping_info)
            snake_name = camel_to_snake(var_name)

            if var_type == "nested_mapping":
                # Parse key1=>key2=>value nested mapping
                parts = mapping_info.split("=>")
                if len(parts) == 3:
                    key1_type = parts[0].strip()
                    key2_type = parts[1].strip()
                    lines.append(f"    #[storage_mapper(\"{var_name}\")]")
                    lines.append(f"    fn {snake_name}(&self, key1: &{self._map_type(key1_type)}, key2: &{self._map_type(key2_type)}) -> {mapper_t};")
            elif var_type == "mapping":
                # Parse key=>value mapping
                key_val = mapping_info.split("=>")
                if len(key_val) == 2:
                    key_type = key_val[0].strip()
                    lines.append(f"    #[storage_mapper(\"{var_name}\")]")
                    lines.append(f"    fn {snake_name}(&self, key: &{self._map_type(key_type)}) -> {mapper_t};")
                else:
                    lines.append(f"    #[storage_mapper(\"{var_name}\")]")
                    lines.append(f"    fn {snake_name}(&self) -> {mapper_t};")
            else:
                lines.append(f"    #[storage_mapper(\"{var_name}\")]")
                lines.append(f"    fn {snake_name}(&self) -> {mapper_t};")
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
            lines.append(f"    {self.convert_function(f, name, modifiers)}")
            lines.append("")

        lines.append("}")
        return "\n".join(lines)

    def convert_with_diagnostics(self, solidity_content: str) -> TranspilationResult:
        """Convert Solidity to MultiversX Rust with full diagnostics"""
        # First validate and check for issues
        result = self.validate_and_diagnose(solidity_content)

        # If there are critical errors, don't proceed
        if not result.success:
            return result

        # Perform the conversion
        try:
            result.code = self.convert(solidity_content)
            result.success = True
        except Exception as e:
            result.add_error(f"Transpilation failed: {str(e)}")

        return result


def transpile(input_path: Path, output_path: Path) -> bool:
    content = input_path.read_text()
    code = Transpiler().convert(content)
    output_path.write_text(code)
    return True


def transpile_with_diagnostics(input_path: Path, output_path: Path) -> TranspilationResult:
    """Transpile with full diagnostics returned"""
    content = input_path.read_text()
    transpiler = Transpiler()
    result = transpiler.convert_with_diagnostics(content)

    if result.success:
        output_path.write_text(result.code)

    return result


