#![no_std]

use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait VariableDeclarations {
    #[init]
    fn init(&self) {}

    #[endpoint]
    fn compute(&self, x: u64, y: u64) -> u64 {
        let mut sum: u64 = x + y;
        let mut ok: bool = true;
        let mut result: u64 = sum;
        return sum;
    }

}