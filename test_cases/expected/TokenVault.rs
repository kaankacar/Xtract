#![no_std]

use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait TokenVault {
    #[storage_mapper("totalDeposited")]
    fn total_deposited(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("balances")]
    fn balances(&self, key: &ManagedAddress<Self::Api>) -> SingleValueMapper<BigUint<Self::Api>>;

    #[event("Deposit")]
    fn deposit_event(&self, #[indexed] user: &ManagedAddress<Self::Api>, amount: &BigUint<Self::Api>);

    #[event("Withdrawal")]
    fn withdrawal_event(&self, #[indexed] user: &ManagedAddress<Self::Api>, amount: &BigUint<Self::Api>);

    #[init]
    fn init(&self) {}

    #[endpoint]
    fn deposit(&self, amount: BigUint<Self::Api>) {
        require!(amount > BigUint::from(0u32), "Amount must be positive");
        totalDeposited = totalDeposited + amount.clone();
        self.deposit_event(&self.blockchain().get_caller(), &amount.clone());
    }

    #[endpoint]
    fn withdraw(&self, amount: BigUint<Self::Api>) {
        require!(self.balances(&self.blockchain().get_caller()) >= amount, "Insufficient balance");
        totalDeposited = totalDeposited - amount.clone();
        self.withdrawal_event(&self.blockchain().get_caller(), &amount.clone());
    }

    #[view(getBalance)]
    fn get_balance(&self, user: ManagedAddress<Self::Api>) -> BigUint<Self::Api> {
        return self.balances(&user);
    }

}