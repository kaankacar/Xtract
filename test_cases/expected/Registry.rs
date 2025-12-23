#![no_std]

use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait Registry {
    #[storage_mapper("owner")]
    fn owner(&self) -> SingleValueMapper<ManagedAddress<Self::Api>>;

    #[storage_mapper("registry")]
    fn registry(&self, key: &ManagedBuffer<Self::Api>) -> SingleValueMapper<ManagedAddress<Self::Api>>;

    #[event("Registered")]
    fn registered_event(&self, #[indexed] name: &ManagedBuffer<Self::Api>, #[indexed] addr: &ManagedAddress<Self::Api>);

    #[event("Unregistered")]
    fn unregistered_event(&self, #[indexed] name: &ManagedBuffer<Self::Api>);

    #[init]
    fn init(&self) {
        owner = self.blockchain().get_caller();
    }

    #[endpoint]
    fn register(&self, memory: ManagedBuffer<Self::Api>, addr: ManagedAddress<Self::Api>) {
        require!(self.blockchain().get_caller() == owner, "Not owner");
        require!(addr != address(BigUint::from(0u32), "Requirement not met");
        self.registered_event(&self.name().get(), &addr);
    }

    #[endpoint]
    fn unregister(&self, memory: ManagedBuffer<Self::Api>) {
        require!(self.blockchain().get_caller() == owner, "Not owner");
        self.unregistered_event(&self.name().get());
    }

    #[view(lookup)]
    fn lookup(&self, memory: ManagedBuffer<Self::Api>) -> ManagedAddress<Self::Api> {
        return self.registry(&self.name().get());
    }

}