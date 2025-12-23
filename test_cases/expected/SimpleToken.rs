#![no_std]

use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait SimpleToken {
    #[storage_mapper("name")]
    fn name(&self) -> SingleValueMapper<ManagedBuffer<Self::Api>>;

    #[storage_mapper("symbol")]
    fn symbol(&self) -> SingleValueMapper<ManagedBuffer<Self::Api>>;

    #[storage_mapper("decimals")]
    fn decimals(&self) -> SingleValueMapper<u8>;

    #[storage_mapper("totalSupply")]
    fn total_supply(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("balanceOf")]
    fn balance_of(&self, key: &ManagedAddress<Self::Api>) -> SingleValueMapper<BigUint<Self::Api>>;

    #[event("Transfer")]
    fn transfer_event(&self, #[indexed] from: &ManagedAddress<Self::Api>, #[indexed] to: &ManagedAddress<Self::Api>, value: &BigUint<Self::Api>);

    #[init]
    fn init(&self) {
        self.name().set(&"SimpleToken");
        self.symbol().set(&"STK");
        self.decimals().set(&(BigUint::from(18u32)));
        self.total_supply().set(&(BigUint::from(1000000u32)));
    }

    #[endpoint]
    fn transfer(&self, to: ManagedAddress<Self::Api>, value: BigUint<Self::Api>) -> bool {
        require!(self.balance_of(&self.blockchain().get_caller()) >= self.value().get(), "Insufficient balance");
        require!(to != address(BigUint::from(0u32), "Requirement not met");
        self.transfer_event(&self.blockchain().get_caller(), &to, &self.value().get());
        return true;
    }

    #[view(getBalance)]
    fn get_balance(&self, account: ManagedAddress<Self::Api>) -> BigUint<Self::Api> {
        return self.balance_of(&account);
    }

}