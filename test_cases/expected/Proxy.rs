#![no_std]

use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait Proxy {
    #[storage_mapper("admin")]
    fn admin(&self) -> SingleValueMapper<ManagedAddress<Self::Api>>;

    #[storage_mapper("implementation")]
    fn implementation(&self) -> SingleValueMapper<ManagedAddress<Self::Api>>;

    #[storage_mapper("initialized")]
    fn initialized(&self) -> SingleValueMapper<bool>;

    #[event("ImplementationUpdated")]
    fn implementation_updated_event(&self, #[indexed] oldImpl: &ManagedAddress<Self::Api>, #[indexed] newImpl: &ManagedAddress<Self::Api>);

    #[event("AdminChanged")]
    fn admin_changed_event(&self, #[indexed] oldAdmin: &ManagedAddress<Self::Api>, #[indexed] newAdmin: &ManagedAddress<Self::Api>);

    #[event("Initialized")]
    fn initialized_event(&self);

    #[init]
    fn init(&self) {
        admin = self.blockchain().get_caller();
        initialized = false;
    }

    #[endpoint]
    fn initialize(&self, impl: ManagedAddress<Self::Api>) {
        require!(self.blockchain().get_caller() == self.admin().get(), "Not admin");
        require!(!self.initialized().get(), "Already initialized");
        require!(impl != address(BigUint::from(0u32), "Requirement not met");
        implementation = impl;
        initialized = true;
        self.initialized_event();
    }

    #[endpoint]
    fn upgrade_to(&self, newImpl: ManagedAddress<Self::Api>) {
        require!(self.blockchain().get_caller() == self.admin().get(), "Not admin");
        require!(newImpl != address(BigUint::from(0u32), "Requirement not met");
        self.implementation_updated_event(&implementation, &newImpl);
        implementation = newImpl;
    }

    #[endpoint]
    fn change_admin(&self, newAdmin: ManagedAddress<Self::Api>) {
        require!(self.blockchain().get_caller() == self.admin().get(), "Not admin");
        require!(newAdmin != address(BigUint::from(0u32), "Requirement not met");
        self.admin_changed_event(&self.admin().get(), &newAdmin);
        admin = newAdmin;
    }

    #[view(getImplementation)]
    fn get_implementation(&self) -> ManagedAddress<Self::Api> {
        return implementation;
    }

}