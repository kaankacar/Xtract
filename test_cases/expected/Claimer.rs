#![no_std]

use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait Claimer {
    #[storage_mapper("owner")]
    fn owner(&self) -> SingleValueMapper<ManagedAddress<Self::Api>>;

    #[storage_mapper("claimAmount")]
    fn claim_amount(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("totalClaimed")]
    fn total_claimed(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("hasClaimed")]
    fn has_claimed(&self, key: &ManagedAddress<Self::Api>) -> SingleValueMapper<bool>;

    #[storage_mapper("claimedAt")]
    fn claimed_at(&self, key: &ManagedAddress<Self::Api>) -> SingleValueMapper<BigUint<Self::Api>>;

    #[event("Claimed")]
    fn claimed_event(&self, #[indexed] user: &ManagedAddress<Self::Api>, amount: &BigUint<Self::Api>, #[indexed] timestamp: &BigUint<Self::Api>);

    #[event("ClaimAmountUpdated")]
    fn claim_amount_updated_event(&self, #[indexed] oldAmount: &BigUint<Self::Api>, #[indexed] newAmount: &BigUint<Self::Api>);

    #[init]
    fn init(&self) {
        owner = self.blockchain().get_caller();
        claimAmount = BigUint::from(100u32);
        totalClaimed = BigUint::from(0u32);
    }

    #[endpoint]
    fn claim(&self) {
        require!(!self.hasClaimed(&self.blockchain().get_caller()), "Already claimed");
        totalClaimed = totalClaimed + claimAmount;
        self.claimed_event(&self.blockchain().get_caller(), &claimAmount, &self.blockchain().get_block_timestamp());
    }

    #[endpoint]
    fn set_claim_amount(&self, newAmount: BigUint<Self::Api>) {
        require!(self.blockchain().get_caller() == owner, "Not owner");
        self.claim_amount_updated_event(&claimAmount, &newAmount);
        claimAmount = newAmount;
    }

    #[view(checkClaimed)]
    fn check_claimed(&self, user: ManagedAddress<Self::Api>) -> bool {
        return self.hasClaimed(&user);
    }

    #[view(getTotalClaimed)]
    fn get_total_claimed(&self) -> BigUint<Self::Api> {
        return totalClaimed;
    }

}