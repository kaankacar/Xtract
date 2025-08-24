#![no_std]

use multiversx_sc::imports::*;
use multiversx_sc::derive_imports::*;

#[derive(TypeAbi, TopEncode, TopDecode, NestedEncode, NestedDecode, ManagedVecItem)]
pub struct Campaign<M: ManagedTypeApi> {
    pub creator: ManagedAddress<M>,
    pub goal: BigUint<M>,
    pub pledged: BigUint<M>,
    pub start_at: u32,
    pub end_at: u32,
    pub claimed: bool,
}

#[multiversx_sc::contract]
pub trait Crowdfunding {
    #[storage_mapper("count")]
    fn count(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("campaigns")]
    fn campaigns(&self, id: &BigUint<Self::Api>) -> SingleValueMapper<Campaign<Self::Api>>;

    #[storage_mapper("pledges")]
    fn pledges(&self, id: &BigUint<Self::Api>, address: &ManagedAddress<Self::Api>) -> SingleValueMapper<BigUint<Self::Api>>;

    #[event("CampaignCreated")]
    fn campaign_created_event(
        &self,
        #[indexed] id: &BigUint<Self::Api>,
        #[indexed] creator: &ManagedAddress<Self::Api>,
        goal: &BigUint<Self::Api>,
        start_at: u32,
        end_at: u32,
    );

    #[event("PledgeCreated")]
    fn pledge_created_event(
        &self,
        #[indexed] id: &BigUint<Self::Api>,
        #[indexed] pledger: &ManagedAddress<Self::Api>,
        amount: &BigUint<Self::Api>,
    );

    #[event("Unpledged")]
    fn unpledged_event(
        &self,
        #[indexed] id: &BigUint<Self::Api>,
        #[indexed] pledger: &ManagedAddress<Self::Api>,
        amount: &BigUint<Self::Api>,
    );

    #[event("Claimed")]
    fn claimed_event(
        &self,
        #[indexed] id: &BigUint<Self::Api>,
        creator: &ManagedAddress<Self::Api>,
        amount: &BigUint<Self::Api>,
    );

    #[event("Refunded")]
    fn refunded_event(
        &self,
        #[indexed] id: &BigUint<Self::Api>,
        #[indexed] pledger: &ManagedAddress<Self::Api>,
        amount: &BigUint<Self::Api>,
    );

    #[init]
    fn init(&self) {
        self.count().set(BigUint::zero());
    }

    fn check_campaign_exists(&self, id: &BigUint<Self::Api>) {
        let count = self.count().get();
        require!(id < &count, "Campaign does not exist");
    }

    #[endpoint]
    fn create_campaign(
        &self,
        goal: BigUint<Self::Api>,
        start_at: u32,
        end_at: u32,
    ) -> BigUint<Self::Api> {
        let current_timestamp = self.blockchain().get_block_timestamp();
        require!(
            start_at >= current_timestamp,
            "Start time must be in the future"
        );
        require!(end_at > start_at, "End time must be after start time");
        
        // 90 days in seconds
        let ninety_days: u32 = 90 * 24 * 60 * 60;
        require!(
            end_at <= current_timestamp + ninety_days,
            "End time too far in the future"
        );

        let id = self.count().get();
        let caller = self.blockchain().get_caller();

        let campaign = Campaign {
            creator: caller.clone(),
            goal,
            pledged: BigUint::zero(),
            start_at,
            end_at,
            claimed: false,
        };

        self.campaigns(&id).set(campaign);
        self.count().set(id.clone() + 1u32);

        self.campaign_created_event(&id, &caller, &goal, start_at, end_at);

        id
    }

    #[payable("EGLD")]
    #[endpoint]
    fn pledge(&self, id: BigUint<Self::Api>) {
        self.check_campaign_exists(&id);

        let payment = self.call_value().egld_value();
        let caller = self.blockchain().get_caller();
        let current_timestamp = self.blockchain().get_block_timestamp();

        let mut campaign = self.campaigns(&id).get();
        require!(
            current_timestamp >= campaign.start_at,
            "Campaign not started"
        );
        require!(current_timestamp <= campaign.end_at, "Campaign ended");

        campaign.pledged += payment.clone();
        self.campaigns(&id).set(campaign);

        let current_pledge = self.pledges(&id, &caller).get();
        self.pledges(&id, &caller).set(current_pledge + payment.clone());

        self.pledge_created_event(&id, &caller, &payment);
    }

    #[endpoint]
    fn unpledge(&self, id: BigUint<Self::Api>, amount: BigUint<Self::Api>) {
        self.check_campaign_exists(&id);

        let caller = self.blockchain().get_caller();
        let current_timestamp = self.blockchain().get_block_timestamp();

        let mut campaign = self.campaigns(&id).get();
        require!(current_timestamp <= campaign.end_at, "Campaign ended");

        let current_pledge = self.pledges(&id, &caller).get();
        require!(current_pledge >= amount, "Not enough pledged");

        campaign.pledged -= &amount;
        self.campaigns(&id).set(campaign);

        self.pledges(&id, &caller).set(current_pledge - &amount);

        self.send().direct_egld(&caller, &amount);

        self.unpledged_event(&id, &caller, &amount);
    }

    #[endpoint]
    fn claim(&self, id: BigUint<Self::Api>) {
        self.check_campaign_exists(&id);

        let caller = self.blockchain().get_caller();
        let current_timestamp = self.blockchain().get_block_timestamp();

        let mut campaign = self.campaigns(&id).get();
        require!(campaign.creator == caller, "Not campaign creator");
        require!(current_timestamp > campaign.end_at, "Campaign not ended");
        require!(campaign.pledged >= campaign.goal, "Goal not reached");
        require!(!campaign.claimed, "Already claimed");

        campaign.claimed = true;
        self.campaigns(&id).set(campaign.clone());

        self.send().direct_egld(&caller, &campaign.pledged);

        self.claimed_event(&id, &caller, &campaign.pledged);
    }

    #[endpoint]
    fn refund(&self, id: BigUint<Self::Api>) {
        self.check_campaign_exists(&id);

        let caller = self.blockchain().get_caller();
        let current_timestamp = self.blockchain().get_block_timestamp();

        let campaign = self.campaigns(&id).get();
        require!(current_timestamp > campaign.end_at, "Campaign not ended");
        require!(campaign.pledged < campaign.goal, "Goal reached");

        let pledge_amount = self.pledges(&id, &caller).get();
        require!(pledge_amount > 0, "Nothing to refund");

        self.pledges(&id, &caller).set(BigUint::zero());
        self.send().direct_egld(&caller, &pledge_amount);

        self.refunded_event(&id, &caller, &pledge_amount);
    }

    #[view]
    fn get_campaign(
        &self,
        id: BigUint<Self::Api>,
    ) -> MultiValue<ManagedAddress<Self::Api>, BigUint<Self::Api>, BigUint<Self::Api>, u32, u32, bool> {
        self.check_campaign_exists(&id);

        let campaign = self.campaigns(&id).get();
        (
            campaign.creator,
            campaign.goal,
            campaign.pledged,
            campaign.start_at,
            campaign.end_at,
            campaign.claimed
        ).into()
    }
} 