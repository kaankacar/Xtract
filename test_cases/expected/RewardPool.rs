#![no_std]

use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait RewardPool {
    #[storage_mapper("owner")]
    fn owner(&self) -> SingleValueMapper<ManagedAddress<Self::Api>>;

    #[storage_mapper("totalRewards")]
    fn total_rewards(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("rewardRate")]
    fn reward_rate(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("pendingRewards")]
    fn pending_rewards(&self, key: &ManagedAddress<Self::Api>) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("lastUpdateTime")]
    fn last_update_time(&self, key: &ManagedAddress<Self::Api>) -> SingleValueMapper<BigUint<Self::Api>>;

    #[event("RewardAdded")]
    fn reward_added_event(&self, amount: &BigUint<Self::Api>);

    #[event("RewardClaimed")]
    fn reward_claimed_event(&self, #[indexed] user: &ManagedAddress<Self::Api>, amount: &BigUint<Self::Api>);

    #[event("RewardRateUpdated")]
    fn reward_rate_updated_event(&self, #[indexed] oldRate: &BigUint<Self::Api>, #[indexed] newRate: &BigUint<Self::Api>);

    #[init]
    fn init(&self) {
        owner = self.blockchain().get_caller();
        totalRewards = BigUint::from(0u32);
        rewardRate = BigUint::from(100u32);
    }

    #[endpoint]
    fn add_rewards(&self, amount: BigUint<Self::Api>) {
        require!(self.blockchain().get_caller() == owner, "Not owner");
        totalRewards = totalRewards + amount.clone();
        self.reward_added_event(&amount.clone());
    }

    #[endpoint]
    fn claim_reward(&self) {
        let mut reward: BigUint<Self::Api> = self.pendingRewards(&self.blockchain().get_caller());
        require!(reward > BigUint::from(0u32), "No rewards");
        self.reward_claimed_event(&self.blockchain().get_caller(), &reward);
    }

    #[endpoint]
    fn update_reward_rate(&self, newRate: BigUint<Self::Api>) {
        require!(self.blockchain().get_caller() == owner, "Not owner");
        self.reward_rate_updated_event(&self.reward_rate().get(), &newRate);
        rewardRate = newRate;
    }

    #[view(getPendingReward)]
    fn get_pending_reward(&self, user: ManagedAddress<Self::Api>) -> BigUint<Self::Api> {
        return self.pendingRewards(&user);
    }

}