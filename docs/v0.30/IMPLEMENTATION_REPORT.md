# XTract v0.30 - Implementation Report

## Executive Summary

This document details the technical implementation of XTract v0.30, focusing on the new features: nested mapping support, function modifiers, basic inheritance, and enhanced error handling.

## Architecture Overview

### Core Components

```
xtract/
├── transpiler.py      # Core transpilation logic (~1000 lines)
├── cli.py             # Command-line interface
└── __init__.py        # Package initialization

tests/
└── test_transpiler_core.py  # Test suite (64 tests)

test_cases/
├── solidity/          # 50 Solidity input files
└── expected/          # 50 expected Rust output files
```

### Transpilation Pipeline

```
Solidity Source
      │
      ▼
┌─────────────────┐
│  Validation &   │
│  Diagnostics    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Parse Contract │
│  - Name         │
│  - Inheritance  │
│  - Modifiers    │
│  - Storage      │
│  - Events       │
│  - Functions    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Convert to     │
│  MultiversX Rust│
└────────┬────────┘
         │
         ▼
   Rust Output
```

## Implementation Details

### 1. Nested Mapping Support

#### Problem
Solidity nested mappings like `mapping(address => mapping(address => uint256))` require two keys for access.

#### Solution

**Storage Extraction** (`_extract_storage`):
```python
# Nested mappings: mapping(type1 => mapping(type2 => type3))
for match in re.finditer(
    r"mapping\s*\(\s*(\w+)\s*=>\s*mapping\s*\(\s*(\w+)\s*=>\s*(\w+)\s*\)\s*\)\s*(?:public|private|internal|external)?\s*(\w+)\s*;",
    content
):
    key1_type = match.group(1).strip()
    key2_type = match.group(2).strip()
    value_type = match.group(3).strip()
    var_name = match.group(4)
    vars.append(("nested_mapping", var_name, f"{key1_type}=>{key2_type}=>{value_type}"))
```

**Storage Mapper Generation**:
```python
if var_type == "nested_mapping":
    parts = mapping_info.split("=>")
    if len(parts) == 3:
        key1_type = parts[0].strip()
        key2_type = parts[1].strip()
        lines.append(f"#[storage_mapper(\"{var_name}\")]")
        lines.append(f"fn {snake_name}(&self, key1: &{self._map_type(key1_type)}, key2: &{self._map_type(key2_type)}) -> {mapper_t};")
```

**Expression Conversion**:
```python
# Handle nested mapping access like allowance[from][to] -> self.allowance(&from, &to)
expr = re.sub(r'(\w+)\[([^\]]+)\]\[([^\]]+)\]', r'self.\1(&\2, &\3)', expr)
```

#### Output Example

Input:
```solidity
mapping(address => mapping(address => uint256)) public allowance;
```

Output:
```rust
#[storage_mapper("allowance")]
fn allowance(&self, key1: &ManagedAddress<Self::Api>, key2: &ManagedAddress<Self::Api>)
    -> SingleValueMapper<BigUint<Self::Api>>;
```

### 2. Function Modifier Support

#### Problem
Solidity modifiers like `onlyOwner` add preconditions to functions. These need to be inlined into MultiversX functions.

#### Solution

**Modifier Parsing** (`parse_modifiers`):
```python
def parse_modifiers(self, content: str):
    modifiers = {}
    for match in re.finditer(
        r"modifier\s+(\w+)\s*\(([^)]*)\)\s*\{([^}]*(?:\{[^}]*\}[^}]*)*)\}",
        content, re.DOTALL
    ):
        name = match.group(1)
        body = match.group(3).strip()

        # Extract require condition
        require_match = re.search(
            r'require\s*\(([^,)]+)(?:,\s*["\']([^"\']+)["\'])?\s*\)',
            body
        )
        if require_match:
            modifiers[name] = {
                "condition": require_match.group(1).strip(),
                "message": require_match.group(2) or f"{name} check failed"
            }
    return modifiers
```

**Function Modifier Detection** (`parse_functions`):
```python
# Extract applied modifiers
modifier_text = modifiers_str
for keyword in ['public', 'private', 'view', 'pure', 'payable']:
    modifier_text = re.sub(rf'\b{keyword}\b', '', modifier_text)
modifier_text = re.sub(r'returns\s*\([^)]*\)', '', modifier_text)

for mod_match in re.finditer(r'(\w+)(?:\s*\([^)]*\))?', modifier_text):
    mod_name = mod_match.group(1).strip()
    if mod_name:
        applied_modifiers.append(mod_name)
```

**Modifier Injection** (`convert_function`):
```python
if modifiers and func.get("applied_modifiers"):
    for mod_name in func["applied_modifiers"]:
        if mod_name in modifiers:
            mod = modifiers[mod_name]
            if mod.get("condition"):
                converted_condition = self._convert_expression(mod["condition"])
                message = mod.get("message")
                body_lines.append(f'require!({converted_condition}, "{message}");')
```

#### Output Example

Input:
```solidity
modifier onlyOwner() {
    require(msg.sender == owner, "Not owner");
    _;
}

function withdraw() public onlyOwner {
    // ...
}
```

Output:
```rust
#[endpoint]
fn withdraw(&self) {
    require!(self.blockchain().get_caller() == self.owner().get(), "Not owner");
    // ...
}
```

### 3. Basic Inheritance Support

#### Problem
Solidity inheritance (`contract A is B, C`) needs to be represented in Rust traits.

#### Solution

**Inheritance Parsing** (`parse_inheritance`):
```python
def parse_inheritance(self, content: str) -> list[str]:
    # Remove comments first
    content_no_comments = re.sub(r'//.*$', '', content, flags=re.MULTILINE)
    content_no_comments = re.sub(r'/\*.*?\*/', '', content_no_comments, flags=re.DOTALL)

    parents = []
    match = re.search(r"contract\s+\w+\s+is\s+([^{]+)\s*\{", content_no_comments)
    if match:
        parents_str = match.group(1).strip()
        for parent in parents_str.split(","):
            parent_name = parent.strip()
            parent_name = re.sub(r'\([^)]*\)', '', parent_name).strip()
            if parent_name:
                parents.append(parent_name)
    return parents
```

**Supertrait Generation** (`convert`):
```python
if parents:
    lines.append(f"// Inherits from: {', '.join(parents)}\n")

# ...

if parents:
    supertraits = " + ".join(parents)
    lines.append(f"pub trait {name}: {supertraits} {{")
else:
    lines.append(f"pub trait {name} {{")
```

#### Output Example

Input:
```solidity
contract Token is Ownable, Pausable {
    // ...
}
```

Output:
```rust
// Inherits from: Ownable, Pausable

#[multiversx_sc::contract]
pub trait Token: Ownable + Pausable {
    // ...
}
```

### 4. Enhanced Error Handling and Diagnostics

#### Problem
Users need visibility into unsupported features and potential issues.

#### Solution

**Dataclasses** (`TranspilationWarning`, `TranspilationResult`):
```python
@dataclass
class TranspilationWarning:
    message: str
    line: Optional[int] = None
    severity: str = "warning"  # warning, info, error

@dataclass
class TranspilationResult:
    code: str
    success: bool = True
    warnings: list[TranspilationWarning] = field(default_factory=list)
    errors: list[str] = field(default_factory=list)
```

**Validation** (`validate_and_diagnose`):
```python
def validate_and_diagnose(self, content: str) -> TranspilationResult:
    result = TranspilationResult(code="")

    unsupported_patterns = [
        (r'\bfor\s*\(', "For loops are not yet supported"),
        (r'\bwhile\s*\(', "While loops are not yet supported"),
        (r'\bif\s*\(', "If statements are not yet fully supported"),
        (r'\bassembly\s*\{', "Inline assembly is not supported"),
        # ... more patterns
    ]

    for pattern, message in unsupported_patterns:
        if re.search(pattern, content):
            result.add_warning(message)

    return result
```

**CLI Integration**:
```python
if verbose:
    result = transpile_with_diagnostics(input, out)

    if result.warnings:
        click.echo(click.style("\nDiagnostics:", fg="yellow", bold=True))
        for warning in result.warnings:
            color = "yellow" if warning.severity == "warning" else "cyan"
            prefix = "⚠️ " if warning.severity == "warning" else "ℹ️ "
            click.echo(click.style(f"  {prefix}{warning.message}", fg=color))
```

## Type System

### Type Mapping

| Solidity Type | MultiversX Type |
|---------------|-----------------|
| uint256 | BigUint<Self::Api> |
| uint128 | BigUint<Self::Api> |
| uint64 | u64 |
| uint32 | u32 |
| uint16 | u16 |
| uint8 | u8 |
| int256 | BigInt<Self::Api> |
| address | ManagedAddress<Self::Api> |
| string | ManagedBuffer<Self::Api> |
| bool | bool |

### Storage Mapper Types

| Pattern | Mapper Type |
|---------|-------------|
| Simple variable | SingleValueMapper<T> |
| mapping(K => V) | SingleValueMapper<V> (with key param) |
| mapping(K1 => mapping(K2 => V)) | SingleValueMapper<V> (with 2 key params) |

## Test Architecture

### Parametrized Testing

```python
TEST_CASES = get_test_files()

@pytest.mark.parametrize("name,sol_path,expected_path", TEST_CASES, ids=[t[0] for t in TEST_CASES])
def test_transpilation(name, sol_path, expected_path):
    sol = load(sol_path)
    expected = load(expected_path)
    actual = Transpiler().convert(sol)

    expected_normalized = normalize(expected)
    actual_normalized = normalize(actual)

    if expected_normalized != actual_normalized:
        # Show diff
        assert False, f"Mismatch for {name}"
```

### Feature-Specific Tests

```python
def test_nested_mapping_features():
    """Test nested mapping transpilation"""
    sol = load("test_cases/solidity/NestedMapping.sol")
    actual = Transpiler().convert(sol)

    assert "#[storage_mapper(\"allowance\")]" in actual
    assert "key1:" in actual or "key2:" in actual

def test_modifier_features():
    """Test modifier transpilation"""
    sol = load("test_cases/solidity/OnlyOwner.sol")
    actual = Transpiler().convert(sol)

    assert "require!" in actual
```

### Diagnostic Tests

```python
def test_validation_detects_loops():
    sol_with_loop = """
    contract LoopContract {
        function test() public {
            for (uint i = 0; i < 10; i++) { }
        }
    }
    """

    result = Transpiler().validate_and_diagnose(sol_with_loop)
    warning_messages = [w.message for w in result.warnings]
    assert any("loop" in msg.lower() for msg in warning_messages)
```

## Performance

- **Parse Time**: <1ms per contract
- **Convert Time**: <5ms per contract
- **Full Test Suite**: ~50ms for 64 tests

## Code Statistics

| File | Lines | Functions |
|------|-------|-----------|
| transpiler.py | ~1000 | 25+ |
| cli.py | ~60 | 1 |
| test_transpiler_core.py | ~250 | 15+ |

## Known Limitations

1. **Loop Constructs**: for/while loops not yet supported
2. **Conditionals**: if/else requires manual review
3. **Assembly**: Inline assembly not supported
4. **Libraries**: Require manual flattening
5. **Complex Inheritance**: Diamond patterns need care

## Future Work

1. Loop support (for, while)
2. Full if/else support
3. Advanced inheritance patterns
4. External contract calls
5. npm package publication
