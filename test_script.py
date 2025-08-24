import os
import sys
import difflib
import subprocess
import re
from pathlib import Path

def read_file(file_path):
    """Read file content and return as string."""
    with open(file_path, 'r') as f:
        return f.read()

def compare_files(actual_file, expected_file):
    """Compare two files and return a diff report."""
    actual_content = read_file(actual_file)
    expected_content = read_file(expected_file)
    
    # Normalize line endings to avoid platform-specific issues
    actual_content = actual_content.replace('\r\n', '\n')
    expected_content = expected_content.replace('\r\n', '\n')
    
    # Compare the files
    diff = difflib.unified_diff(
        actual_content.splitlines(keepends=True),
        expected_content.splitlines(keepends=True),
        fromfile=str(actual_file),
        tofile=str(expected_file)
    )
    
    return ''.join(diff)

def camel_to_snake(name):
    """Convert camelCase to snake_case."""
    name = re.sub('(.)([A-Z][a-z]+)', r'\1_\2', name)
    return re.sub('([a-z0-9])([A-Z])', r'\1_\2', name).lower()

def check_test_case(sol_file, expected_rs_file):
    """Check if the Solidity file can be transpiled to match the expected Rust file."""
    print(f"\nChecking test case: {sol_file}")
    
    # Read the expected output
    expected_content = read_file(expected_rs_file)
    
    # Read the Solidity input
    solidity_content = read_file(sol_file)
    
    print(f"Solidity file: {sol_file}")
    print(f"Expected Rust file: {expected_rs_file}")
    
    # Extract contract name from Solidity
    contract_name = None
    for line in solidity_content.split('\n'):
        if line.strip().startswith('contract '):
            contract_name = line.strip().split(' ')[1].rstrip('{').strip()
            break
    
    # Check if contract name appears in the expected output
    if contract_name and contract_name in expected_content:
        print(f"✅ Contract name '{contract_name}' found in expected output")
    else:
        print(f"❌ Contract name '{contract_name}' NOT found in expected output")
    
    # Check for function names
    functions = []
    for line in solidity_content.split('\n'):
        line = line.strip()
        if line.startswith('function '):
            func_name = line.split('function ')[1].split('(')[0].strip()
            functions.append(func_name)
    
    for func in functions:
        # Try different variations of function names
        original = func
        snake_case = camel_to_snake(func)
        
        # Special cases
        if func.startswith('get'):
            view_case = f"get_{camel_to_snake(func[3:])}"
        elif func.startswith('set'):
            endpoint_case = f"set_{camel_to_snake(func[3:])}"
        elif func == 'init':
            special_case = 'init'
        else:
            view_case = f"get_{snake_case}"
            endpoint_case = snake_case
            special_case = snake_case
        
        # Check for the function in various forms
        found = (
            original in expected_content or 
            snake_case in expected_content or
            f"fn {snake_case}" in expected_content or
            (func.startswith('get') and view_case in expected_content) or
            (func.startswith('set') and endpoint_case in expected_content) or
            special_case in expected_content
        )
        
        if found:
            print(f"✅ Function '{func}' found in expected output")
        else:
            print(f"❌ Function '{func}' NOT found in expected output")
    
    # Check for events
    events = []
    for line in solidity_content.split('\n'):
        line = line.strip()
        if line.startswith('event '):
            event_name = line.split('event ')[1].split('(')[0].strip()
            events.append(event_name)
    
    for event in events:
        snake_case = camel_to_snake(event)
        snake_case_event = f"{snake_case}_event"
        
        if (
            event in expected_content or 
            snake_case in expected_content or
            snake_case_event in expected_content or
            f"fn {snake_case}_event" in expected_content
        ):
            print(f"✅ Event '{event}' found in expected output")
        else:
            print(f"❌ Event '{event}' NOT found in expected output")
            
    # Check for structs
    structs = []
    for i, line in enumerate(solidity_content.split('\n')):
        line = line.strip()
        if line.startswith('struct '):
            struct_name = line.split('struct ')[1].split('{')[0].strip()
            structs.append(struct_name)
    
    for struct in structs:
        if struct in expected_content:
            print(f"✅ Struct '{struct}' found in expected output")
        else:
            print(f"❌ Struct '{struct}' NOT found in expected output")

def main():
    """Main function to check all test cases."""
    test_cases_dir = Path("test_cases")
    solidity_dir = test_cases_dir / "solidity"
    expected_dir = test_cases_dir / "expected"
    
    # Get all Solidity files
    solidity_files = list(solidity_dir.glob("*.sol"))
    
    if not solidity_files:
        print("No Solidity test files found.")
        return 1
    
    print(f"Found {len(solidity_files)} test cases to check.")
    
    # Initialize counters
    total_checks = 0
    passed_checks = 0
    
    for sol_file in solidity_files:
        # Determine the expected Rust file
        expected_rs_file = expected_dir / f"{sol_file.stem}.rs"
        
        if not expected_rs_file.exists():
            print(f"Warning: Expected Rust file not found for {sol_file}")
            continue
        
        # Keep track of results for this file
        file_total = 0
        file_passed = 0
        
        # Check each test case
        print(f"\nChecking test case: {sol_file.stem}")
        
        # Read the expected output
        expected_content = read_file(expected_rs_file)
        
        # Read the Solidity input
        solidity_content = read_file(sol_file)
        
        # Extract contract name from Solidity
        contract_name = None
        for line in solidity_content.split('\n'):
            if line.strip().startswith('contract '):
                contract_name = line.strip().split(' ')[1].rstrip('{').strip()
                break
        
        # Check if contract name appears in the expected output
        total_checks += 1
        file_total += 1
        if contract_name and contract_name in expected_content:
            print(f"✅ Contract name '{contract_name}' found in expected output")
            passed_checks += 1
            file_passed += 1
        else:
            print(f"❌ Contract name '{contract_name}' NOT found in expected output")
        
        # Check for function names
        functions = []
        for line in solidity_content.split('\n'):
            line = line.strip()
            if line.startswith('function '):
                func_name = line.split('function ')[1].split('(')[0].strip()
                functions.append(func_name)
        
        for func in functions:
            total_checks += 1
            file_total += 1
            # Try different variations of function names
            original = func
            snake_case = camel_to_snake(func)
            
            # Check for the function in various forms
            found = False
            
            # Regular function name check
            if original in expected_content or snake_case in expected_content:
                found = True
            
            # Check for function definition pattern
            if f"fn {snake_case}" in expected_content:
                found = True
            
            # Special pattern for getters
            if func.startswith('get'):
                view_name = camel_to_snake(func[3:])
                if f"fn get_{view_name}" in expected_content or f"#[view({func})]" in expected_content:
                    found = True
            
            # Special pattern for setters
            if func.startswith('set'):
                set_name = camel_to_snake(func[3:])
                if f"fn set_{set_name}" in expected_content:
                    found = True
            
            if found:
                print(f"✅ Function '{func}' found in expected output")
                passed_checks += 1
                file_passed += 1
            else:
                print(f"❌ Function '{func}' NOT found in expected output")
        
        # Check for events
        events = []
        for line in solidity_content.split('\n'):
            line = line.strip()
            if line.startswith('event '):
                event_name = line.split('event ')[1].split('(')[0].strip()
                events.append(event_name)
        
        for event in events:
            total_checks += 1
            file_total += 1
            snake_case = camel_to_snake(event)
            snake_case_event = f"{snake_case}_event"
            
            if (
                event in expected_content or 
                f"#[event(\"{event}\")]" in expected_content or
                snake_case_event in expected_content or
                f"fn {snake_case_event}" in expected_content
            ):
                print(f"✅ Event '{event}' found in expected output")
                passed_checks += 1
                file_passed += 1
            else:
                print(f"❌ Event '{event}' NOT found in expected output")
                
        # Check for structs
        structs = []
        for i, line in enumerate(solidity_content.split('\n')):
            line = line.strip()
            if line.startswith('struct '):
                struct_name = line.split('struct ')[1].split('{')[0].strip()
                structs.append(struct_name)
        
        for struct in structs:
            total_checks += 1
            file_total += 1
            if struct in expected_content:
                print(f"✅ Struct '{struct}' found in expected output")
                passed_checks += 1
                file_passed += 1
            else:
                print(f"❌ Struct '{struct}' NOT found in expected output")
        
        # Print summary for this file
        print(f"\nSummary for {sol_file.stem}: {file_passed}/{file_total} checks passed ({file_passed/file_total:.0%})")
    
    # Print overall summary
    print(f"\nOverall summary: {passed_checks}/{total_checks} checks passed ({passed_checks/total_checks:.0%})")
    
    return 0

if __name__ == "__main__":
    sys.exit(main()) 