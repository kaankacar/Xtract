#![no_std]

use multiversx_sc::imports::*;
use multiversx_sc::derive_imports::*;

#[derive(TypeAbi, TopEncode, TopDecode, NestedEncode, NestedDecode, ManagedVecItem)]
pub struct Proposal<M: ManagedTypeApi> {
    pub description: ManagedBuffer<M>,
    pub voteCount: BigUint<M>
}
#[derive(TypeAbi, TopEncode, TopDecode, NestedEncode, NestedDecode, ManagedVecItem)]
pub struct Voter<M: ManagedTypeApi> {
    pub hasVoted: bool,
    pub votedProposalId: BigUint<M>
}

#[multiversx_sc::contract]
pub trait Voting {
    #[storage_mapper("description")]
    fn description(&self) -> SingleValueMapper<ManagedBuffer<Self::Api>>;

    #[storage_mapper("voteCount")]
    fn vote_count(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("hasVoted")]
    fn has_voted(&self) -> SingleValueMapper<bool>;

    #[storage_mapper("votedProposalId")]
    fn voted_proposal_id(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("chairperson")]
    fn chairperson(&self) -> SingleValueMapper<ManagedAddress<Self::Api>>;

    #[storage_mapper("votingEnd")]
    fn voting_end(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("votingClosed")]
    fn voting_closed(&self) -> SingleValueMapper<bool>;

    #[event("ProposalCreated")]
    fn proposal_created_event(&self, #[indexed] proposalId: BigUint<Self::Api>, description: ManagedBuffer<Self::Api>);

    #[event("VoteCast")]
    fn vote_cast_event(&self, #[indexed] voter: ManagedAddress<Self::Api>, #[indexed] proposalId: BigUint<Self::Api>);

    #[event("VotingClosed")]
    fn voting_closed_event(&self, winningProposalId: BigUint<Self::Api>, description: ManagedBuffer<Self::Api>, voteCount: BigUint<Self::Api>);

    #[init]
    fn init(&self) {}

    #[endpoint]
    fn add_proposal(&self, memory: ManagedBuffer<Self::Api>) {
        // Function body would go here
    }

    #[endpoint]
    fn vote(&self, proposalId: BigUint<Self::Api>) {
        // Function body would go here
    }

    #[endpoint]
    fn close_voting(&self) {
        // Function body would go here
    }

    #[view(getWinningProposal)]
    fn get_winning_proposal(&self) -> BigUint<Self::Api> {
        // Function body would go here
    }

    #[view(getProposalCount)]
    fn get_proposal_count(&self) -> BigUint<Self::Api> {
        // Function body would go here
    }

    #[view(getProposal)]
    fn get_proposal(&self, proposalId: BigUint<Self::Api>) -> ManagedBuffer<Self::Api> {
        // Function body would go here
    }

    #[view(getVoterInfo)]
    fn get_voter_info(&self, voterAddress: ManagedAddress<Self::Api>) -> bool {
        // Function body would go here
    }

    #[view(getRemainingTime)]
    fn get_remaining_time(&self) -> BigUint<Self::Api> {
        // Function body would go here
    }

}