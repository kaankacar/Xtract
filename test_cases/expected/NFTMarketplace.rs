#![no_std]

use multiversx_sc::imports::*;
use multiversx_sc::derive_imports::*;

#[derive(TypeAbi, TopEncode, TopDecode, NestedEncode, NestedDecode, ManagedVecItem)]
pub struct NFT<M: ManagedTypeApi> {
    pub token_id: BigUint<M>,
    pub owner: ManagedAddress<M>,
    pub price: BigUint<M>,
    pub for_sale: bool,
}

#[derive(TypeAbi, TopEncode, TopDecode, NestedEncode, NestedDecode, ManagedVecItem)]
pub struct Offer<M: ManagedTypeApi> {
    pub buyer: ManagedAddress<M>,
    pub token_id: BigUint<M>,
    pub offer_amount: BigUint<M>,
    pub active: bool,
}

#[derive(TopEncode, TopDecode, TypeAbi)]
pub struct NotOwnerError<M: ManagedTypeApi> {
    pub token_id: BigUint<M>,
    pub caller: ManagedAddress<M>,
    pub owner: ManagedAddress<M>,
}

#[derive(TopEncode, TopDecode, TypeAbi)]
pub struct NotForSaleError<M: ManagedTypeApi> {
    pub token_id: BigUint<M>,
}

#[derive(TopEncode, TopDecode, TypeAbi)]
pub struct InsufficientFundsError<M: ManagedTypeApi> {
    pub required: BigUint<M>,
    pub provided: BigUint<M>,
}

#[derive(TopEncode, TopDecode, TypeAbi)]
pub struct InvalidTokenIdError<M: ManagedTypeApi> {
    pub token_id: BigUint<M>,
}

#[multiversx_sc::contract]
pub trait NFTMarketplace {
    #[storage_mapper("nfts")]
    fn nfts(&self, token_id: &BigUint<Self::Api>) -> SingleValueMapper<NFT<Self::Api>>;

    #[storage_mapper("offersForNFT")]
    fn offers_for_nft(&self, token_id: &BigUint<Self::Api>) -> VecMapper<Self::Api, Offer<Self::Api>>;

    #[storage_mapper("nextTokenId")]
    fn next_token_id(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[event("NFTCreated")]
    fn nft_created_event(
        &self,
        #[indexed] token_id: &BigUint<Self::Api>,
        #[indexed] owner: &ManagedAddress<Self::Api>,
    );

    #[event("NFTListed")]
    fn nft_listed_event(
        &self,
        #[indexed] token_id: &BigUint<Self::Api>,
        price: &BigUint<Self::Api>,
    );

    #[event("NFTSold")]
    fn nft_sold_event(
        &self,
        #[indexed] token_id: &BigUint<Self::Api>,
        #[indexed] from: &ManagedAddress<Self::Api>,
        #[indexed] to: &ManagedAddress<Self::Api>,
        price: &BigUint<Self::Api>,
    );

    #[event("OfferMade")]
    fn offer_made_event(
        &self,
        #[indexed] token_id: &BigUint<Self::Api>,
        #[indexed] buyer: &ManagedAddress<Self::Api>,
        offer_amount: &BigUint<Self::Api>,
    );

    #[event("OfferAccepted")]
    fn offer_accepted_event(
        &self,
        #[indexed] token_id: &BigUint<Self::Api>,
        #[indexed] buyer: &ManagedAddress<Self::Api>,
        offer_amount: &BigUint<Self::Api>,
    );

    #[init]
    fn init(&self) {
        self.next_token_id().set(BigUint::zero());
    }

    // Only owner validation
    fn check_only_owner(&self, token_id: &BigUint<Self::Api>) -> Result<(), SCError> {
        let nft = self.nfts(token_id).get();
        let caller = self.blockchain().get_caller();
        
        if nft.owner != caller {
            return Err(SCError::from("NotOwner"));
        }
        
        Ok(())
    }

    #[endpoint]
    fn create_nft(&self) -> BigUint<Self::Api> {
        let token_id = self.next_token_id().get();
        let caller = self.blockchain().get_caller();
        
        let nft = NFT {
            token_id: token_id.clone(),
            owner: caller.clone(),
            price: BigUint::zero(),
            for_sale: false,
        };
        
        self.nfts(&token_id).set(nft);
        self.next_token_id().set(token_id.clone() + 1u32);
        
        self.nft_created_event(&token_id, &caller);
        
        token_id
    }

    #[endpoint]
    fn list_nft_for_sale(&self, token_id: BigUint<Self::Api>, price: BigUint<Self::Api>) {
        self.check_only_owner(&token_id).unwrap_or_else(|_| sc_panic!("Not the owner"));
        
        let mut nft = self.nfts(&token_id).get();
        nft.price = price.clone();
        nft.for_sale = true;
        
        self.nfts(&token_id).set(nft);
        
        self.nft_listed_event(&token_id, &price);
    }

    #[payable("EGLD")]
    #[endpoint]
    fn buy_nft(&self, token_id: BigUint<Self::Api>) {
        let payment = self.call_value().egld_value();
        let mut nft = self.nfts(&token_id).get();
        
        if !nft.for_sale {
            sc_panic!("NFT is not for sale");
        }
        
        if payment < nft.price {
            sc_panic!("Insufficient funds");
        }
        
        let previous_owner = nft.owner.clone();
        let caller = self.blockchain().get_caller();
        
        nft.owner = caller.clone();
        nft.for_sale = false;
        
        self.nfts(&token_id).set(nft);
        
        // Send payment to previous owner
        self.send().direct_egld(&previous_owner, &payment);
        
        self.nft_sold_event(&token_id, &previous_owner, &caller, &payment);
    }

    #[payable("EGLD")]
    #[endpoint]
    fn make_offer(&self, token_id: BigUint<Self::Api>) {
        let payment = self.call_value().egld_value();
        let next_token_id = self.next_token_id().get();
        
        if token_id >= next_token_id {
            sc_panic!("Invalid token ID");
        }
        
        let caller = self.blockchain().get_caller();
        
        let offer = Offer {
            buyer: caller.clone(),
            token_id: token_id.clone(),
            offer_amount: payment.clone(),
            active: true,
        };
        
        self.offers_for_nft(&token_id).push(&offer);
        
        self.offer_made_event(&token_id, &caller, &payment);
    }

    #[endpoint]
    fn accept_offer(&self, token_id: BigUint<Self::Api>, offer_index: usize) {
        self.check_only_owner(&token_id).unwrap_or_else(|_| sc_panic!("Not the owner"));
        
        let offers_len = self.offers_for_nft(&token_id).len();
        require!(offer_index < offers_len, "Invalid offer index");
        
        let mut offer = self.offers_for_nft(&token_id).get(offer_index);
        require!(offer.active, "Offer is not active");
        
        offer.active = false;
        self.offers_for_nft(&token_id).set(offer_index, &offer);
        
        // Update NFT ownership
        let mut nft = self.nfts(&token_id).get();
        let previous_owner = nft.owner.clone();
        nft.owner = offer.buyer.clone();
        nft.for_sale = false;
        
        self.nfts(&token_id).set(nft);
        
        // Transfer payment to seller
        self.send().direct_egld(&previous_owner, &offer.offer_amount);
        
        self.offer_accepted_event(&token_id, &offer.buyer, &offer.offer_amount);
        self.nft_sold_event(&token_id, &previous_owner, &offer.buyer, &offer.offer_amount);
    }

    #[view]
    fn get_offers_count(&self, token_id: BigUint<Self::Api>) -> usize {
        self.offers_for_nft(&token_id).len()
    }
} 