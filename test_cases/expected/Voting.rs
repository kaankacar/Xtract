#![no_std]

use multiversx_sc::imports::*;
use multiversx_sc::derive_imports::*;

#[derive(TypeAbi, TopEncode, TopDecode, NestedEncode, NestedDecode, ManagedVecItem)]
pub struct Proposal<M: ManagedTypeApi> {
    pub description: ManagedBuffer<M>,
    pub vote_count: BigUint<M>,
}

#[derive(TypeAbi, TopEncode, TopDecode, NestedEncode, NestedDecode, ManagedVecItem)]
pub struct Voter<M: ManagedTypeApi> {
    pub has_voted: bool,
    pub voted_proposal_id: BigUint<M>,
}

#[multiversx_sc::contract]
pub trait Voting {
    #[storage_mapper("chairperson")]
    fn chairperson(&self) -> SingleValueMapper<ManagedAddress<Self::Api>>;

    #[storage_mapper("voters")]
    fn voters(&self, address: &ManagedAddress<Self::Api>) -> SingleValueMapper<Voter<Self::Api>>;

    #[storage_mapper("proposals")]
    fn proposals(&self) -> VecMapper<Self::Api, Proposal<Self::Api>>;

    #[storage_mapper("votingEnd")]
    fn voting_end(&self) -> SingleValueMapper<u64>;

    #[storage_mapper("votingClosed")]
    fn voting_closed(&self) -> SingleValueMapper<bool>;

    #[event("ProposalCreated")]
    fn proposal_created_event(
        &self,
        #[indexed] proposal_id: &BigUint<Self::Api>,
        description: &ManagedBuffer<Self::Api>,
    );

    #[event("VoteCast")]
    fn vote_cast_event(
        &self,
        #[indexed] voter: &ManagedAddress<Self::Api>,
        #[indexed] proposal_id: &BigUint<Self::Api>,
    );

    #[event("VotingClosed")]
    fn voting_closed_event(
        &self,
        winning_proposal_id: &BigUint<Self::Api>,
        description: &ManagedBuffer<Self::Api>,
        vote_count: &BigUint<Self::Api>,
    );

    #[init]
    fn init(&self, duration_in_minutes: u64) {
        let caller = self.blockchain().get_caller();
        self.chairperson().set(caller);

        let current_timestamp = self.blockchain().get_block_timestamp();
        let minutes_in_seconds = duration_in_minutes * 60;
        self.voting_end().set(current_timestamp + minutes_in_seconds);

        self.voting_closed().set(false);
    }

    fn check_only_chairperson(&self) {
        let caller = self.blockchain().get_caller();
        let chairperson = self.chairperson().get();
        require!(caller == chairperson, "Only chairperson can call this function");
    }

    fn check_voting_open(&self) {
        let current_timestamp = self.blockchain().get_block_timestamp();
        let voting_end = self.voting_end().get();
        require!(current_timestamp < voting_end, "Voting has ended");

        let voting_closed = self.voting_closed().get();
        require!(!voting_closed, "Voting has been closed");
    }

    #[endpoint]
    fn add_proposal(&self, description: ManagedBuffer<Self::Api>) {
        self.check_only_chairperson();
        self.check_voting_open();

        let proposal = Proposal {
            description: description.clone(),
            vote_count: BigUint::zero(),
        };

        self.proposals().push(&proposal);
        
        let proposal_id = BigUint::from(self.proposals().len() - 1);
        self.proposal_created_event(&proposal_id, &description);
    }

    #[endpoint]
    fn vote(&self, proposal_id: BigUint<Self::Api>) {
        self.check_voting_open();

        let proposals_len = self.proposals().len();
        require!(proposal_id < BigUint::from(proposals_len), "Invalid proposal ID");

        let caller = self.blockchain().get_caller();
        let mut voter = self.voters(&caller).get();
        require!(!voter.has_voted, "Already voted");

        voter.has_voted = true;
        voter.voted_proposal_id = proposal_id.clone();
        self.voters(&caller).set(voter);

        let index = proposal_id.to_u64().unwrap_or_default() as usize;
        let mut proposal = self.proposals().get(index);
        proposal.vote_count += 1u32;
        self.proposals().set(index, &proposal);

        self.vote_cast_event(&caller, &proposal_id);
    }

    #[endpoint]
    fn close_voting(&self) {
        self.check_only_chairperson();

        let voting_closed = self.voting_closed().get();
        require!(!voting_closed, "Voting already closed");
        
        self.voting_closed().set(true);

        let winning_proposal_id = self.get_winning_proposal();
        let index = winning_proposal_id.to_u64().unwrap_or_default() as usize;
        let proposal = self.proposals().get(index);

        self.voting_closed_event(
            &winning_proposal_id,
            &proposal.description,
            &proposal.vote_count,
        );
    }

    #[view]
    fn get_winning_proposal(&self) -> BigUint<Self::Api> {
        let mut winning_proposal_id = BigUint::zero();
        let mut winning_vote_count = BigUint::zero();

        let proposals_len = self.proposals().len();
        for i in 0..proposals_len {
            let proposal = self.proposals().get(i);
            if proposal.vote_count > winning_vote_count {
                winning_vote_count = proposal.vote_count;
                winning_proposal_id = BigUint::from(i);
            }
        }

        winning_proposal_id
    }

    #[view]
    fn get_proposal_count(&self) -> usize {
        self.proposals().len()
    }

    #[view]
    fn get_proposal(&self, proposal_id: BigUint<Self::Api>) 
        -> MultiValue2<ManagedBuffer<Self::Api>, BigUint<Self::Api>> {
        
        let proposals_len = self.proposals().len();
        require!(
            proposal_id < BigUint::from(proposals_len),
            "Invalid proposal ID"
        );

        let index = proposal_id.to_u64().unwrap_or_default() as usize;
        let proposal = self.proposals().get(index);

        (proposal.description, proposal.vote_count).into()
    }

    #[view]
    fn get_voter_info(&self, voter_address: ManagedAddress<Self::Api>) 
        -> MultiValue2<bool, BigUint<Self::Api>> {
        
        let voter = self.voters(&voter_address).get();
        (voter.has_voted, voter.voted_proposal_id).into()
    }

    #[view]
    fn get_remaining_time(&self) -> u64 {
        let current_timestamp = self.blockchain().get_block_timestamp();
        let voting_end = self.voting_end().get();
        let voting_closed = self.voting_closed().get();

        if current_timestamp >= voting_end || voting_closed {
            return 0;
        }

        voting_end - current_timestamp
    }
} 