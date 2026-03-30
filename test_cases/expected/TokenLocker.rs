#![no_std]

use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait TokenLocker {
    #[storage_mapper("owner")]
    fn owner(&self) -> SingleValueMapper<ManagedAddress<Self::Api>>;

    #[storage_mapper("lockedAmount")]
    fn locked_amount(&self, key: &ManagedAddress<Self::Api>) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("lockExpiry")]
    fn lock_expiry(&self, key: &ManagedAddress<Self::Api>) -> SingleValueMapper<BigUint<Self::Api>>;

    #[event("TokensLocked")]
    fn tokens_locked_event(&self, #[indexed] user: &ManagedAddress<Self::Api>, amount: &BigUint<Self::Api>, #[indexed] expiry: &BigUint<Self::Api>);

    #[event("TokensUnlocked")]
    fn tokens_unlocked_event(&self, #[indexed] user: &ManagedAddress<Self::Api>, amount: &BigUint<Self::Api>);

    #[init]
    fn init(&self) {
        owner = self.blockchain().get_caller();
    }

    #[endpoint]
    fn lock_tokens(&self, amount: BigUint<Self::Api>, duration: BigUint<Self::Api>) {
        require!(amount > BigUint::from(0u32), "Invalid amount");
        require!(duration > BigUint::from(0u32), "Invalid duration");
        self.tokens_locked_event(&self.blockchain().get_caller(), &amount.clone(), &self.lockExpiry(&self.blockchain().get_caller()));
    }

    #[endpoint]
    fn unlock_tokens(&self) {
        require!(self.lockedAmount(&self.blockchain().get_caller()) > BigUint::from(0u32), "No locked tokens");
        require!(self.blockchain().get_block_timestamp() >= self.lockExpiry(&self.blockchain().get_caller()), "Not yet unlocked");
        let mut amount: BigUint<Self::Api> = self.lockedAmount(&self.blockchain().get_caller());
        self.tokens_unlocked_event(&self.blockchain().get_caller(), &amount.clone());
    }

    #[view(getLockedAmount)]
    fn get_locked_amount(&self, user: ManagedAddress<Self::Api>) -> BigUint<Self::Api> {
        return self.lockedAmount(&user);
    }

    #[view(getLockExpiry)]
    fn get_lock_expiry(&self, user: ManagedAddress<Self::Api>) -> BigUint<Self::Api> {
        return self.lockExpiry(&user);
    }

}