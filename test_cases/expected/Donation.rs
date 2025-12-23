#![no_std]

use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait Donation {
    #[storage_mapper("owner")]
    fn owner(&self) -> SingleValueMapper<ManagedAddress<Self::Api>>;

    #[storage_mapper("beneficiary")]
    fn beneficiary(&self) -> SingleValueMapper<ManagedAddress<Self::Api>>;

    #[storage_mapper("totalDonations")]
    fn total_donations(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("donations")]
    fn donations(&self, key: &ManagedAddress<Self::Api>) -> SingleValueMapper<BigUint<Self::Api>>;

    #[event("DonationReceived")]
    fn donation_received_event(&self, #[indexed] donor: &ManagedAddress<Self::Api>, amount: &BigUint<Self::Api>);

    #[event("Withdrawn")]
    fn withdrawn_event(&self, #[indexed] beneficiary: &ManagedAddress<Self::Api>, amount: &BigUint<Self::Api>);

    #[event("BeneficiaryChanged")]
    fn beneficiary_changed_event(&self, #[indexed] oldBeneficiary: &ManagedAddress<Self::Api>, #[indexed] newBeneficiary: &ManagedAddress<Self::Api>);

    #[init]
    fn init(&self) {
        owner = self.blockchain().get_caller();
        beneficiary = self.blockchain().get_caller();
        totalDonations = BigUint::from(0u32);
    }

    #[endpoint]
    fn donate(&self, amount: BigUint<Self::Api>) {
        require!(amount > BigUint::from(0u32), "Invalid amount");
        totalDonations = totalDonations + amount.clone();
        self.donation_received_event(&self.blockchain().get_caller(), &amount.clone());
    }

    #[endpoint]
    fn withdraw(&self, amount: BigUint<Self::Api>) {
        require!(self.blockchain().get_caller() == owner, "Not owner");
        require!(amount <= totalDonations, "Insufficient funds");
        totalDonations = totalDonations - amount.clone();
        self.withdrawn_event(&beneficiary, &amount.clone());
    }

    #[endpoint]
    fn set_beneficiary(&self, newBeneficiary: ManagedAddress<Self::Api>) {
        require!(self.blockchain().get_caller() == owner, "Not owner");
        require!(newBeneficiary != address(BigUint::from(0u32), "Requirement not met");
        self.beneficiary_changed_event(&beneficiary, &newBeneficiary);
        beneficiary = newBeneficiary;
    }

    #[view(getDonation)]
    fn get_donation(&self, donor: ManagedAddress<Self::Api>) -> BigUint<Self::Api> {
        return self.donations(&donor);
    }

}