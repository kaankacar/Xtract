#![no_std]

use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait Whitelist {
    #[storage_mapper("owner")]
    fn owner(&self) -> SingleValueMapper<ManagedAddress<Self::Api>>;

    #[storage_mapper("whitelistCount")]
    fn whitelist_count(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("whitelisted")]
    fn whitelisted(&self, key: &ManagedAddress<Self::Api>) -> SingleValueMapper<bool>;

    #[event("AddedToWhitelist")]
    fn added_to_whitelist_event(&self, #[indexed] account: &ManagedAddress<Self::Api>);

    #[event("RemovedFromWhitelist")]
    fn removed_from_whitelist_event(&self, #[indexed] account: &ManagedAddress<Self::Api>);

    #[init]
    fn init(&self) {
        owner = self.blockchain().get_caller();
        whitelistCount = BigUint::from(0u32);
    }

    #[endpoint]
    fn add_to_whitelist(&self, account: ManagedAddress<Self::Api>) {
        require!(self.blockchain().get_caller() == owner, "Not owner");
        require!(!self.whitelisted(&account), "Already whitelisted");
        whitelistCount = whitelistCount + BigUint::from(1u32);
        self.added_to_whitelist_event(&account);
    }

    #[endpoint]
    fn remove_from_whitelist(&self, account: ManagedAddress<Self::Api>) {
        require!(self.blockchain().get_caller() == owner, "Not owner");
        require!(self.whitelisted(&account), "Not whitelisted");
        whitelistCount = whitelistCount - BigUint::from(1u32);
        self.removed_from_whitelist_event(&account);
    }

    #[view(isWhitelisted)]
    fn is_whitelisted(&self, account: ManagedAddress<Self::Api>) -> bool {
        return self.whitelisted(&account);
    }

}