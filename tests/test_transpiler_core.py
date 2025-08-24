from pathlib import Path

from xtract.transpiler import Transpiler


def load(p: str) -> str:
    return Path(p).read_text()


def normalize(s: str) -> str:
    return s.replace("\r\n", "\n").strip()


def test_simple_storage_shape():
    sol = load("test_cases/solidity/SimpleStorage.sol")
    expected = load("test_cases/expected/SimpleStorage.rs")
    actual = Transpiler().convert(sol)

    # Check contract name, storage, functions, and events present
    assert "pub trait SimpleStorage" in actual
    assert "#[storage_mapper(\"value\")]" in actual
    assert "fn value(&self) -> SingleValueMapper<BigUint<Self::Api>>;" in actual
    assert "#[event(\"ValueChanged\")]" in actual
    assert "fn value_changed_event(&self, #[indexed] newValue: BigUint<Self::Api>);" in actual or \
           "fn value_changed_event(&self, #[indexed] new_value: BigUint<Self::Api>);" in actual
    assert "#[view(getValue)]" in actual
    assert "fn get_value(&self) -> BigUint<Self::Api>" in actual


def test_erc20_headers_only():
    # Sanity: we at least emit the header and contract trait
    sol = load("test_cases/solidity/ERC20Token.sol")
    actual = Transpiler().convert(sol)
    assert "#![no_std]" in actual
    assert "use multiversx_sc::imports::*;" in actual
    assert "#[multiversx_sc::contract]" in actual


