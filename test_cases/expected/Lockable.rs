#![no_std]

use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait Lockable {
    #[storage_mapper("owner")]
    fn owner(&self) -> SingleValueMapper<ManagedAddress<Self::Api>>;

    #[storage_mapper("locked")]
    fn locked(&self) -> SingleValueMapper<bool>;

    #[storage_mapper("unlockTime")]
    fn unlock_time(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("value")]
    fn value(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[event("Locked")]
    fn locked_event(&self, until: &BigUint<Self::Api>);

    #[event("Unlocked")]
    fn unlocked_event(&self);

    #[event("ValueSet")]
    fn value_set_event(&self, #[indexed] newValue: &BigUint<Self::Api>);

    #[init]
    fn init(&self) {
        owner = self.blockchain().get_caller();
        locked = false;
        self.value().set(&(BigUint::from(0u32)));
    }

    #[endpoint]
    fn lock(&self, duration: BigUint<Self::Api>) {
        require!(self.blockchain().get_caller() == owner, "Not owner");
        require!(!self.locked().get(), "Contract is locked");
        locked = true;
        unlockTime = self.blockchain().get_block_timestamp() + duration;
        self.locked_event(&unlockTime);
    }

    #[endpoint]
    fn unlock(&self) {
        require!(self.blockchain().get_caller() == owner, "Not owner");
        require!(self.locked().get(), "Not locked");
        require!(self.blockchain().get_block_timestamp() >= unlockTime, "Not yet unlocked");
        locked = false;
        self.unlocked_event();
    }

    #[endpoint]
    fn set_value(&self, newValue: BigUint<Self::Api>) {
        require!(self.blockchain().get_caller() == owner, "Not owner");
        require!(!self.locked().get(), "Contract is locked");
        self.value().set(&newValue);
        self.value_set_event(&newValue);
    }

    #[view(getValue)]
    fn get_value(&self) -> BigUint<Self::Api> {
        return self.value().get();
    }

}