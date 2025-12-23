#![no_std]

use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait NestedMapping {
    #[storage_mapper("allowance")]
    fn allowance(&self, key1: &ManagedAddress<Self::Api>, key2: &ManagedAddress<Self::Api>) -> SingleValueMapper<BigUint<Self::Api>>;

    #[event("Approval")]
    fn approval_event(&self, #[indexed] owner: &ManagedAddress<Self::Api>, #[indexed] spender: &ManagedAddress<Self::Api>, value: &BigUint<Self::Api>);

    #[init]
    fn init(&self) {}

    #[endpoint]
    fn approve(&self, spender: ManagedAddress<Self::Api>, amount: BigUint<Self::Api>) -> bool {
        self.approval_event(&self.blockchain().get_caller(), &spender, &amount.clone());
        return true;
    }

    #[view(getAllowance)]
    fn get_allowance(&self, owner: ManagedAddress<Self::Api>, spender: ManagedAddress<Self::Api>) -> BigUint<Self::Api> {
        return self.allowance(&owner, &spender);
    }

}