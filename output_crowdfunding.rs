#![no_std]

use multiversx_sc::imports::*;
use multiversx_sc::derive_imports::*;

#[derive(TypeAbi, TopEncode, TopDecode, NestedEncode, NestedDecode, ManagedVecItem)]
pub struct Campaign<M: ManagedTypeApi> {
    pub creator: ManagedAddress<M>,
    pub goal: BigUint<M>,
    pub pledged: BigUint<M>,
    pub startAt: uint32,
    pub endAt: uint32,
    pub claimed: bool
}

#[multiversx_sc::contract]
pub trait Crowdfunding {
    #[storage_mapper("creator")]
    fn creator(&self) -> SingleValueMapper<ManagedAddress<Self::Api>>;

    #[storage_mapper("goal")]
    fn goal(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("pledged")]
    fn pledged(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("claimed")]
    fn claimed(&self) -> SingleValueMapper<bool>;

    #[storage_mapper("count")]
    fn count(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[event("CampaignCreated")]
    fn campaign_created_event(&self, #[indexed] id: BigUint<Self::Api>, #[indexed] creator: ManagedAddress<Self::Api>, goal: BigUint<Self::Api>, startAt: uint32, endAt: uint32);

    #[event("PledgeCreated")]
    fn pledge_created_event(&self, #[indexed] id: BigUint<Self::Api>, #[indexed] pledger: ManagedAddress<Self::Api>, amount: BigUint<Self::Api>);

    #[event("Unpledged")]
    fn unpledged_event(&self, #[indexed] id: BigUint<Self::Api>, #[indexed] pledger: ManagedAddress<Self::Api>, amount: BigUint<Self::Api>);

    #[event("Claimed")]
    fn claimed_event(&self, #[indexed] id: BigUint<Self::Api>, creator: ManagedAddress<Self::Api>, amount: BigUint<Self::Api>);

    #[event("Refunded")]
    fn refunded_event(&self, #[indexed] id: BigUint<Self::Api>, #[indexed] pledger: ManagedAddress<Self::Api>, amount: BigUint<Self::Api>);

    #[init]
    fn init(&self) {}

    #[endpoint]
    fn create_campaign(&self, goal: BigUint<Self::Api>, startAt: uint32, endAt: uint32) -> BigUint<Self::Api> {
        // Function body would go here
    }

    #[endpoint]
    fn pledge(&self, id: BigUint<Self::Api>) {
        // Function body would go here
    }

    #[endpoint]
    fn unpledge(&self, id: BigUint<Self::Api>, amount: BigUint<Self::Api>) {
        // Function body would go here
    }

    #[endpoint]
    fn claim(&self, id: BigUint<Self::Api>) {
        // Function body would go here
    }

    #[endpoint]
    fn refund(&self, id: BigUint<Self::Api>) {
        // Function body would go here
    }

    #[view(getCampaign)]
    fn get_campaign(&self, id: BigUint<Self::Api>) -> ManagedAddress<Self::Api> {
        // Function body would go here
    }

}