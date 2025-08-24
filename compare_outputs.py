#!/usr/bin/env python3

import os
import sys
import difflib
import re
from pathlib import Path

def read_file(file_path):
    """Read file content and return as string."""
    with open(file_path, 'r') as f:
        return f.read()

def normalize_code(content):
    """Normalize code by removing whitespace and comments for comparison."""
    # Remove comments
    content = re.sub(r'//.*?\n', '\n', content)
    content = re.sub(r'/\*.*?\*/', '', content, flags=re.DOTALL)
    
    # Remove empty lines
    content = re.sub(r'\n\s*\n', '\n', content)
    
    # Remove trailing whitespace
    content = re.sub(r'\s+$', '', content, flags=re.MULTILINE)
    
    # Convert to lowercase for case-insensitive comparison
    content = content.lower()
    
    return content

def extract_key_elements(content):
    """Extract key elements like struct names, function names, etc."""
    elements = {
        'contract_name': None,
        'structs': [],
        'events': [],
        'functions': [],
        'storage_mappers': []
    }
    
    # Extract contract name
    contract_match = re.search(r'pub\s+trait\s+(\w+)', content)
    if contract_match:
        elements['contract_name'] = contract_match.group(1)
    
    # Extract struct names
    for struct_match in re.finditer(r'pub\s+struct\s+(\w+)', content):
        elements['structs'].append(struct_match.group(1))
    
    # Extract event names
    for event_match in re.finditer(r'fn\s+(\w+)_event', content):
        elements['events'].append(event_match.group(1))
    
    # Extract function names
    for func_match in re.finditer(r'fn\s+(\w+)\s*\(', content):
        func_name = func_match.group(1)
        if func_name != 'init' and not func_name.endswith('_event'):
            elements['functions'].append(func_name)
    
    # Extract storage mappers
    for mapper_match in re.finditer(r'fn\s+(\w+)\s*\(\s*&self\s*\)\s*->\s*SingleValueMapper', content):
        elements['storage_mappers'].append(mapper_match.group(1))
    
    return elements

def compare_files(generated_file, expected_file):
    """Compare two files and print a summary of differences."""
    print(f"Comparing {os.path.basename(generated_file)} with {os.path.basename(expected_file)}")
    
    # Read file contents
    generated_content = read_file(generated_file)
    expected_content = read_file(expected_file)
    
    # Extract key elements
    generated_elements = extract_key_elements(generated_content)
    expected_elements = extract_key_elements(expected_content)
    
    # Compare contract names
    if generated_elements['contract_name'] == expected_elements['contract_name']:
        print(f"✅ Contract name: {generated_elements['contract_name']}")
    else:
        print(f"❌ Contract name mismatch: {generated_elements['contract_name']} vs {expected_elements['contract_name']}")
    
    # Compare structs
    print("\nStructs:")
    for struct in expected_elements['structs']:
        if struct.lower() in [s.lower() for s in generated_elements['structs']]:
            print(f"✅ {struct}")
        else:
            print(f"❌ Missing struct: {struct}")
    
    # Compare events
    print("\nEvents:")
    for event in expected_elements['events']:
        if event.lower() in [e.lower() for e in generated_elements['events']]:
            print(f"✅ {event}")
        else:
            print(f"❌ Missing event: {event}")
    
    # Compare functions
    print("\nFunctions:")
    for func in expected_elements['functions']:
        if func.lower() in [f.lower() for f in generated_elements['functions']]:
            print(f"✅ {func}")
        else:
            print(f"❌ Missing function: {func}")
    
    # Compare storage mappers
    print("\nStorage Mappers:")
    for mapper in expected_elements['storage_mappers']:
        if mapper.lower() in [m.lower() for m in generated_elements['storage_mappers']]:
            print(f"✅ {mapper}")
        else:
            print(f"❌ Missing storage mapper: {mapper}")
    
    print("\n" + "="*50 + "\n")

def main():
    """Main function to compare all transpiled outputs."""
    # Define file pairs for comparison
    file_pairs = [
        ('output_simple_storage.rs', 'test_cases/expected/SimpleStorage.rs'),
        ('output_erc20.rs', 'test_cases/expected/ERC20Token.rs'),
        ('output_nft.rs', 'test_cases/expected/NFTMarketplace.rs'),
        ('output_voting.rs', 'test_cases/expected/Voting.rs'),
        ('output_crowdfunding.rs', 'test_cases/expected/Crowdfunding.rs')
    ]
    
    for generated, expected in file_pairs:
        if os.path.exists(generated) and os.path.exists(expected):
            compare_files(generated, expected)
        else:
            if not os.path.exists(generated):
                print(f"Error: Generated file {generated} does not exist")
            if not os.path.exists(expected):
                print(f"Error: Expected file {expected} does not exist")

if __name__ == "__main__":
    main() 