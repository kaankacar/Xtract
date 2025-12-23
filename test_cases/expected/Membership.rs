#![no_std]

use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait Membership {
    #[storage_mapper("owner")]
    fn owner(&self) -> SingleValueMapper<ManagedAddress<Self::Api>>;

    #[storage_mapper("membershipFee")]
    fn membership_fee(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("memberCount")]
    fn member_count(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("isMember")]
    fn is_member(&self, key: &ManagedAddress<Self::Api>) -> SingleValueMapper<bool>;

    #[storage_mapper("memberSince")]
    fn member_since(&self, key: &ManagedAddress<Self::Api>) -> SingleValueMapper<BigUint<Self::Api>>;

    #[event("MemberJoined")]
    fn member_joined_event(&self, #[indexed] member: &ManagedAddress<Self::Api>, timestamp: &BigUint<Self::Api>);

    #[event("MemberLeft")]
    fn member_left_event(&self, #[indexed] member: &ManagedAddress<Self::Api>);

    #[event("FeeUpdated")]
    fn fee_updated_event(&self, #[indexed] oldFee: &BigUint<Self::Api>, #[indexed] newFee: &BigUint<Self::Api>);

    #[init]
    fn init(&self) {
        owner = self.blockchain().get_caller();
        membershipFee = BigUint::from(100u32);
        memberCount = BigUint::from(0u32);
    }

    #[endpoint]
    fn join(&self) {
        require!(!self.isMember(&self.blockchain().get_caller()), "Already a member");
        memberCount = memberCount + BigUint::from(1u32);
        self.member_joined_event(&self.blockchain().get_caller(), &self.blockchain().get_block_timestamp());
    }

    #[endpoint]
    fn leave(&self) {
        require!(self.isMember(&self.blockchain().get_caller()), "Not a member");
        memberCount = memberCount - BigUint::from(1u32);
        self.member_left_event(&self.blockchain().get_caller());
    }

    #[endpoint]
    fn set_fee(&self, newFee: BigUint<Self::Api>) {
        require!(self.blockchain().get_caller() == owner, "Not owner");
        self.fee_updated_event(&membershipFee, &newFee);
        membershipFee = newFee;
    }

    #[view(checkMembership)]
    fn check_membership(&self, account: ManagedAddress<Self::Api>) -> bool {
        return self.isMember(&account);
    }

}