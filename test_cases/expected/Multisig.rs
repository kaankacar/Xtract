#![no_std]

use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait Multisig {
    #[storage_mapper("required")]
    fn required(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("transactionCount")]
    fn transaction_count(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("owners")]
    fn owners(&self, key: &ManagedAddress<Self::Api>) -> SingleValueMapper<bool>;

    #[event("OwnerAdded")]
    fn owner_added_event(&self, #[indexed] owner: &ManagedAddress<Self::Api>);

    #[event("TransactionSubmitted")]
    fn transaction_submitted_event(&self, #[indexed] txId: &BigUint<Self::Api>);

    #[event("TransactionConfirmed")]
    fn transaction_confirmed_event(&self, #[indexed] txId: &BigUint<Self::Api>, #[indexed] owner: &ManagedAddress<Self::Api>);

    #[event("TransactionExecuted")]
    fn transaction_executed_event(&self, #[indexed] txId: &BigUint<Self::Api>);

    #[init]
    fn init(&self) {
        required = BigUint::from(1u32);
        transactionCount = BigUint::from(0u32);
    }

    #[endpoint]
    fn add_owner(&self, owner: ManagedAddress<Self::Api>) {
        require!(self.owners(&self.blockchain().get_caller()), "Not owner");
        require!(!self.owners(&owner), "Already owner");
        self.owner_added_event(&owner);
    }

    #[endpoint]
    fn set_required(&self, count: BigUint<Self::Api>) {
        require!(self.owners(&self.blockchain().get_caller()), "Not owner");
        require!(self.count().get() > BigUint::from(0u32), "Invalid count");
        required = self.count().get();
    }

    #[endpoint]
    fn submit_transaction(&self) {
        require!(self.owners(&self.blockchain().get_caller()), "Not owner");
        transactionCount = transactionCount + BigUint::from(1u32);
        self.transaction_submitted_event(&transactionCount);
    }

    #[endpoint]
    fn confirm_transaction(&self, txId: BigUint<Self::Api>) {
        require!(self.owners(&self.blockchain().get_caller()), "Not owner");
        self.transaction_confirmed_event(&txId, &self.blockchain().get_caller());
    }

    #[endpoint]
    fn execute_transaction(&self, txId: BigUint<Self::Api>) {
        require!(self.owners(&self.blockchain().get_caller()), "Not owner");
        self.transaction_executed_event(&txId);
    }

}