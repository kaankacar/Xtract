#![no_std]

use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait Config {
    #[storage_mapper("owner")]
    fn owner(&self) -> SingleValueMapper<ManagedAddress<Self::Api>>;

    #[storage_mapper("uintConfig")]
    fn uint_config(&self, key: &ManagedBuffer<Self::Api>) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("boolConfig")]
    fn bool_config(&self, key: &ManagedBuffer<Self::Api>) -> SingleValueMapper<bool>;

    #[storage_mapper("addressConfig")]
    fn address_config(&self, key: &ManagedBuffer<Self::Api>) -> SingleValueMapper<ManagedAddress<Self::Api>>;

    #[event("UintConfigSet")]
    fn uint_config_set_event(&self, #[indexed] key: &ManagedBuffer<Self::Api>, value: &BigUint<Self::Api>);

    #[event("BoolConfigSet")]
    fn bool_config_set_event(&self, #[indexed] key: &ManagedBuffer<Self::Api>, value: &bool);

    #[event("AddressConfigSet")]
    fn address_config_set_event(&self, #[indexed] key: &ManagedBuffer<Self::Api>, value: &ManagedAddress<Self::Api>);

    #[init]
    fn init(&self) {
        owner = self.blockchain().get_caller();
    }

    #[endpoint]
    fn set_uint(&self, memory: ManagedBuffer<Self::Api>, value: BigUint<Self::Api>) {
        require!(self.blockchain().get_caller() == owner, "Not owner");
        self.uint_config_set_event(&key, &self.value().get());
    }

    #[endpoint]
    fn set_bool(&self, memory: ManagedBuffer<Self::Api>, value: bool) {
        require!(self.blockchain().get_caller() == owner, "Not owner");
        self.bool_config_set_event(&key, &self.value().get());
    }

    #[endpoint]
    fn set_address(&self, memory: ManagedBuffer<Self::Api>, value: ManagedAddress<Self::Api>) {
        require!(self.blockchain().get_caller() == owner, "Not owner");
        self.address_config_set_event(&key, &self.value().get());
    }

    #[view(getUint)]
    fn get_uint(&self, memory: ManagedBuffer<Self::Api>) -> BigUint<Self::Api> {
        return self.uintConfig(&key);
    }

    #[view(getBool)]
    fn get_bool(&self, memory: ManagedBuffer<Self::Api>) -> bool {
        return self.boolConfig(&key);
    }

    #[view(getAddress)]
    fn get_address(&self, memory: ManagedBuffer<Self::Api>) -> ManagedAddress<Self::Api> {
        return self.addressConfig(&key);
    }

}