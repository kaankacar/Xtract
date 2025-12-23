#![no_std]

use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait TokenMinter {
    #[storage_mapper("owner")]
    fn owner(&self) -> SingleValueMapper<ManagedAddress<Self::Api>>;

    #[storage_mapper("name")]
    fn name(&self) -> SingleValueMapper<ManagedBuffer<Self::Api>>;

    #[storage_mapper("symbol")]
    fn symbol(&self) -> SingleValueMapper<ManagedBuffer<Self::Api>>;

    #[storage_mapper("totalSupply")]
    fn total_supply(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("balances")]
    fn balances(&self, key: &ManagedAddress<Self::Api>) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("minters")]
    fn minters(&self, key: &ManagedAddress<Self::Api>) -> SingleValueMapper<bool>;

    #[event("Transfer")]
    fn transfer_event(&self, #[indexed] from: &ManagedAddress<Self::Api>, #[indexed] to: &ManagedAddress<Self::Api>, value: &BigUint<Self::Api>);

    #[event("Minted")]
    fn minted_event(&self, #[indexed] to: &ManagedAddress<Self::Api>, amount: &BigUint<Self::Api>);

    #[event("Burned")]
    fn burned_event(&self, #[indexed] from: &ManagedAddress<Self::Api>, amount: &BigUint<Self::Api>);

    #[event("MinterAdded")]
    fn minter_added_event(&self, #[indexed] minter: &ManagedAddress<Self::Api>);

    #[event("MinterRemoved")]
    fn minter_removed_event(&self, #[indexed] minter: &ManagedAddress<Self::Api>);

    #[init]
    fn init(&self) {
        owner = self.blockchain().get_caller();
        self.name().set(&"MintableToken");
        self.symbol().set(&"MTK");
        self.total_supply().set(&(BigUint::from(0u32)));
    }

    #[endpoint]
    fn mint(&self, to: ManagedAddress<Self::Api>, amount: BigUint<Self::Api>) {
        require!(self.minters(&self.blockchain().get_caller()), "Not minter");
        require!(to != address(BigUint::from(0u32), "Requirement not met");
        self.total_supply().set(&(self.total_supply().get() + amount.clone()));
        self.minted_event(&to, &amount.clone());
    }

    #[endpoint]
    fn burn(&self, amount: BigUint<Self::Api>) {
        require!(self.balances(&self.blockchain().get_caller()) >= amount, "Insufficient balance");
        self.total_supply().set(&(self.total_supply().get() - amount.clone()));
        self.burned_event(&self.blockchain().get_caller(), &amount.clone());
    }

    #[endpoint]
    fn add_minter(&self, minter: ManagedAddress<Self::Api>) {
        require!(self.blockchain().get_caller() == owner, "Not owner");
        self.minter_added_event(&minter);
    }

    #[endpoint]
    fn remove_minter(&self, minter: ManagedAddress<Self::Api>) {
        require!(self.blockchain().get_caller() == owner, "Not owner");
        self.minter_removed_event(&minter);
    }

    #[view(balanceOf)]
    fn balance_of(&self, account: ManagedAddress<Self::Api>) -> BigUint<Self::Api> {
        return self.balances(&account);
    }

}