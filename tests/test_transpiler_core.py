"""
XTract Transpiler Test Suite

This test suite validates the Solidity to MultiversX Rust transpilation.
It tests 50 different contract patterns including:
- Basic contracts
- Mappings (single and nested)
- Function modifiers
- Basic inheritance
- Various DeFi patterns
"""

from pathlib import Path
import pytest

from xtract.transpiler import Transpiler


def load(p: str) -> str:
    return Path(p).read_text()


def normalize(s: str) -> str:
    """Normalize whitespace and line endings for comparison"""
    return s.replace("\r\n", "\n").strip()


def get_test_files():
    """Get all Solidity test files that have corresponding expected outputs"""
    solidity_dir = Path("test_cases/solidity")
    expected_dir = Path("test_cases/expected")

    test_files = []
    for sol_file in sorted(solidity_dir.glob("*.sol")):
        expected_file = expected_dir / sol_file.with_suffix(".rs").name
        if expected_file.exists():
            test_files.append((sol_file.stem, str(sol_file), str(expected_file)))

    return test_files


# Generate test cases for all contracts
TEST_CASES = get_test_files()


@pytest.mark.parametrize("name,sol_path,expected_path", TEST_CASES, ids=[t[0] for t in TEST_CASES])
def test_transpilation(name, sol_path, expected_path):
    """Test transpilation of each contract against expected output"""
    sol = load(sol_path)
    expected = load(expected_path)
    actual = Transpiler().convert(sol)

    # Normalize both for comparison
    expected_normalized = normalize(expected)
    actual_normalized = normalize(actual)

    # Primary validation: compare normalized expected vs actual
    if expected_normalized != actual_normalized:
        import difflib
        diff = difflib.unified_diff(
            expected_normalized.splitlines(keepends=True),
            actual_normalized.splitlines(keepends=True),
            fromfile="expected",
            tofile="actual",
            lineterm=""
        )
        diff_str = "".join(diff)
        assert False, f"Generated output for {name} does not match expected file:\n{diff_str[:2000]}"


# Additional feature-specific tests

def test_simple_storage_features():
    """Test SimpleStorage contract has key features"""
    sol = load("test_cases/solidity/SimpleStorage.sol")
    actual = Transpiler().convert(sol)

    assert "pub trait SimpleStorage" in actual
    assert "#[storage_mapper(\"value\")]" in actual
    assert "fn value(&self) -> SingleValueMapper<BigUint<Self::Api>>;" in actual
    assert "#[event(\"ValueChanged\")]" in actual


def test_erc20_features():
    """Test ERC20Token contract has key features"""
    sol = load("test_cases/solidity/ERC20Token.sol")
    actual = Transpiler().convert(sol)

    assert "#![no_std]" in actual
    assert "use multiversx_sc::imports::*;" in actual
    assert "#[multiversx_sc::contract]" in actual
    assert "pub trait ERC20Token" in actual
    assert "#[storage_mapper(\"totalSupply\")]" in actual
    assert "require!" in actual


def test_nested_mapping_features():
    """Test nested mapping transpilation"""
    sol = load("test_cases/solidity/NestedMapping.sol")
    actual = Transpiler().convert(sol)

    assert "pub trait NestedMapping" in actual
    assert "#[storage_mapper(\"allowance\")]" in actual
    # Nested mapping should have two key parameters
    assert "key1:" in actual or "key2:" in actual


def test_modifier_features():
    """Test modifier transpilation"""
    sol = load("test_cases/solidity/OnlyOwner.sol")
    actual = Transpiler().convert(sol)

    assert "pub trait OnlyOwner" in actual
    assert "#[storage_mapper(\"owner\")]" in actual
    # Modifier should be converted to require! check
    assert "require!" in actual


def test_inheritance_features():
    """Test inheritance transpilation"""
    sol = load("test_cases/solidity/SimpleInheritance.sol")
    actual = Transpiler().convert(sol)

    # Should include inheritance comment or supertrait
    assert "pub trait SimpleInheritance" in actual
    assert "Ownable" in actual  # Parent contract reference


def test_multiple_modifiers():
    """Test contract with multiple modifiers"""
    sol = load("test_cases/solidity/Pausable.sol")
    actual = Transpiler().convert(sol)

    assert "pub trait Pausable" in actual
    assert "#[storage_mapper(\"paused\")]" in actual
    assert "require!" in actual


def test_staking_contract():
    """Test staking contract pattern"""
    sol = load("test_cases/solidity/Staking.sol")
    actual = Transpiler().convert(sol)

    assert "pub trait Staking" in actual
    assert "#[storage_mapper(\"stakes\")]" in actual
    assert "#[storage_mapper(\"rewards\")]" in actual
    assert "#[event(\"Staked\")]" in actual


def test_vault_contract():
    """Test vault contract pattern"""
    sol = load("test_cases/solidity/Vault.sol")
    actual = Transpiler().convert(sol)

    assert "pub trait Vault" in actual
    assert "#[storage_mapper(\"balances\")]" in actual
    assert "#[event(\"Deposited\")]" in actual
    assert "#[event(\"WithdrawalCompleted\")]" in actual


def test_governance_contract():
    """Test governance contract pattern"""
    sol = load("test_cases/solidity/Governance.sol")
    actual = Transpiler().convert(sol)

    assert "pub trait Governance" in actual
    assert "#[storage_mapper(\"proposalVotes\")]" in actual
    assert "#[event(\"ProposalCreated\")]" in actual
    assert "#[event(\"Voted\")]" in actual


def test_badge_nested_mapping():
    """Test contract with nested mapping (user => badgeId => bool)"""
    sol = load("test_cases/solidity/Badge.sol")
    actual = Transpiler().convert(sol)

    assert "pub trait Badge" in actual
    assert "#[storage_mapper(\"hasBadge\")]" in actual


# Diagnostics tests

def test_loops_are_supported():
    """Test that for loops are now transpiled (not just warned about)"""
    sol_with_loop = """
    // SPDX-License-Identifier: MIT
    pragma solidity ^0.8.0;

    contract LoopContract {
        uint256 public sum;

        function sumToN(uint256 n) public {
            for (uint i = 0; i < n; i++) {
                sum = sum + 1;
            }
        }
    }
    """

    transpiler = Transpiler()
    result = transpiler.convert(sol_with_loop)

    # Should contain a for loop in Rust syntax
    assert "for i in 0.." in result


def test_if_statements_are_supported():
    """Test that if statements are now transpiled"""
    sol_with_if = """
    // SPDX-License-Identifier: MIT
    pragma solidity ^0.8.0;

    contract IfContract {
        uint256 public value;

        function setIfPositive(uint256 x) public {
            if (x > 0) {
                value = x;
            }
        }
    }
    """

    transpiler = Transpiler()
    result = transpiler.convert(sol_with_if)

    # Should contain if statement in Rust syntax
    assert "if " in result and "{" in result


def test_convert_with_diagnostics():
    """Test convert_with_diagnostics returns proper result"""
    sol = load("test_cases/solidity/SimpleStorage.sol")

    transpiler = Transpiler()
    result = transpiler.convert_with_diagnostics(sol)

    assert result.success
    assert "pub trait SimpleStorage" in result.code


def test_local_declaration_generates_let():
    """Test that local variable declarations emit let mut bindings"""
    sol = load("test_cases/solidity/VariableDeclarations.sol")
    expected = load("test_cases/expected/VariableDeclarations.rs")
    actual = Transpiler().convert(sol)
    assert normalize(actual) == normalize(expected), (
        f"Declaration transpilation mismatch:\n"
        f"Expected:\n{normalize(expected)}\n\nActual:\n{normalize(actual)}"
    )
    assert "let mut sum: u64 = x + y;" in actual
    assert "let mut ok: bool = true;" in actual
    assert "let mut result: u64 = sum;" in actual


def test_do_while_generates_loop_break():
    """Test that do-while loops are transpiled to loop { ... if !(...) { break; } }"""
    sol = """
    // SPDX-License-Identifier: MIT
    pragma solidity ^0.8.0;

    contract DoWhileTest {
        uint64 public count;

        function run(uint64 limit) public {
            uint64 i = 0;
            do {
                i = i + 1;
            } while (i < limit);
            count = i;
        }
    }
    """
    result = Transpiler().convert(sol)
    assert "loop {" in result
    assert "if !(" in result
    assert "break;" in result


def test_unchecked_generates_passthrough():
    """Test that unchecked blocks are stripped but inner statements remain"""
    sol = """
    // SPDX-License-Identifier: MIT
    pragma solidity ^0.8.0;

    contract UncheckedTest {
        uint64 public result;

        function add(uint64 a, uint64 b) public {
            unchecked {
                result = a + b;
            }
        }
    }
    """
    result = Transpiler().convert(sol)
    assert "unchecked" not in result.replace("// NOTE: unchecked", "")
    assert "// NOTE: unchecked arithmetic" in result
    assert "result = a + b" in result or "a + b" in result


# Count test to verify we have 50 test cases
def test_fifty_test_cases():
    """Verify we have at least 50 test cases"""
    assert len(TEST_CASES) >= 50, f"Expected at least 50 test cases, got {len(TEST_CASES)}"
