#![no_std]

use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait OnlyOwner {
    #[storage_mapper("owner")]
    fn owner(&self) -> SingleValueMapper<ManagedAddress<Self::Api>>;

    #[storage_mapper("value")]
    fn value(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[event("OwnershipTransferred")]
    fn ownership_transferred_event(&self, #[indexed] previousOwner: &ManagedAddress<Self::Api>, #[indexed] newOwner: &ManagedAddress<Self::Api>);

    #[event("ValueChanged")]
    fn value_changed_event(&self, #[indexed] newValue: &BigUint<Self::Api>);

    #[init]
    fn init(&self) {
        owner = self.blockchain().get_caller();
    }

    #[endpoint]
    fn set_value(&self, newValue: BigUint<Self::Api>) {
        require!(self.blockchain().get_caller() == owner, "Not owner");
        self.value().set(&newValue);
        self.value_changed_event(&newValue);
    }

    #[endpoint]
    fn transfer_ownership(&self, newOwner: ManagedAddress<Self::Api>) {
        require!(self.blockchain().get_caller() == owner, "Not owner");
        require!(newOwner != address(BigUint::from(0u32), "Requirement not met");
        self.ownership_transferred_event(&owner, &newOwner);
        owner = newOwner;
    }

}