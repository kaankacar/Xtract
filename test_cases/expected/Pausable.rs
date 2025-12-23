#![no_std]

use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait Pausable {
    #[storage_mapper("owner")]
    fn owner(&self) -> SingleValueMapper<ManagedAddress<Self::Api>>;

    #[storage_mapper("paused")]
    fn paused(&self) -> SingleValueMapper<bool>;

    #[event("Paused")]
    fn paused_event(&self, #[indexed] account: &ManagedAddress<Self::Api>);

    #[event("Unpaused")]
    fn unpaused_event(&self, #[indexed] account: &ManagedAddress<Self::Api>);

    #[init]
    fn init(&self) {
        owner = self.blockchain().get_caller();
        paused = false;
    }

    #[endpoint]
    fn pause(&self) {
        require!(self.blockchain().get_caller() == owner, "Not owner");
        require!(!self.paused().get(), "Paused");
        paused = true;
        self.paused_event(&self.blockchain().get_caller());
    }

    #[endpoint]
    fn unpause(&self) {
        require!(self.blockchain().get_caller() == owner, "Not owner");
        require!(self.paused().get(), "Not paused");
        paused = false;
        self.unpaused_event(&self.blockchain().get_caller());
    }

}