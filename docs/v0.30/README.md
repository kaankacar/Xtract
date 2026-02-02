# XTract v0.30.1 - Beta Release

XTract is a Solidity to MultiversX Rust smart contract transpiler. This release expands Solidity feature support with control flow transpilation and includes extensive testing.

## Release Highlights

- **Expanded Mapping Support**: Full support for single and nested mappings
- **Function Modifiers**: Support for custom modifiers like `onlyOwner`
- **Basic Inheritance**: Contract inheritance with supertrait generation
- **Enhanced Diagnostics**: Comprehensive error handling and warnings
- **Control Flow Transpilation**: Full support for if/else, for loops, and while loops
- **Payable Functions**: Automatic `#[payable("EGLD")]` annotation
- **50 Test Cases**: Extensive test coverage across various contract patterns

## New Features

### Nested Mappings

```solidity
mapping(address => mapping(address => uint256)) public allowance;
```

Transpiles to:

```rust
#[storage_mapper("allowance")]
fn allowance(&self, key1: &ManagedAddress<Self::Api>, key2: &ManagedAddress<Self::Api>)
    -> SingleValueMapper<BigUint<Self::Api>>;
```

### Function Modifiers

```solidity
modifier onlyOwner() {
    require(msg.sender == owner, "Not owner");
    _;
}

function withdraw() public onlyOwner {
    // ...
}
```

Transpiles to:

```rust
#[endpoint]
fn withdraw(&self) {
    require!(self.blockchain().get_caller() == self.owner().get(), "Not owner");
    // ...
}
```

### Basic Inheritance

```solidity
contract Token is Ownable, Pausable {
    // ...
}
```

Transpiles to:

```rust
// Inherits from: Ownable, Pausable

#[multiversx_sc::contract]
pub trait Token: Ownable + Pausable {
    // ...
}
```

### Payable Functions

```solidity
function deposit() public payable {
    balances[msg.sender] += msg.value;
}
```

Transpiles to:

```rust
#[payable("EGLD")]
#[endpoint]
fn deposit(&self) {
    // Payable annotation automatically added
}
```

### If/Else Statements

```solidity
function checkValue(uint256 x) public view returns (bool) {
    if (x > 100) {
        return true;
    } else {
        return false;
    }
}
```

Transpiles to:

```rust
#[view(checkValue)]
fn check_value(&self, x: BigUint<Self::Api>) -> bool {
    if x > BigUint::from(100u32) {
        return true;
    } else {
        return false;
    }
}
```

### For Loops

```solidity
function sumArray(uint256 n) public pure returns (uint256) {
    uint256 sum = 0;
    for (uint i = 0; i < n; i++) {
        sum += i;
    }
    return sum;
}
```

Transpiles to:

```rust
#[endpoint]
fn sum_array(&self, n: BigUint<Self::Api>) -> BigUint<Self::Api> {
    let mut sum = BigUint::from(0u32);
    for i in 0..n {
        sum += i;
    }
    return sum;
}
```

### While Loops

```solidity
function countdown(uint256 start) public pure returns (uint256) {
    uint256 count = start;
    while (count > 0) {
        count--;
    }
    return count;
}
```

Transpiles to:

```rust
#[endpoint]
fn countdown(&self, start: BigUint<Self::Api>) -> BigUint<Self::Api> {
    let mut count = start;
    while count > BigUint::from(0u32) {
        count -= BigUint::from(1u32);
    }
    return count;
}
```

### Enhanced Diagnostics

The transpiler now provides detailed diagnostics for unsupported features:

```bash
xtract -v MyContract.sol

Diagnostics:
  ⚠️ Do-while loops are not yet supported - manual conversion required
  ⚠️ Inline assembly is not supported
  ℹ️ Interface detected - will be converted to trait

✅ Wrote MyContract.rs
```

## Test Coverage

This release includes 50 Solidity test cases covering:

| Category | Test Cases | Status |
|----------|------------|--------|
| Basic Contracts | 5 | ✅ Pass |
| Mappings (Single) | 15 | ✅ Pass |
| Mappings (Nested) | 5 | ✅ Pass |
| Function Modifiers | 10 | ✅ Pass |
| Inheritance | 3 | ✅ Pass |
| DeFi Patterns | 12 | ✅ Pass |

**Total: 50 test cases, 64 test functions, 100% passing**

## Installation

### Via npm (recommended)

```bash
npm install -g xtract-cli
```

**npm package:** [https://www.npmjs.com/package/xtract-cli](https://www.npmjs.com/package/xtract-cli)

### Via pip (Python)

```bash
pip install xtract
```

## Usage

```bash
# Basic usage
xtract MyContract.sol

# With verbose output (show diagnostics)
xtract -v MyContract.sol output.rs

# Quiet mode
xtract -q MyContract.sol
```

## Supported Solidity Features

### Fully Supported
- ✅ Contract declarations
- ✅ State variables (all types)
- ✅ Single mappings
- ✅ Nested mappings (address => mapping(address => uint256))
- ✅ Events with indexed parameters
- ✅ Custom errors
- ✅ Structs
- ✅ Functions (public, private, view)
- ✅ Constructors
- ✅ Function modifiers (onlyOwner, custom)
- ✅ Basic inheritance
- ✅ require/revert statements
- ✅ Payable functions (automatic #[payable("EGLD")] annotation)
- ✅ If/else statements
- ✅ For loops (counter-based)
- ✅ While loops

### Requires Manual Review
- ⚠️ Complex expressions (may need adjustment)
- ⚠️ External contract calls

### Not Yet Supported
- ❌ Do-while loops
- ❌ Inline assembly
- ❌ Try-catch blocks
- ❌ Libraries
- ❌ Diamond inheritance

## Migration from v0.25

No breaking changes. v0.30 is fully backward compatible with v0.25.

New features are additive:
- Nested mappings now work automatically
- Modifiers are now converted to require! checks
- Inheritance generates supertrait bounds

## Documentation

- [CHANGELOG.md](./CHANGELOG.md) - Detailed change log
- [IMPLEMENTATION_REPORT.md](./IMPLEMENTATION_REPORT.md) - Technical implementation details
- [IMPLEMENTATION_SUMMARY.md](./IMPLEMENTATION_SUMMARY.md) - Feature summary
- [TEST_RESULTS.md](./TEST_RESULTS.md) - Complete test results

## Next Steps

Upcoming features:
- Advanced inheritance patterns (diamond inheritance)
- External contract calls
- Do-while loops
- Try-catch block handling
- SDK development for seamless MultiversX integration
- Real-world sample projects for contract deployment

## License

MIT License
