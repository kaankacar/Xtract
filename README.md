# XTract (v0.2)

An open-source tool for converting Solidity smart contracts to MultiversX-compatible Rust smart contracts.

## Overview

XTract analyzes Solidity code and generates MultiversX Rust code that can be compiled and deployed on the MultiversX blockchain. It currently focuses on a core subset to enable fast iteration and testing.

## Version 0.2 Notes

This is version 0.2 of the transpiler with the following changes:
- Introduces a Python CLI implementing a core conversion subset
- Validated on sample contracts in `test_cases` via unit tests
- Supports basic contract structures, events, functions, and simple storage patterns
- Rust implementation is available under `rust-impl/` for future iteration

For full implementation details, see [transpiler_report.md](transpiler_report.md).

## What it can do today

- Convert Solidity contracts to MultiversX Rust with the proper contract trait scaffold
- Detect and emit:
  - Functions (basic, including view vs endpoint detection)
  - Events (with indexed parameters)
  - Variable definitions (single value mappers for common types)
  - Structs
- Map common Solidity types to MultiversX equivalents (uint256, address, string, bool)
- Provide a simple CLI and unit tests ensuring output shape against examples

## Getting Started

### Prerequisites

- Python 3.9+ (for Python CLI)
- Rust and Cargo (for Rust implementation)
- MultiversX SDK tools (for deployment)

### Installation

```bash
git clone https://github.com/kaankacar/XTract.git
cd XTract

# Install Python CLI
python3 -m pip install --upgrade pip
python3 -m pip install -e .

# (optional) install test deps
python3 -m pip install pytest
```

After installing, the `xtract` CLI becomes available. If your system installs scripts under a user bin directory (e.g. `~/Library/Python/3.x/bin` on macOS), ensure it is on your PATH.

### Repository structure

```
XTract/
  xtract/            # Python package (CLI + core transpiler)
  tests/             # Unit tests for Python transpiler
  test_cases/        # Solidity inputs and expected Rust outputs
  rust-impl/         # Rust implementation (WIP)
  legacy/            # Legacy scripts, artifacts, and sample projects
  docs/              # Guides and technical documents
  .github/workflows/ # CI configuration
  pyproject.toml     # Python packaging config
```

### Usage

#### Python CLI (recommended for milestone 1)

```bash
pip install -e .[dev]
xtract <solidity_file.sol> [output.rs]
```

#### Legacy script

```bash
python3 legacy/simplified_transpiler.py <solidity_file.sol> <output_file.rs>
```

#### Rust Implementation (WIP)

```bash
cd rust-impl
cargo run <solidity_file.sol>
```

## Examples

See the `test_cases/` directory for example Solidity contracts and their MultiversX Rust equivalents.

## Documentation

For detailed documentation and a developer guide, see [DEVELOPER_GUIDE.md](docs/DEVELOPER_GUIDE.md).
For implementation report, see [transpiler_report.md](transpiler_report.md).

## Short-term roadmap

- Add translation of basic error handling patterns (`require`, `revert`) to MultiversX idioms
- Improve function return handling for simple return types and normalize generated code formatting
- Extend type mappings and parameter parsing robustness (e.g., memory/storage qualifiers ignored safely)
- Broaden unit test coverage across the sample contracts in `test_cases`
- Provide a reference “patterns” guide for Solidity → MultiversX equivalents in `docs/`

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.