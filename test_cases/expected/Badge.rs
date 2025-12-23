#![no_std]

use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait Badge {
    #[storage_mapper("admin")]
    fn admin(&self) -> SingleValueMapper<ManagedAddress<Self::Api>>;

    #[storage_mapper("badgeCount")]
    fn badge_count(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("hasBadge")]
    fn has_badge(&self, key1: &ManagedAddress<Self::Api>, key2: &BigUint<Self::Api>) -> SingleValueMapper<bool>;

    #[storage_mapper("badgeName")]
    fn badge_name(&self, key: &BigUint<Self::Api>) -> SingleValueMapper<ManagedBuffer<Self::Api>>;

    #[storage_mapper("badgeCountPerUser")]
    fn badge_count_per_user(&self, key: &ManagedAddress<Self::Api>) -> SingleValueMapper<BigUint<Self::Api>>;

    #[event("BadgeCreated")]
    fn badge_created_event(&self, #[indexed] badgeId: &BigUint<Self::Api>, name: &ManagedBuffer<Self::Api>);

    #[event("BadgeAwarded")]
    fn badge_awarded_event(&self, #[indexed] user: &ManagedAddress<Self::Api>, #[indexed] badgeId: &BigUint<Self::Api>);

    #[event("BadgeRevoked")]
    fn badge_revoked_event(&self, #[indexed] user: &ManagedAddress<Self::Api>, #[indexed] badgeId: &BigUint<Self::Api>);

    #[init]
    fn init(&self) {
        admin = self.blockchain().get_caller();
        badgeCount = BigUint::from(0u32);
    }

    #[endpoint]
    fn create_badge(&self, memory: ManagedBuffer<Self::Api>) {
        require!(self.blockchain().get_caller() == self.admin().get(), "Not admin");
        badgeCount = badgeCount + BigUint::from(1u32);
        self.badge_created_event(&badgeCount, &self.name().get());
    }

    #[endpoint]
    fn award_badge(&self, user: ManagedAddress<Self::Api>, badgeId: BigUint<Self::Api>) {
        require!(self.blockchain().get_caller() == self.admin().get(), "Not admin");
        require!(!self.hasBadge(&user, &badgeId), "Already has badge");
        self.badge_awarded_event(&user, &badgeId);
    }

    #[endpoint]
    fn revoke_badge(&self, user: ManagedAddress<Self::Api>, badgeId: BigUint<Self::Api>) {
        require!(self.blockchain().get_caller() == self.admin().get(), "Not admin");
        require!(self.hasBadge(&user, &badgeId), "Does not have badge");
        self.badge_revoked_event(&user, &badgeId);
    }

    #[view(checkBadge)]
    fn check_badge(&self, user: ManagedAddress<Self::Api>, badgeId: BigUint<Self::Api>) -> bool {
        return self.hasBadge(&user, &badgeId);
    }

}