#![no_std]

use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait counter {
    #[storage_mapper("count")]
    pub fn count(&self) -> SingleValueMapper<u256>;
}

impl counter {
    #[endpoint(increase)]
    pub fn increase(&self) {
        self.count().set(count + 1);
    }
    #[endpoint(decrease)]
    pub fn decrease(&self) {
        self.count().set(count - 1);
    }
}

