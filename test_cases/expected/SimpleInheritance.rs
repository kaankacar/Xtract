#![no_std]

use multiversx_sc::imports::*;

// Inherits from: Ownable

#[multiversx_sc::contract]
pub trait SimpleInheritance: Ownable {
    #[storage_mapper("value")]
    fn value(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[event("ValueUpdated")]
    fn value_updated_event(&self, #[indexed] newValue: &BigUint<Self::Api>);

    #[init]
    fn init(&self) {
        owner = self.blockchain().get_caller();
        self.value().set(&(BigUint::from(0u32)));
    }

    #[endpoint]
    fn set_value(&self, newValue: BigUint<Self::Api>) {
        self.value().set(&newValue);
        self.value_updated_event(&newValue);
    }

    #[view(getValue)]
    fn get_value(&self) -> BigUint<Self::Api> {
        return self.value().get();
    }

}