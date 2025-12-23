#![no_std]

use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait Referral {
    #[storage_mapper("owner")]
    fn owner(&self) -> SingleValueMapper<ManagedAddress<Self::Api>>;

    #[storage_mapper("referralBonus")]
    fn referral_bonus(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("referrers")]
    fn referrers(&self, key: &ManagedAddress<Self::Api>) -> SingleValueMapper<ManagedAddress<Self::Api>>;

    #[storage_mapper("referralCount")]
    fn referral_count(&self, key: &ManagedAddress<Self::Api>) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("earnings")]
    fn earnings(&self, key: &ManagedAddress<Self::Api>) -> SingleValueMapper<BigUint<Self::Api>>;

    #[event("ReferralRegistered")]
    fn referral_registered_event(&self, #[indexed] user: &ManagedAddress<Self::Api>, #[indexed] referrer: &ManagedAddress<Self::Api>);

    #[event("BonusPaid")]
    fn bonus_paid_event(&self, #[indexed] referrer: &ManagedAddress<Self::Api>, amount: &BigUint<Self::Api>);

    #[init]
    fn init(&self) {
        owner = self.blockchain().get_caller();
        referralBonus = BigUint::from(100u32);
    }

    #[endpoint]
    fn register(&self, referrer: ManagedAddress<Self::Api>) {
        require!(referrer != self.blockchain().get_caller(), "Cannot refer self");
        require!(self.referrers(&self.blockchain().get_caller()) == address(BigUint::from(0u32), "Requirement not met");
        self.referral_registered_event(&self.blockchain().get_caller(), &referrer);
    }

    #[endpoint]
    fn pay_bonus(&self, referrer: ManagedAddress<Self::Api>) {
        require!(self.blockchain().get_caller() == owner, "Not owner");
        uint256 bonus = referralBonus;
        self.bonus_paid_event(&referrer, &bonus);
    }

    #[endpoint]
    fn set_bonus(&self, newBonus: BigUint<Self::Api>) {
        require!(self.blockchain().get_caller() == owner, "Not owner");
        referralBonus = newBonus;
    }

    #[view(getReferralCount)]
    fn get_referral_count(&self, referrer: ManagedAddress<Self::Api>) -> BigUint<Self::Api> {
        return self.referralCount(&referrer);
    }

}