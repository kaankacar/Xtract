#![no_std]

use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait Leaderboard {
    #[storage_mapper("owner")]
    fn owner(&self) -> SingleValueMapper<ManagedAddress<Self::Api>>;

    #[storage_mapper("highestScore")]
    fn highest_score(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("leader")]
    fn leader(&self) -> SingleValueMapper<ManagedAddress<Self::Api>>;

    #[storage_mapper("scores")]
    fn scores(&self, key: &ManagedAddress<Self::Api>) -> SingleValueMapper<BigUint<Self::Api>>;

    #[event("ScoreUpdated")]
    fn score_updated_event(&self, #[indexed] player: &ManagedAddress<Self::Api>, score: &BigUint<Self::Api>);

    #[event("NewLeader")]
    fn new_leader_event(&self, #[indexed] player: &ManagedAddress<Self::Api>, score: &BigUint<Self::Api>);

    #[init]
    fn init(&self) {
        owner = self.blockchain().get_caller();
        highestScore = BigUint::from(0u32);
    }

    #[endpoint]
    fn update_score(&self, player: ManagedAddress<Self::Api>, score: BigUint<Self::Api>) {
        require!(self.blockchain().get_caller() == owner, "Not owner");
        self.score_updated_event(&player, &score);
    }

    #[endpoint]
    fn submit_score(&self, score: BigUint<Self::Api>) {
        self.score_updated_event(&self.blockchain().get_caller(), &score);
    }

    #[endpoint]
    fn claim_leadership(&self) {
        require!(self.scores(&self.blockchain().get_caller()) > highestScore, "Not highest score");
        highestScore = self.scores(&self.blockchain().get_caller());
        leader = self.blockchain().get_caller();
        self.new_leader_event(&self.blockchain().get_caller(), &highestScore);
    }

    #[view(getScore)]
    fn get_score(&self, player: ManagedAddress<Self::Api>) -> BigUint<Self::Api> {
        return self.scores(&player);
    }

    #[view(getLeader)]
    fn get_leader(&self) -> ManagedAddress<Self::Api> {
        return leader;
    }

}