#![no_std]

use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait Vault {
    #[storage_mapper("guardian")]
    fn guardian(&self) -> SingleValueMapper<ManagedAddress<Self::Api>>;

    #[storage_mapper("withdrawalDelay")]
    fn withdrawal_delay(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("balances")]
    fn balances(&self, key: &ManagedAddress<Self::Api>) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("pendingWithdrawals")]
    fn pending_withdrawals(&self, key: &ManagedAddress<Self::Api>) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("withdrawalTime")]
    fn withdrawal_time(&self, key: &ManagedAddress<Self::Api>) -> SingleValueMapper<BigUint<Self::Api>>;

    #[event("Deposited")]
    fn deposited_event(&self, #[indexed] user: &ManagedAddress<Self::Api>, amount: &BigUint<Self::Api>);

    #[event("WithdrawalRequested")]
    fn withdrawal_requested_event(&self, #[indexed] user: &ManagedAddress<Self::Api>, amount: &BigUint<Self::Api>, #[indexed] unlockTime: &BigUint<Self::Api>);

    #[event("WithdrawalCompleted")]
    fn withdrawal_completed_event(&self, #[indexed] user: &ManagedAddress<Self::Api>, amount: &BigUint<Self::Api>);

    #[event("WithdrawalCancelled")]
    fn withdrawal_cancelled_event(&self, #[indexed] user: &ManagedAddress<Self::Api>);

    #[init]
    fn init(&self) {
        guardian = self.blockchain().get_caller();
        withdrawalDelay = BigUint::from(86400u32);
    }

    #[endpoint]
    fn deposit(&self, amount: BigUint<Self::Api>) {
        require!(amount > BigUint::from(0u32), "Invalid amount");
        self.deposited_event(&self.blockchain().get_caller(), &amount.clone());
    }

    #[endpoint]
    fn request_withdrawal(&self, amount: BigUint<Self::Api>) {
        require!(self.balances(&self.blockchain().get_caller()) >= amount, "Insufficient balance");
        self.withdrawal_requested_event(&self.blockchain().get_caller(), &amount.clone(), &self.withdrawalTime(&self.blockchain().get_caller()));
    }

    #[endpoint]
    fn complete_withdrawal(&self) {
        require!(self.pendingWithdrawals(&self.blockchain().get_caller()) > BigUint::from(0u32), "No pending withdrawal");
        require!(self.blockchain().get_block_timestamp() >= self.withdrawalTime(&self.blockchain().get_caller()), "Delay not passed");
        uint256 amount = self.pendingWithdrawals(&self.blockchain().get_caller());
        self.withdrawal_completed_event(&self.blockchain().get_caller(), &amount.clone());
    }

    #[endpoint]
    fn cancel_withdrawal(&self) {
        require!(self.pendingWithdrawals(&self.blockchain().get_caller()) > BigUint::from(0u32), "No pending withdrawal");
        uint256 amount = self.pendingWithdrawals(&self.blockchain().get_caller());
        self.withdrawal_cancelled_event(&self.blockchain().get_caller());
    }

}