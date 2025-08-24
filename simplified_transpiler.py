#!/usr/bin/env python3

import os
import re
import sys
from pathlib import Path

class SimplifiedTranspiler:
    """
    A simplified transpiler that focuses on Solidity to MultiversX conversion
    for specific test cases. This is not a full-featured transpiler but rather
    a demonstration of the conversion process.
    """
    
    def __init__(self):
        self.solidity_file = None
        self.output_file = None
    
    def parse_contract_name(self, content):
        """Extract contract name from Solidity code."""
        match = re.search(r'contract\s+(\w+)', content)
        if match:
            return match.group(1)
        return None
    
    def parse_functions(self, content):
        """Extract function definitions from Solidity code."""
        functions = []
        for match in re.finditer(r'function\s+(\w+)\s*\(([^)]*)\)([^{]*){', content):
            name = match.group(1)
            params = match.group(2).strip()
            modifiers = match.group(3).strip()
            
            # Check if function is a view (for endpoints vs views)
            is_view = 'view' in modifiers
            
            # Check return type
            returns_match = re.search(r'returns\s*\(([^)]*)\)', modifiers)
            return_type = returns_match.group(1).strip() if returns_match else None
            
            functions.append({
                'name': name,
                'params': params,
                'is_view': is_view,
                'return_type': return_type
            })
        
        return functions
    
    def parse_events(self, content):
        """Extract event definitions from Solidity code."""
        events = []
        for match in re.finditer(r'event\s+(\w+)\s*\(([^)]*)\)', content):
            name = match.group(1)
            params = match.group(2).strip()
            events.append({
                'name': name,
                'params': params
            })
        
        return events
    
    def parse_structs(self, content):
        """Extract struct definitions from Solidity code."""
        structs = []
        for match in re.finditer(r'struct\s+(\w+)\s*{([^}]*)}', content):
            name = match.group(1)
            fields = match.group(2).strip()
            structs.append({
                'name': name,
                'fields': fields
            })
        
        return structs
    
    def camel_to_snake(self, name):
        """Convert camelCase to snake_case."""
        s1 = re.sub('(.)([A-Z][a-z]+)', r'\1_\2', name)
        return re.sub('([a-z0-9])([A-Z])', r'\1_\2', s1).lower()
    
    def convert_function(self, func):
        """Convert a Solidity function to MultiversX format."""
        name = func['name']
        snake_name = self.camel_to_snake(name)
        
        # Determine if it's an endpoint or view
        if func['is_view']:
            annotation = f'#[view({name})]\n    '
        else:
            annotation = '#[endpoint]\n    '
        
        # Transform parameters by converting types
        params = []
        if func['params']:
            for param in func['params'].split(','):
                param = param.strip()
                if param:
                    parts = param.split()
                    if len(parts) >= 2:
                        param_type = parts[0]
                        param_name = parts[1].rstrip(',')
                        
                        # Map Solidity types to MultiversX types
                        if param_type == 'uint256':
                            param_type = 'BigUint<Self::Api>'
                        elif param_type == 'address':
                            param_type = 'ManagedAddress<Self::Api>'
                        elif param_type == 'string':
                            param_type = 'ManagedBuffer<Self::Api>'
                        
                        params.append(f'{param_name}: {param_type}')
        
        # Determine return type
        return_type = ''
        if func['return_type']:
            rt = func['return_type'].split()[0]
            if rt == 'uint256':
                return_type = ' -> BigUint<Self::Api>'
            elif rt == 'address':
                return_type = ' -> ManagedAddress<Self::Api>'
            elif rt == 'string':
                return_type = ' -> ManagedBuffer<Self::Api>'
            elif rt == 'bool':
                return_type = ' -> bool'
        
        # Build function definition
        func_def = f"{annotation}fn {snake_name}(&self{', ' if params else ''}{', '.join(params)}){return_type} {{\n        // Function body would go here\n    }}"
        
        return func_def
    
    def convert_event(self, event):
        """Convert a Solidity event to MultiversX format."""
        name = event['name']
        snake_name = self.camel_to_snake(name)
        
        # Transform parameters
        params = []
        if event['params']:
            for param in event['params'].split(','):
                param = param.strip()
                if param:
                    is_indexed = 'indexed' in param
                    param = param.replace('indexed', '').strip()
                    parts = param.split()
                    if len(parts) >= 2:
                        param_type = parts[0]
                        param_name = parts[1]
                        
                        # Map Solidity types to MultiversX types
                        if param_type == 'uint256':
                            param_type = 'BigUint<Self::Api>'
                        elif param_type == 'address':
                            param_type = 'ManagedAddress<Self::Api>'
                        elif param_type == 'string':
                            param_type = 'ManagedBuffer<Self::Api>'
                        
                        indexed_str = '#[indexed] ' if is_indexed else ''
                        params.append(f'{indexed_str}{param_name}: {param_type}')
        
        # Build event definition
        event_def = f'#[event("{name}")]\n    fn {snake_name}_event(&self{", " if params else ""}{", ".join(params)});'
        
        return event_def
    
    def convert_struct(self, struct):
        """Convert a Solidity struct to MultiversX format."""
        name = struct['name']
        
        # Transform fields
        fields = []
        if struct['fields']:
            for field in struct['fields'].split(';'):
                field = field.strip()
                if field:
                    parts = field.split()
                    if len(parts) >= 2:
                        field_type = parts[0]
                        field_name = parts[1]
                        
                        # Map Solidity types to MultiversX types
                        if field_type == 'uint256':
                            field_type = 'BigUint<M>'
                        elif field_type == 'address':
                            field_type = 'ManagedAddress<M>'
                        elif field_type == 'string':
                            field_type = 'ManagedBuffer<M>'
                        elif field_type == 'bool':
                            field_type = 'bool'
                        
                        fields.append(f'pub {field_name}: {field_type}')
        
        # Build struct definition
        fields_str = ",\n    ".join(fields)
        struct_def = (
            "#[derive(TypeAbi, TopEncode, TopDecode, NestedEncode, NestedDecode, ManagedVecItem)]\n"
            f"pub struct {name}<M: ManagedTypeApi> {{\n"
            f"    {fields_str}\n"
            "}"
        )
        
        return struct_def
    
    def convert_solidity_to_multiversx(self, solidity_content):
        """Convert Solidity code to MultiversX Rust code."""
        contract_name = self.parse_contract_name(solidity_content)
        functions = self.parse_functions(solidity_content)
        events = self.parse_events(solidity_content)
        structs = self.parse_structs(solidity_content)
        
        # Build the MultiversX Rust file
        rust_code = []
        rust_code.append('#![no_std]\n')
        rust_code.append('use multiversx_sc::imports::*;')
        rust_code.append('use multiversx_sc::derive_imports::*;\n')
        
        # Add struct definitions
        for struct in structs:
            rust_code.append(self.convert_struct(struct))
        
        if structs:
            rust_code.append('')  # Empty line after structs
        
        # Add contract trait
        rust_code.append(f'#[multiversx_sc::contract]')
        rust_code.append(f'pub trait {contract_name} {{')
        
        # Add storage mappers
        # For simplicity, extract variables from the Solidity code
        storage_vars = re.findall(r'(\w+)(?:\s+public)?\s+(\w+);', solidity_content)
        for var_type, var_name in storage_vars:
            if var_type in ['uint256', 'string', 'address', 'bool']:
                # Map Solidity types to MultiversX types
                if var_type == 'uint256':
                    mapper_type = 'BigUint<Self::Api>'
                elif var_type == 'address':
                    mapper_type = 'ManagedAddress<Self::Api>'
                elif var_type == 'string':
                    mapper_type = 'ManagedBuffer<Self::Api>'
                elif var_type == 'bool':
                    mapper_type = 'bool'
                
                snake_name = self.camel_to_snake(var_name)
                rust_code.append(f'    #[storage_mapper("{var_name}")]')
                rust_code.append(f'    fn {snake_name}(&self) -> SingleValueMapper<{mapper_type}>;')
                rust_code.append('')
        
        # Add events
        for event in events:
            rust_code.append(f'    {self.convert_event(event)}')
            rust_code.append('')
        
        # Add init function
        rust_code.append('    #[init]')
        rust_code.append('    fn init(&self) {}')
        rust_code.append('')
        
        # Add the rest of the functions
        for func in functions:
            if func['name'] != '':  # Skip constructor
                rust_code.append(f'    {self.convert_function(func)}')
                rust_code.append('')
        
        # Close the contract trait
        rust_code.append('}')
        
        return '\n'.join(rust_code)
    
    def transpile(self, input_file, output_file=None):
        """Transpile a Solidity file to MultiversX Rust."""
        self.solidity_file = input_file
        
        if output_file is None:
            output_file = input_file.replace('.sol', '.rs')
        self.output_file = output_file
        
        try:
            with open(input_file, 'r') as f:
                solidity_content = f.read()
            
            rust_code = self.convert_solidity_to_multiversx(solidity_content)
            
            with open(output_file, 'w') as f:
                f.write(rust_code)
            
            print(f"Successfully transpiled {input_file} to {output_file}")
            return True
        except Exception as e:
            print(f"Error during transpilation: {str(e)}")
            return False

def main():
    """Main function to run the transpiler."""
    if len(sys.argv) < 2:
        print("Usage: python simplified_transpiler.py <solidity_file.sol> [output_file.rs]")
        return 1
    
    input_file = sys.argv[1]
    output_file = sys.argv[2] if len(sys.argv) > 2 else None
    
    transpiler = SimplifiedTranspiler()
    result = transpiler.transpile(input_file, output_file)
    
    return 0 if result else 1

if __name__ == "__main__":
    sys.exit(main()) 