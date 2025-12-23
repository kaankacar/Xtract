# XTract v0.30 - Beta Release

XTract is a Solidity to MultiversX Rust smart contract transpiler. This release expands Solidity feature support and includes extensive testing.

## Release Highlights

- **Expanded Mapping Support**: Full support for single and nested mappings
- **Function Modifiers**: Support for custom modifiers like `onlyOwner`
- **Basic Inheritance**: Contract inheritance with supertrait generation
- **Enhanced Diagnostics**: Comprehensive error handling and warnings
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

### Enhanced Diagnostics

The transpiler now provides detailed diagnostics for unsupported features:

```bash
xtract -v MyContract.sol

Diagnostics:
  ⚠️ For loops are not yet supported - manual conversion required
  ⚠️ If statements are not yet fully supported - may require manual review
  ℹ️ Payable functions detected - add #[payable("EGLD")] annotation manually

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

### Requires Manual Review
- ⚠️ Payable functions (add #[payable("EGLD")] manually)
- ⚠️ Complex expressions (may need adjustment)
- ⚠️ External contract calls

### Not Yet Supported
- ❌ For/while loops
- ❌ If/else statements (full support)
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

Milestone 3 will focus on:
- Loop support (for, while)
- Conditional statements (if/else)
- Advanced inheritance patterns
- External contract calls
- npm package publication

## License

MIT License
