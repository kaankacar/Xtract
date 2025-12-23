#![no_std]

use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait Counter {
    #[storage_mapper("count")]
    fn count(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[event("CountIncremented")]
    fn count_incremented_event(&self, #[indexed] newCount: &BigUint<Self::Api>);

    #[event("CountDecremented")]
    fn count_decremented_event(&self, #[indexed] newCount: &BigUint<Self::Api>);

    #[event("CountReset")]
    fn count_reset_event(&self);

    #[init]
    fn init(&self) {}

    #[endpoint]
    fn increment(&self) {
        self.count().set(&(self.count().get() + BigUint::from(1u32)));
        self.count_incremented_event(&self.count().get());
    }

    #[endpoint]
    fn decrement(&self) {
        require!(self.count().get() > BigUint::from(0u32), "Counter underflow");
        self.count().set(&(self.count().get() - BigUint::from(1u32)));
        self.count_decremented_event(&self.count().get());
    }

    #[endpoint]
    fn reset(&self) {
        self.count().set(&(BigUint::from(0u32)));
        self.count_reset_event();
    }

    #[view(getCount)]
    fn get_count(&self) -> BigUint<Self::Api> {
        return self.count().get();
    }

}