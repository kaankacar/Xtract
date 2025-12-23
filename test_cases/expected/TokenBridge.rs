#![no_std]

use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait TokenBridge {
    #[storage_mapper("owner")]
    fn owner(&self) -> SingleValueMapper<ManagedAddress<Self::Api>>;

    #[storage_mapper("bridgeFee")]
    fn bridge_fee(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("totalBridged")]
    fn total_bridged(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("bridgedAmount")]
    fn bridged_amount(&self, key: &ManagedAddress<Self::Api>) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("processedNonces")]
    fn processed_nonces(&self, key: &BigUint<Self::Api>) -> SingleValueMapper<bool>;

    #[event("BridgeInitiated")]
    fn bridge_initiated_event(&self, #[indexed] user: &ManagedAddress<Self::Api>, amount: &BigUint<Self::Api>, #[indexed] nonce: &BigUint<Self::Api>);

    #[event("BridgeCompleted")]
    fn bridge_completed_event(&self, #[indexed] user: &ManagedAddress<Self::Api>, amount: &BigUint<Self::Api>, #[indexed] nonce: &BigUint<Self::Api>);

    #[event("FeeUpdated")]
    fn fee_updated_event(&self, #[indexed] oldFee: &BigUint<Self::Api>, #[indexed] newFee: &BigUint<Self::Api>);

    #[init]
    fn init(&self) {
        owner = self.blockchain().get_caller();
        bridgeFee = BigUint::from(10u32);
        totalBridged = BigUint::from(0u32);
    }

    #[endpoint]
    fn initiate_bridge(&self, amount: BigUint<Self::Api>, nonce: BigUint<Self::Api>) {
        require!(amount > bridgeFee, "Amount too small");
        require!(!self.processedNonces(&nonce), "Nonce already used");
        totalBridged = totalBridged + amount.clone();
        self.bridge_initiated_event(&self.blockchain().get_caller(), &amount.clone(), &nonce);
    }

    #[endpoint]
    fn complete_bridge(&self, user: ManagedAddress<Self::Api>, amount: BigUint<Self::Api>, nonce: BigUint<Self::Api>) {
        require!(self.blockchain().get_caller() == owner, "Not owner");
        self.bridge_completed_event(&user, &amount.clone(), &nonce);
    }

    #[endpoint]
    fn set_fee(&self, newFee: BigUint<Self::Api>) {
        require!(self.blockchain().get_caller() == owner, "Not owner");
        self.fee_updated_event(&bridgeFee, &newFee);
        bridgeFee = newFee;
    }

    #[view(getBridgedAmount)]
    fn get_bridged_amount(&self, user: ManagedAddress<Self::Api>) -> BigUint<Self::Api> {
        return self.bridgedAmount(&user);
    }

}