#![no_std]

use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait Deposit {
    #[storage_mapper("owner")]
    fn owner(&self) -> SingleValueMapper<ManagedAddress<Self::Api>>;

    #[storage_mapper("minDeposit")]
    fn min_deposit(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("maxDeposit")]
    fn max_deposit(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("totalDeposits")]
    fn total_deposits(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("userDeposits")]
    fn user_deposits(&self, key: &ManagedAddress<Self::Api>) -> SingleValueMapper<BigUint<Self::Api>>;

    #[event("DepositMade")]
    fn deposit_made_event(&self, #[indexed] user: &ManagedAddress<Self::Api>, amount: &BigUint<Self::Api>);

    #[event("WithdrawalMade")]
    fn withdrawal_made_event(&self, #[indexed] user: &ManagedAddress<Self::Api>, amount: &BigUint<Self::Api>);

    #[event("LimitsUpdated")]
    fn limits_updated_event(&self, minDeposit: &BigUint<Self::Api>, #[indexed] maxDeposit: &BigUint<Self::Api>);

    #[init]
    fn init(&self) {
        owner = self.blockchain().get_caller();
        minDeposit = BigUint::from(100u32);
        maxDeposit = BigUint::from(10000u32);
        totalDeposits = BigUint::from(0u32);
    }

    #[endpoint]
    fn deposit(&self, amount: BigUint<Self::Api>) {
        require!(amount >= minDeposit, "Below minimum");
        require!(amount <= maxDeposit, "Above maximum");
        totalDeposits = totalDeposits + amount.clone();
        self.deposit_made_event(&self.blockchain().get_caller(), &amount.clone());
    }

    #[endpoint]
    fn withdraw(&self, amount: BigUint<Self::Api>) {
        require!(self.userDeposits(&self.blockchain().get_caller()) >= amount, "Insufficient balance");
        totalDeposits = totalDeposits - amount.clone();
        self.withdrawal_made_event(&self.blockchain().get_caller(), &amount.clone());
    }

    #[endpoint]
    fn set_limits(&self, newMin: BigUint<Self::Api>, newMax: BigUint<Self::Api>) {
        require!(self.blockchain().get_caller() == owner, "Not owner");
        require!(newMin <= newMax, "Invalid limits");
        minDeposit = newMin;
        maxDeposit = newMax;
        self.limits_updated_event(&newMin, &newMax);
    }

    #[view(getDeposit)]
    fn get_deposit(&self, user: ManagedAddress<Self::Api>) -> BigUint<Self::Api> {
        return self.userDeposits(&user);
    }

}