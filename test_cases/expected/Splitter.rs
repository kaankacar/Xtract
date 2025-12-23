#![no_std]

use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait Splitter {
    #[storage_mapper("owner")]
    fn owner(&self) -> SingleValueMapper<ManagedAddress<Self::Api>>;

    #[storage_mapper("splitCount")]
    fn split_count(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("totalShares")]
    fn total_shares(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("recipient")]
    fn recipient(&self, key: &BigUint<Self::Api>) -> SingleValueMapper<ManagedAddress<Self::Api>>;

    #[storage_mapper("share")]
    fn share(&self, key: &BigUint<Self::Api>) -> SingleValueMapper<BigUint<Self::Api>>;

    #[event("RecipientAdded")]
    fn recipient_added_event(&self, #[indexed] index: &BigUint<Self::Api>, #[indexed] recipient: &ManagedAddress<Self::Api>, share: &BigUint<Self::Api>);

    #[event("RecipientRemoved")]
    fn recipient_removed_event(&self, #[indexed] index: &BigUint<Self::Api>);

    #[event("SplitExecuted")]
    fn split_executed_event(&self, amount: &BigUint<Self::Api>);

    #[init]
    fn init(&self) {
        owner = self.blockchain().get_caller();
        splitCount = BigUint::from(0u32);
        totalShares = BigUint::from(0u32);
    }

    #[endpoint]
    fn add_recipient(&self, _recipient: ManagedAddress<Self::Api>, _share: BigUint<Self::Api>) {
        require!(self.blockchain().get_caller() == owner, "Not owner");
        require!(_recipient != address(BigUint::from(0u32), "Requirement not met");
        require!(_share > BigUint::from(0u32), "Invalid share");
        splitCount = splitCount + BigUint::from(1u32);
        totalShares = totalShares + _share;
        self.recipient_added_event(&splitCount, &_recipient, &_share);
    }

    #[endpoint]
    fn remove_recipient(&self, index: BigUint<Self::Api>) {
        require!(self.blockchain().get_caller() == owner, "Not owner");
        require!(self.recipient(&index) != address(BigUint::from(0u32), "Requirement not met");
        totalShares = totalShares - self.share(&index);
        self.recipient_removed_event(&index);
    }

    #[endpoint]
    fn split(&self, amount: BigUint<Self::Api>) {
        require!(self.blockchain().get_caller() == owner, "Not owner");
        require!(totalShares > BigUint::from(0u32), "No recipients");
        self.split_executed_event(&amount.clone());
    }

    #[view(getShare)]
    fn get_share(&self, index: BigUint<Self::Api>) -> BigUint<Self::Api> {
        return self.share(&index);
    }

}