#![no_std]

use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait DoWhileLoop {
    #[storage_mapper("count")]
    fn count(&self) -> SingleValueMapper<u64>;

    #[init]
    fn init(&self) {}

    #[endpoint]
    fn count_up(&self, limit: u64) {
        loop {
        i = i + BigUint::from(1u32);
            if !(i < limit) { break; }
        }
        let mut i: u64 = BigUint::from(0u32);
        self.count().set(&i);
    }

}