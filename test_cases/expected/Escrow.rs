#![no_std]

use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait Escrow {
    #[storage_mapper("buyer")]
    fn buyer(&self) -> SingleValueMapper<ManagedAddress<Self::Api>>;

    #[storage_mapper("seller")]
    fn seller(&self) -> SingleValueMapper<ManagedAddress<Self::Api>>;

    #[storage_mapper("arbiter")]
    fn arbiter(&self) -> SingleValueMapper<ManagedAddress<Self::Api>>;

    #[storage_mapper("amount")]
    fn amount(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("released")]
    fn released(&self) -> SingleValueMapper<bool>;

    #[storage_mapper("refunded")]
    fn refunded(&self) -> SingleValueMapper<bool>;

    #[event("Deposited")]
    fn deposited_event(&self, #[indexed] buyer: &ManagedAddress<Self::Api>, amount: &BigUint<Self::Api>);

    #[event("Released")]
    fn released_event(&self, #[indexed] seller: &ManagedAddress<Self::Api>, amount: &BigUint<Self::Api>);

    #[event("Refunded")]
    fn refunded_event(&self, #[indexed] buyer: &ManagedAddress<Self::Api>, amount: &BigUint<Self::Api>);

    #[init]
    fn init(&self) {
        buyer = self.blockchain().get_caller();
        released = false;
        refunded = false;
    }

    #[endpoint]
    fn set_seller(&self, _seller: ManagedAddress<Self::Api>) {
        require!(self.blockchain().get_caller() == buyer, "Only buyer");
        seller = _seller;
    }

    #[endpoint]
    fn set_arbiter(&self, _arbiter: ManagedAddress<Self::Api>) {
        require!(self.blockchain().get_caller() == buyer, "Only buyer");
        arbiter = _arbiter;
    }

    #[endpoint]
    fn deposit(&self, _amount: BigUint<Self::Api>) {
        require!(self.blockchain().get_caller() == buyer, "Only buyer");
        require!(!released, "Already released");
        require!(!refunded, "Already refunded");
        amount = _amount;
        self.deposited_event(&buyer, &_amount.clone());
    }

    #[endpoint]
    fn release(&self) {
        require!(self.blockchain().get_caller() == buyer, "Only buyer");
        require!(!released, "Already released");
        require!(!refunded, "Already refunded");
        released = true;
        self.released_event(&seller, &amount.clone());
    }

    #[endpoint]
    fn refund(&self) {
        require!(self.blockchain().get_caller() == arbiter, "Only arbiter");
        require!(!released, "Already released");
        require!(!refunded, "Already refunded");
        refunded = true;
        self.refunded_event(&buyer, &amount.clone());
    }

}