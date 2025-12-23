#![no_std]

use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait Staking {
    #[storage_mapper("totalStaked")]
    fn total_staked(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("rewardRate")]
    fn reward_rate(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("stakes")]
    fn stakes(&self, key: &ManagedAddress<Self::Api>) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("rewards")]
    fn rewards(&self, key: &ManagedAddress<Self::Api>) -> SingleValueMapper<BigUint<Self::Api>>;

    #[event("Staked")]
    fn staked_event(&self, #[indexed] user: &ManagedAddress<Self::Api>, amount: &BigUint<Self::Api>);

    #[event("Unstaked")]
    fn unstaked_event(&self, #[indexed] user: &ManagedAddress<Self::Api>, amount: &BigUint<Self::Api>);

    #[event("RewardClaimed")]
    fn reward_claimed_event(&self, #[indexed] user: &ManagedAddress<Self::Api>, amount: &BigUint<Self::Api>);

    #[init]
    fn init(&self) {
        rewardRate = BigUint::from(100u32);
    }

    #[endpoint]
    fn stake(&self, amount: BigUint<Self::Api>) {
        require!(amount > BigUint::from(0u32), "Cannot stake zero");
        totalStaked = totalStaked + amount.clone();
        self.staked_event(&self.blockchain().get_caller(), &amount.clone());
    }

    #[endpoint]
    fn unstake(&self, amount: BigUint<Self::Api>) {
        require!(self.stakes(&self.blockchain().get_caller()) >= amount, "Insufficient stake");
        totalStaked = totalStaked - amount.clone();
        self.unstaked_event(&self.blockchain().get_caller(), &amount.clone());
    }

    #[endpoint]
    fn claim_reward(&self) {
        uint256 reward = self.rewards(&self.blockchain().get_caller());
        require!(reward > BigUint::from(0u32), "No reward");
        self.reward_claimed_event(&self.blockchain().get_caller(), &reward);
    }

    #[view(getStake)]
    fn get_stake(&self, user: ManagedAddress<Self::Api>) -> BigUint<Self::Api> {
        return self.stakes(&user);
    }

}