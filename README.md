# Solidity to MultiversX Transpiler (v0.2)

A tool for converting Solidity smart contracts to MultiversX-compatible Rust smart contracts.

## Overview

This transpiler analyzes Solidity code and generates equivalent MultiversX Rust code that can be compiled and deployed on the MultiversX blockchain. It handles various Solidity features including functions, events, mappings, structs, and error handling.

## Version 0.2 Notes

This is version 0.2 of the transpiler with the following changes:
- Implemented a simplified Python-based version to demonstrate core conversion principles
- Successfully handles ~72% of features across test cases
- Supports basic contract structures, events, functions, and simple storage patterns
- Serves as a proof-of-concept while Rust implementation dependency issues are resolved

For full implementation details, see [transpiler_report.md](transpiler_report.md).

## Features

- Converts Solidity contracts to MultiversX Rust contracts
- Maps Solidity types to MultiversX equivalents
- Handles events, storage variables, and mappings
- Converts Solidity error handling to MultiversX patterns
- Supports common Solidity control flow structures

## Getting Started

### Prerequisites

- Python 3.6+ (for Python implementation)
- Rust and Cargo (for Rust implementation)
- MultiversX SDK tools (for deployment)

### Installation

```bash
git clone https://github.com/kaankacar/solidity_to_multiversx.git
cd solidity_to_multiversx
```

### Usage

#### Python Implementation

```bash
python3 simplified_transpiler.py <solidity_file.sol> <output_file.rs>
```

#### Rust Implementation (not currently functional)

```bash
cargo run <solidity_file.sol>
```

## Examples

See the `test_cases/` directory for example Solidity contracts and their MultiversX Rust equivalents.

## Documentation

For detailed documentation and a developer guide, see [DEVELOPER_GUIDE.md](docs/DEVELOPER_GUIDE.md).
For implementation report, see [transpiler_report.md](transpiler_report.md).

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.