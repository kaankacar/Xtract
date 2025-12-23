# Changelog - XTract v0.30

## [0.30.0] - 2024-12-23

### Added

#### Nested Mapping Support
- Full support for nested mappings: `mapping(address => mapping(address => uint256))`
- Automatic detection and parsing of nested mapping declarations
- Proper storage mapper generation with two key parameters
- Expression conversion for nested mapping access patterns

#### Function Modifier Support
- Parser for modifier definitions (`modifier onlyOwner() { ... }`)
- Detection of applied modifiers on functions
- Automatic conversion of modifier require conditions to function body require! checks
- Support for multiple modifiers on a single function
- Common modifier patterns: onlyOwner, whenNotPaused, whenPaused, onlyAdmin, onlyMinter

#### Basic Inheritance Support
- Parser for inheritance declarations (`contract A is B, C`)
- Supertrait generation in Rust trait definitions
- Inheritance comment documentation in output
- Support for single and multiple inheritance
- Abstract contract detection

#### Enhanced Error Handling and Diagnostics
- New `TranspilationResult` dataclass with success/warnings/errors
- New `TranspilationWarning` dataclass for structured warnings
- `validate_and_diagnose()` method for pre-transpilation validation
- `convert_with_diagnostics()` method for full diagnostic output
- `transpile_with_diagnostics()` function for file-based transpilation
- Detection of unsupported features with helpful messages
- CLI verbose mode (`-v`) for showing diagnostics
- CLI quiet mode (`-q`) for minimal output

#### Extensive Test Suite
- 50 Solidity test cases (up from 5)
- 64 test functions total
- Parametrized testing for all contract types
- Feature-specific tests for new functionality
- Diagnostic/validation tests
- 100% test pass rate

### Changed

#### Parser Improvements
- Contract name parser now strips comments before matching
- Inheritance parser now strips comments before matching
- More robust regex patterns for contract detection

#### Storage Variable Lists
- Added more common storage variable names for automatic getter conversion
- Added more mapping variable names for proper mapper handling

#### CLI Improvements
- Added `-v/--verbose` flag for diagnostic output
- Added `-q/--quiet` flag for silent operation
- Better error messages and colorized output

### Test Cases Added (45 new)

| # | Contract | Features Tested |
|---|----------|-----------------|
| 6 | NestedMapping | Nested mappings, approve pattern |
| 7 | OnlyOwner | onlyOwner modifier |
| 8 | Counter | Basic counter operations |
| 9 | Pausable | Multiple modifiers |
| 10 | TokenVault | Deposit/withdrawal pattern |
| 11 | Staking | Staking rewards pattern |
| 12 | Timelock | Time-locked operations |
| 13 | Whitelist | Access control lists |
| 14 | Escrow | Multi-party escrow |
| 15 | Registry | Name registry pattern |
| 16 | FeeCollector | Fee management |
| 17 | AccessControl | Role-based access |
| 18 | Lottery | Random selection pattern |
| 19 | Auction | Bidding pattern |
| 20 | Multisig | Multi-signature pattern |
| 21 | RewardPool | Reward distribution |
| 22 | TokenMinter | Minting with access control |
| 23 | SimpleInheritance | Basic inheritance |
| 24 | TokenSwap | Exchange pattern |
| 25 | Subscription | Subscription model |
| 26 | Vesting | Token vesting |
| 27 | Governance | DAO governance |
| 28 | Referral | Referral system |
| 29 | Leaderboard | Score tracking |
| 30 | Ticket | Ticket system |
| 31 | Poll | Voting polls |
| 32 | Donation | Donation collection |
| 33 | Points | Point system |
| 34 | Certificate | Certificate issuance |
| 35 | Membership | Membership management |
| 36 | Lockable | Lock/unlock pattern |
| 37 | RateLimiter | Rate limiting |
| 38 | Deposit | Min/max deposits |
| 39 | Badge | Achievement badges |
| 40 | Blacklist | Blacklist management |
| 41 | Timer | Timer operations |
| 42 | Config | Configuration storage |
| 43 | TokenBridge | Bridge pattern |
| 44 | OrderBook | Order management |
| 45 | TokenLocker | Token locking |
| 46 | Splitter | Payment splitting |
| 47 | Vault | Secure vault |
| 48 | SimpleToken | Basic token |
| 49 | Proxy | Proxy pattern |
| 50 | Claimer | Claim mechanism |

### Fixed

- Contract name parser no longer matches words in comments
- Inheritance parser no longer matches words in comments

### Documentation

- New v0.30 documentation folder
- Updated README with new features
- Complete changelog
- Implementation report
- Test results summary

## [0.25.0] - 2024-10-26

Previous release with:
- Basic transpilation pipeline
- 5 test cases
- Simple mapping support
- Event and struct handling

---

## Feature Comparison

| Feature | v0.25 | v0.30 | v0.30.1 |
|---------|-------|-------|---------|
| Basic Contracts | ✅ | ✅ | ✅ |
| Single Mappings | ✅ | ✅ | ✅ |
| Nested Mappings | ⚠️ | ✅ | ✅ |
| Events | ✅ | ✅ | ✅ |
| Structs | ✅ | ✅ | ✅ |
| Errors | ✅ | ✅ | ✅ |
| require/revert | ✅ | ✅ | ✅ |
| Function Modifiers | ❌ | ✅ | ✅ |
| Inheritance | ❌ | ✅ | ✅ |
| Diagnostics | ❌ | ✅ | ✅ |
| Payable Functions | ❌ | ❌ | ✅ |
| If/Else Statements | ❌ | ❌ | ✅ |
| For/While Loops | ❌ | ❌ | ✅ |
| Test Cases | 5 | 50 | 64 |

## Migration Notes

### From v0.25 to v0.30

No changes required. All v0.25 contracts will continue to work.

New features:

1. **Nested Mappings**: Now automatically detected and properly transpiled.

2. **Modifiers**: Contracts with modifiers like `onlyOwner` will now have the modifier logic included in function bodies.

3. **Inheritance**: Contracts with inheritance will now include supertrait bounds.

4. **Diagnostics**: Use `-v` flag to see warnings about unsupported features.

## [0.30.1] - 2024-12-23

### Added

#### Control Flow Transpilation
- **Payable functions**: Automatic `#[payable("EGLD")]` annotation for payable functions
- **If/else statements**: Full if/else transpilation with proper Rust syntax
- **For loops**: Counter-based for loops transpiled to `for i in 0..n` syntax
- **While loops**: While loop transpilation with condition conversion

#### Parser Improvements
- Robust function body extraction using brace matching (handles nested control flow)
- Payable function detection from Solidity modifiers

## Known Limitations

- Do-while loops not yet supported
- Inline assembly not supported
- Libraries require manual flattening
- Try-catch blocks not supported (use require/revert)
