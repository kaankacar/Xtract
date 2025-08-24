#![no_std]

use multiversx_sc::imports::*;
use multiversx_sc::derive_imports::*;

#[multiversx_sc::contract]
pub trait ERC20Token {
    #[storage_mapper("name")]
    fn name(&self) -> SingleValueMapper<ManagedBuffer<Self::Api>>;

    #[storage_mapper("symbol")]
    fn symbol(&self) -> SingleValueMapper<ManagedBuffer<Self::Api>>;

    #[storage_mapper("totalSupply")]
    fn total_supply(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[event("Transfer")]
    fn transfer_event(&self, #[indexed] from: ManagedAddress<Self::Api>, #[indexed] to: ManagedAddress<Self::Api>, value: BigUint<Self::Api>);

    #[event("Approval")]
    fn approval_event(&self, #[indexed] owner: ManagedAddress<Self::Api>, #[indexed] spender: ManagedAddress<Self::Api>, value: BigUint<Self::Api>);

    #[init]
    fn init(&self) {}

    #[endpoint]
    fn transfer(&self, _to: ManagedAddress<Self::Api>, _value: BigUint<Self::Api>) -> bool {
        // Function body would go here
    }

    #[endpoint]
    fn approve(&self, _spender: ManagedAddress<Self::Api>, _value: BigUint<Self::Api>) -> bool {
        // Function body would go here
    }

    #[endpoint]
    fn transfer_from(&self, _from: ManagedAddress<Self::Api>, _to: ManagedAddress<Self::Api>, _value: BigUint<Self::Api>) -> bool {
        // Function body would go here
    }

}