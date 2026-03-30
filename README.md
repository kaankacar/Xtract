# XTract (v0.30.1)

[![CI](https://github.com/XTract-build/Xtract/actions/workflows/ci.yml/badge.svg)](https://github.com/XTract-build/Xtract/actions/workflows/ci.yml)
[![Tests](https://img.shields.io/badge/tests-100%25-success)](https://github.com/XTract-build/Xtract/actions/workflows/ci.yml)
[![npm](https://img.shields.io/npm/v/xtract-cli)](https://www.npmjs.com/package/xtract-cli)
[![PyPI](https://img.shields.io/pypi/v/xtract)](https://pypi.org/project/xtract/)

An open-source tool for converting Solidity smart contracts to MultiversX-compatible Rust smart contracts.

## Quick Start

```bash
# Install from npm
npm install -g xtract-cli

# Transpile a Solidity contract to MultiversX Rust
xtract MyContract.sol

# That's it! Your MultiversX Rust contract is ready at MyContract.rs
```

**npm package:** [https://www.npmjs.com/package/xtract-cli](https://www.npmjs.com/package/xtract-cli)

## Overview

XTract analyzes Solidity code and generates MultiversX Rust code that can be compiled and deployed on the MultiversX blockchain. It supports a comprehensive set of Solidity features including control flow, mappings, modifiers, and inheritance.

## Version 0.30.1 (Beta Release)

This version introduces comprehensive Solidity support:

### Core Features
- **Function body transpilation**: Converts `require()`, `emit()`, `return`, and assignments
- **Error handling**: Maps Solidity `require()` → MultiversX `require!()` and `revert()` → `sc_panic!()`
- **Event emission**: Properly converts Solidity events to MultiversX event calls
- **Storage operations**: Handles variable assignments and storage access patterns

### Mapping Support
- **Single mappings**: `mapping(address => uint256)` → storage mappers with key parameters
- **Nested mappings**: `mapping(address => mapping(address => uint256))` → multi-key storage mappers

### Control Flow
- **If/else statements**: Full if/else transpilation with proper Rust syntax
- **For loops**: Counter-based loops transpiled to `for i in 0..n` syntax
- **While loops**: While loop transpilation with condition conversion
- **Payable functions**: Automatic `#[payable("EGLD")]` annotation

### Advanced Features
- **Function modifiers**: `onlyOwner`, `whenNotPaused`, custom modifiers
- **Basic inheritance**: Contract inheritance with supertrait generation
- **Enhanced diagnostics**: Detailed warnings for unsupported features

**Test Coverage**: 100% unit test success across 50 Solidity contracts with 64 test functions.

## Installation

### Via npm (recommended)

```bash
npm install -g xtract-cli
```

### Via pip (Python)

```bash
pip install xtract
```

### From source

```bash
git clone https://github.com/XTract-build/Xtract.git
cd XTract
pip install -e .
```

## Usage

### Basic Usage

```bash
# Transpile a Solidity contract
xtract MyContract.sol

# Specify output file
xtract MyContract.sol output.rs

# Verbose mode (show diagnostics)
xtract -v MyContract.sol

# Quiet mode
xtract -q MyContract.sol
```

### Quick Example

```bash
# Create a simple Solidity contract
cat > MyStorage.sol << 'EOF'
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyStorage {
    uint256 public value;
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    event ValueChanged(uint256 indexed newValue);

    constructor() {
        owner = msg.sender;
    }

    function setValue(uint256 newValue) public onlyOwner {
        require(newValue > 0, "Value must be positive");
        value = newValue;
        emit ValueChanged(newValue);
    }

    function getValue() public view returns (uint256) {
        return value;
    }
}
EOF

# Transpile it
xtract MyStorage.sol

# View the generated MultiversX Rust code
cat MyStorage.rs
```

## Supported Solidity Features

### Fully Supported
- Contract declarations
- State variables (all basic types)
- Single mappings (`mapping(address => uint256)`)
- Nested mappings (`mapping(address => mapping(address => uint256))`)
- Events with indexed parameters
- Custom errors
- Structs
- Functions (public, private, view, payable)
- Constructors
- Function modifiers (onlyOwner, custom)
- Basic inheritance (`contract A is B, C`)
- require/revert statements
- If/else statements
- For loops (counter-based)
- While loops

### Requires Manual Review
- Complex expressions (may need adjustment)
- External contract calls

### Not Yet Supported
- Do-while loops
- Inline assembly
- Try-catch blocks
- Libraries
- Diamond inheritance

## Examples

The `test_cases/` directory contains 50 fully working examples including:

| Category | Examples |
|----------|----------|
| Basic | SimpleStorage, Counter, Config |
| Tokens | ERC20Token, SimpleToken, TokenMinter |
| NFTs | NFTMarketplace, Certificate, Badge |
| DeFi | Staking, RewardPool, TokenSwap, Vesting |
| Governance | Voting, Governance, Poll, Multisig |
| Access Control | OnlyOwner, AccessControl, Pausable |
| Patterns | Escrow, Auction, Lottery, Vault |

## Documentation

### Version Documentation
- **[docs/v0.30/](docs/v0.30/)** - Complete documentation for v0.30.1
  - [README.md](docs/v0.30/README.md) - Feature overview and examples
  - [CHANGELOG.md](docs/v0.30/CHANGELOG.md) - Full release notes
  - [IMPLEMENTATION_REPORT.md](docs/v0.30/IMPLEMENTATION_REPORT.md) - Technical architecture
  - [IMPLEMENTATION_SUMMARY.md](docs/v0.30/IMPLEMENTATION_SUMMARY.md) - Feature matrix
  - [TEST_RESULTS.md](docs/v0.30/TEST_RESULTS.md) - Test coverage and results

### Developer Guide
- **[docs/DEVELOPER_GUIDE.md](docs/DEVELOPER_GUIDE.md)** - Getting started guide

## Repository Structure

```
XTract/
  xtract/            # Python package (CLI + core transpiler)
  tests/             # Unit tests (64 test functions)
  test_cases/        # Solidity inputs and expected Rust outputs (50 contracts)
docs/              # Documentation
  .github/workflows/ # CI configuration
  package.json       # npm package configuration
  pyproject.toml     # Python packaging config
```

## How It Works

XTract follows a clear pipeline from Solidity source code to MultiversX Rust:

```
Solidity Source (.sol)
        ↓
┌─────────────────────┐
│  Validation &       │
│  Diagnostics        │
└──────────┬──────────┘
           ↓
┌─────────────────────┐
│  Parse Contract     │
│  - Name & Inheritance│
│  - Modifiers        │
│  - Storage & Events │
│  - Functions        │
└──────────┬──────────┘
           ↓
┌─────────────────────┐
│  Convert to         │
│  MultiversX Rust    │
└──────────┬──────────┘
           ↓
   Rust Output (.rs)
```

## Testing

```bash
# Run all tests
pytest tests/ -v

# Run specific test
pytest tests/test_transpiler_core.py::test_nested_mapping_features -v

# Run with coverage
pytest tests/ --cov=xtract
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

