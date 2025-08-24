#![no_std]

use multiversx_sc::imports::*;
use multiversx_sc::derive_imports::*;

#[multiversx_sc::contract]
pub trait SimpleStorage {
    #[event("ValueChanged")]
    fn value_changed_event(&self, #[indexed] newValue: BigUint<Self::Api>);

    #[init]
    fn init(&self) {}

    #[endpoint]
    fn set_value(&self, newValue: BigUint<Self::Api>) {
        // Function body would go here
    }

    #[view(getValue)]
    fn get_value(&self) -> BigUint<Self::Api> {
        // Function body would go here
    }

}