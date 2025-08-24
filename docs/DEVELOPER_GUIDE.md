# Solidity to MultiversX Transpiler - Developer Guide

## Introduction

This tool allows you to convert Solidity smart contracts to MultiversX-compatible Rust smart contracts. It analyzes the Solidity code structure and generates equivalent Rust code that can be compiled and deployed on the MultiversX blockchain.

## Features

The transpiler supports the following Solidity features:

- Basic contract structure
- Functions (public, private, view)
- State variables and mappings
- Events
- Structs and enums
- Modifiers (converted to functions)
- Error handling (require, revert)
- Basic control flow (if, while, for)

## Usage

### Basic Command

```bash
cargo run <solidity_file.sol>
```

This will:
1. Parse the Solidity file
2. Generate a MultiversX-compatible Rust smart contract file with the same name (e.g., `solidity_file.rs`)
3. Compile the Rust contract to WebAssembly
4. Deploy the contract to the MultiversX blockchain (if wallet configuration is provided)

### Examples

#### Simple Storage Contract

**Solidity**:
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleStorage {
    uint256 private value;
    
    event ValueChanged(uint256 newValue);
    
    function setValue(uint256 newValue) public {
        value = newValue;
        emit ValueChanged(newValue);
    }
    
    function getValue() public view returns (uint256) {
        return value;
    }
}
```

**MultiversX Rust**:
```rust
#![no_std]

use multiversx_sc::imports::*;
use multiversx_sc::derive_imports::*;

#[multiversx_sc::contract]
pub trait SimpleStorage {
    #[storage_mapper("value")]
    fn value(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[event("ValueChanged")]
    fn value_changed_event(&self, #[indexed] new_value: BigUint<Self::Api>);

    #[init]
    fn init(&self) {}

    #[endpoint]
    fn set_value(&self, new_value: BigUint<Self::Api>) {
        self.value().set(new_value.clone());
        self.value_changed_event(new_value);
    }

    #[view(getValue)]
    fn get_value(&self) -> BigUint<Self::Api> {
        self.value().get()
    }
}
```

#### ERC-20 Token

**Solidity**:
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ERC20Token {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    
    constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _initialSupply) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _initialSupply * 10 ** uint256(decimals);
        balanceOf[msg.sender] = totalSupply;
        
        emit Transfer(address(0), msg.sender, totalSupply);
    }
    
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
    
    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[_from] >= _value, "Insufficient balance");
        require(allowance[_from][msg.sender] >= _value, "Insufficient allowance");
        
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        
        emit Transfer(_from, _to, _value);
        return true;
    }
}
```

**MultiversX Rust** (example simplified):
```rust
#![no_std]

use multiversx_sc::imports::*;
use multiversx_sc::derive_imports::*;

#[multiversx_sc::contract]
pub trait ERC20Token {
    #[storage_mapper("name")]
    fn name(&self) -> SingleValueMapper<ManagedBuffer<Self::Api>>;

    #[storage_mapper("symbol")]
    fn symbol(&self) -> SingleValueMapper<ManagedBuffer<Self::Api>>;

    #[storage_mapper("decimals")]
    fn decimals(&self) -> SingleValueMapper<u8>;

    #[storage_mapper("totalSupply")]
    fn total_supply(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("balanceOf")]
    fn balance_of(&self, address: &ManagedAddress<Self::Api>) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("allowance")]
    fn allowance(&self, owner: &ManagedAddress<Self::Api>, spender: &ManagedAddress<Self::Api>) -> 
        SingleValueMapper<BigUint<Self::Api>>;

    #[event("Transfer")]
    fn transfer_event(
        &self,
        #[indexed] from: &ManagedAddress<Self::Api>,
        #[indexed] to: &ManagedAddress<Self::Api>,
        value: &BigUint<Self::Api>,
    );

    #[event("Approval")]
    fn approval_event(
        &self,
        #[indexed] owner: &ManagedAddress<Self::Api>,
        #[indexed] spender: &ManagedAddress<Self::Api>,
        value: &BigUint<Self::Api>,
    );

    #[init]
    fn init(
        &self,
        name: ManagedBuffer<Self::Api>,
        symbol: ManagedBuffer<Self::Api>,
        decimals: u8,
        initial_supply: BigUint<Self::Api>,
    ) {
        self.name().set(name);
        self.symbol().set(symbol);
        self.decimals().set(decimals);
        
        let power = BigUint::from(10u32).pow(decimals.into());
        let total_supply = initial_supply * power;
        self.total_supply().set(&total_supply);
        
        let caller = self.blockchain().get_caller();
        self.balance_of(&caller).set(&total_supply);
        
        // Zero address in MultiversX
        let zero_address = ManagedAddress::zero();
        self.transfer_event(&zero_address, &caller, &total_supply);
    }

    #[endpoint]
    fn transfer(&self, to: ManagedAddress<Self::Api>, value: BigUint<Self::Api>) -> bool {
        let caller = self.blockchain().get_caller();
        let caller_balance = self.balance_of(&caller).get();
        
        require!(caller_balance >= value, "Insufficient balance");
        
        self.balance_of(&caller).set(&(caller_balance - &value));
        
        let receiver_balance = self.balance_of(&to).get();
        self.balance_of(&to).set(&(receiver_balance + &value));
        
        self.transfer_event(&caller, &to, &value);
        
        true
    }

    // Additional functions for approve and transferFrom...
}
```

## Type Mapping

Here's how Solidity types are mapped to MultiversX Rust types:

| Solidity Type | MultiversX Type |
|---------------|----------------|
| `bool` | `bool` |
| `address` | `ManagedAddress<Self::Api>` |
| `string` | `ManagedBuffer<Self::Api>` |
| `uint8` | `u8` |
| `uint16` | `u16` |
| `uint32` | `u32` |
| `uint64` | `u64` |
| `uint128` | `BigUint<Self::Api>` |
| `uint256` | `BigUint<Self::Api>` |
| `int8` | `i8` |
| `int16` | `i16` |
| `int32` | `i32` |
| `int64` | `i64` |
| `int128` | `BigInt<Self::Api>` |
| `int256` | `BigInt<Self::Api>` |
| `bytes1-32` | `[u8; N]` |
| `bytes` | `ManagedBuffer<Self::Api>` |
| `mapping(K => V)` | `MapMapper<Self::Api, K, V>` |
| `array[]` | `VecMapper<Self::Api, T>` |
| `array[N]` | `ArrayMapper<Self::Api, T, N>` |

## Features Not Currently Supported

- Abstract contracts and inheritance
- Libraries
- Assembly blocks
- Multiple return values (tuples) from functions
- Complex modifiers with multiple inputs
- Some native Solidity functions (selfdestruct, block.coinbase, etc.)

## Best Practices

1. **Keep contracts simple**: Focus on core functionality first, as complex Solidity patterns may not directly translate to MultiversX.

2. **Check generated code**: Always verify the generated MultiversX code for correctness, as there might be subtle differences in behavior.

3. **Test thoroughly**: Use the MultiversX testing framework to validate the transpiled contract's behavior.

4. **Adapt payment handling**: Solidity's native Ether handling doesn't directly map to EGLD handling in MultiversX. Use the `#[payable("EGLD")]` annotation and adapt accordingly.

5. **Understand gas differences**: Gas costs differ between Ethereum and MultiversX. Optimize your code for MultiversX's gas model after transpilation.

## Troubleshooting

### Common Issues

1. **Type conversion errors**: Some complex Solidity types may not have direct equivalents in MultiversX.
   - Solution: Manually adjust the generated code to use appropriate MultiversX types.

2. **Gas limitations**: MultiversX has different gas mechanics.
   - Solution: Review loops and complex operations for potential gas issues.

3. **Storage patterns**: Solidity's storage model differs from MultiversX's storage mappers.
   - Solution: Verify storage access patterns and adapt as needed.

### Getting Help

If you encounter issues or need additional features, please open an issue on our GitHub repository with:
- The original Solidity code
- The generated Rust code (if any)
- A description of the problem or unexpected behavior

## Advanced Customization

For contracts that require manual tuning after transpilation, consider:

1. Using the `--no-compile` flag to generate only the Rust code without compilation
2. Making manual adjustments to the generated code
3. Compiling and deploying the modified contract using the MultiversX SDK tools 