#![no_std]

use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait Auction {
    #[storage_mapper("owner")]
    fn owner(&self) -> SingleValueMapper<ManagedAddress<Self::Api>>;

    #[storage_mapper("highestBidder")]
    fn highest_bidder(&self) -> SingleValueMapper<ManagedAddress<Self::Api>>;

    #[storage_mapper("highestBid")]
    fn highest_bid(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("auctionEndTime")]
    fn auction_end_time(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("ended")]
    fn ended(&self) -> SingleValueMapper<bool>;

    #[event("BidPlaced")]
    fn bid_placed_event(&self, #[indexed] bidder: &ManagedAddress<Self::Api>, amount: &BigUint<Self::Api>);

    #[event("AuctionEnded")]
    fn auction_ended_event(&self, #[indexed] winner: &ManagedAddress<Self::Api>, amount: &BigUint<Self::Api>);

    #[init]
    fn init(&self) {
        owner = self.blockchain().get_caller();
        highestBid = BigUint::from(0u32);
        ended = false;
    }

    #[endpoint]
    fn start_auction(&self, duration: BigUint<Self::Api>) {
        require!(self.blockchain().get_caller() == owner, "Not owner");
        require!(!ended, "Auction ended");
        auctionEndTime = self.blockchain().get_block_timestamp() + duration;
    }

    #[endpoint]
    fn bid(&self, amount: BigUint<Self::Api>) {
        require!(!ended, "Auction ended");
        require!(amount > highestBid, "Bid too low");
        highestBidder = self.blockchain().get_caller();
        highestBid = amount;
        self.bid_placed_event(&self.blockchain().get_caller(), &amount.clone());
    }

    #[endpoint]
    fn end_auction(&self) {
        require!(self.blockchain().get_caller() == owner, "Not owner");
        require!(!ended, "Already ended");
        ended = true;
        self.auction_ended_event(&highestBidder, &highestBid);
    }

    #[view(getHighestBid)]
    fn get_highest_bid(&self) -> BigUint<Self::Api> {
        return highestBid;
    }

}