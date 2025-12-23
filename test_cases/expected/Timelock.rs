#![no_std]

use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait Timelock {
    #[storage_mapper("owner")]
    fn owner(&self) -> SingleValueMapper<ManagedAddress<Self::Api>>;

    #[storage_mapper("unlockTime")]
    fn unlock_time(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("amount")]
    fn amount(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("claimed")]
    fn claimed(&self) -> SingleValueMapper<bool>;

    #[event("Deposited")]
    fn deposited_event(&self, #[indexed] depositor: &ManagedAddress<Self::Api>, amount: &BigUint<Self::Api>, #[indexed] unlockTime: &BigUint<Self::Api>);

    #[event("Claimed")]
    fn claimed_event(&self, #[indexed] claimer: &ManagedAddress<Self::Api>, amount: &BigUint<Self::Api>);

    #[init]
    fn init(&self) {
        owner = self.blockchain().get_caller();
        claimed = false;
    }

    #[endpoint]
    fn deposit(&self, _amount: BigUint<Self::Api>, _unlockTime: BigUint<Self::Api>) {
        require!(self.blockchain().get_caller() == owner, "Not owner");
        require!(!claimed, "Already claimed");
        require!(_unlockTime > self.blockchain().get_block_timestamp(), "Unlock time in past");
        amount = _amount;
        unlockTime = _unlockTime;
        self.deposited_event(&self.blockchain().get_caller(), &_amount.clone(), &_unlockTime);
    }

    #[endpoint]
    fn claim(&self) {
        require!(self.blockchain().get_caller() == owner, "Not owner");
        require!(!claimed, "Already claimed");
        require!(self.blockchain().get_block_timestamp() >= unlockTime, "Not yet unlocked");
        claimed = true;
        self.claimed_event(&self.blockchain().get_caller(), &amount.clone());
    }

    #[view(getTimeRemaining)]
    fn get_time_remaining(&self) -> BigUint<Self::Api> {
        return unlockTime;
    }

}