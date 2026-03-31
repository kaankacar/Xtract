#![no_std]

use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait UncheckedArithmetic {
    #[storage_mapper("result")]
    fn result(&self) -> SingleValueMapper<u64>;

    #[init]
    fn init(&self) {}

    #[endpoint]
    fn add_unchecked(&self, a: u64, b: u64) {
        // NOTE: unchecked arithmetic — overflow behavior differs on MultiversX
        result = a + b;
    }

}