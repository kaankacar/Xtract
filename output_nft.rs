#![no_std]

use multiversx_sc::imports::*;
use multiversx_sc::derive_imports::*;

#[derive(TypeAbi, TopEncode, TopDecode, NestedEncode, NestedDecode, ManagedVecItem)]
pub struct NFT<M: ManagedTypeApi> {
    pub tokenId: BigUint<M>,
    pub owner: ManagedAddress<M>,
    pub price: BigUint<M>,
    pub forSale: bool
}
#[derive(TypeAbi, TopEncode, TopDecode, NestedEncode, NestedDecode, ManagedVecItem)]
pub struct Offer<M: ManagedTypeApi> {
    pub buyer: ManagedAddress<M>,
    pub tokenId: BigUint<M>,
    pub offerAmount: BigUint<M>,
    pub active: bool
}

#[multiversx_sc::contract]
pub trait NFTMarketplace {
    #[storage_mapper("tokenId")]
    fn token_id(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("owner")]
    fn owner(&self) -> SingleValueMapper<ManagedAddress<Self::Api>>;

    #[storage_mapper("price")]
    fn price(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("forSale")]
    fn for_sale(&self) -> SingleValueMapper<bool>;

    #[storage_mapper("buyer")]
    fn buyer(&self) -> SingleValueMapper<ManagedAddress<Self::Api>>;

    #[storage_mapper("tokenId")]
    fn token_id(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("offerAmount")]
    fn offer_amount(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("active")]
    fn active(&self) -> SingleValueMapper<bool>;

    #[storage_mapper("nextTokenId")]
    fn next_token_id(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[event("NFTCreated")]
    fn nft_created_event(&self, #[indexed] tokenId: BigUint<Self::Api>, #[indexed] owner: ManagedAddress<Self::Api>);

    #[event("NFTListed")]
    fn nft_listed_event(&self, #[indexed] tokenId: BigUint<Self::Api>, price: BigUint<Self::Api>);

    #[event("NFTSold")]
    fn nft_sold_event(&self, #[indexed] tokenId: BigUint<Self::Api>, #[indexed] from: ManagedAddress<Self::Api>, #[indexed] to: ManagedAddress<Self::Api>, price: BigUint<Self::Api>);

    #[event("OfferMade")]
    fn offer_made_event(&self, #[indexed] tokenId: BigUint<Self::Api>, #[indexed] buyer: ManagedAddress<Self::Api>, offerAmount: BigUint<Self::Api>);

    #[event("OfferAccepted")]
    fn offer_accepted_event(&self, #[indexed] tokenId: BigUint<Self::Api>, #[indexed] buyer: ManagedAddress<Self::Api>, offerAmount: BigUint<Self::Api>);

    #[init]
    fn init(&self) {}

    #[endpoint]
    fn create_nft(&self) -> BigUint<Self::Api> {
        // Function body would go here
    }

    #[endpoint]
    fn list_nft_for_sale(&self, tokenId: BigUint<Self::Api>, price: BigUint<Self::Api>) {
        // Function body would go here
    }

    #[endpoint]
    fn buy_nft(&self, tokenId: BigUint<Self::Api>) {
        // Function body would go here
    }

    #[endpoint]
    fn make_offer(&self, tokenId: BigUint<Self::Api>) {
        // Function body would go here
    }

    #[endpoint]
    fn accept_offer(&self, tokenId: BigUint<Self::Api>, offerIndex: BigUint<Self::Api>) {
        // Function body would go here
    }

    #[view(getOffersCount)]
    fn get_offers_count(&self, tokenId: BigUint<Self::Api>) -> BigUint<Self::Api> {
        // Function body would go here
    }

}