#![no_std]

use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait FeeCollector {
    #[storage_mapper("owner")]
    fn owner(&self) -> SingleValueMapper<ManagedAddress<Self::Api>>;

    #[storage_mapper("treasury")]
    fn treasury(&self) -> SingleValueMapper<ManagedAddress<Self::Api>>;

    #[storage_mapper("feePercent")]
    fn fee_percent(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("totalCollected")]
    fn total_collected(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[event("FeeCollected")]
    fn fee_collected_event(&self, #[indexed] from: &ManagedAddress<Self::Api>, amount: &BigUint<Self::Api>, #[indexed] fee: &BigUint<Self::Api>);

    #[event("FeePercentChanged")]
    fn fee_percent_changed_event(&self, #[indexed] oldPercent: &BigUint<Self::Api>, #[indexed] newPercent: &BigUint<Self::Api>);

    #[event("TreasuryChanged")]
    fn treasury_changed_event(&self, #[indexed] oldTreasury: &ManagedAddress<Self::Api>, #[indexed] newTreasury: &ManagedAddress<Self::Api>);

    #[init]
    fn init(&self) {
        owner = self.blockchain().get_caller();
        treasury = self.blockchain().get_caller();
        feePercent = BigUint::from(100u32);
    }

    #[endpoint]
    fn collect_fee(&self, amount: BigUint<Self::Api>) {
        require!(amount > BigUint::from(0u32), "Invalid amount");
        let mut fee: BigUint<Self::Api> = amount * self.fee_percent().get() / BigUint::from(10000u32);
        totalCollected = totalCollected + self.fee().get();
        self.fee_collected_event(&self.blockchain().get_caller(), &amount.clone(), &self.fee().get());
    }

    #[endpoint]
    fn set_fee_percent(&self, newPercent: BigUint<Self::Api>) {
        require!(self.blockchain().get_caller() == owner, "Not owner");
        require!(newPercent <= BigUint::from(1000u32), "Fee too high");
        self.fee_percent_changed_event(&self.fee_percent().get(), &newPercent);
        feePercent = newPercent;
    }

    #[endpoint]
    fn set_treasury(&self, newTreasury: ManagedAddress<Self::Api>) {
        require!(self.blockchain().get_caller() == owner, "Not owner");
        require!(newTreasury != address(BigUint::from(0u32), "Requirement not met");
        self.treasury_changed_event(&self.treasury().get(), &newTreasury);
        treasury = newTreasury;
    }

}