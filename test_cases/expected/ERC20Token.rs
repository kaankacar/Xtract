#![no_std]

use multiversx_sc::imports::*;
use multiversx_sc::derive_imports::*;

#[multiversx_sc::contract]
pub trait ERC20Token {
    #[storage_mapper("name")]
    fn name(&self) -> SingleValueMapper<ManagedBuffer<Self::Api>>;

    #[storage_mapper("symbol")]
    fn symbol(&self) -> SingleValueMapper<ManagedBuffer<Self::Api>>;

    #[storage_mapper("decimals")]
    fn decimals(&self) -> SingleValueMapper<u8>;

    #[storage_mapper("totalSupply")]
    fn total_supply(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("balanceOf")]
    fn balance_of(&self, address: &ManagedAddress<Self::Api>) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("allowance")]
    fn allowance(&self, owner: &ManagedAddress<Self::Api>, spender: &ManagedAddress<Self::Api>) -> 
        SingleValueMapper<BigUint<Self::Api>>;

    #[event("Transfer")]
    fn transfer_event(
        &self,
        #[indexed] from: &ManagedAddress<Self::Api>,
        #[indexed] to: &ManagedAddress<Self::Api>,
        value: &BigUint<Self::Api>,
    );

    #[event("Approval")]
    fn approval_event(
        &self,
        #[indexed] owner: &ManagedAddress<Self::Api>,
        #[indexed] spender: &ManagedAddress<Self::Api>,
        value: &BigUint<Self::Api>,
    );

    #[init]
    fn init(
        &self,
        name: ManagedBuffer<Self::Api>,
        symbol: ManagedBuffer<Self::Api>,
        decimals: u8,
        initial_supply: BigUint<Self::Api>,
    ) {
        self.name().set(name);
        self.symbol().set(symbol);
        self.decimals().set(decimals);
        
        let power = BigUint::from(10u32).pow(decimals.into());
        let total_supply = initial_supply * power;
        self.total_supply().set(&total_supply);
        
        let caller = self.blockchain().get_caller();
        self.balance_of(&caller).set(&total_supply);
        
        // Zero address in MultiversX
        let zero_address = ManagedAddress::zero();
        self.transfer_event(&zero_address, &caller, &total_supply);
    }

    #[endpoint]
    fn transfer(&self, to: ManagedAddress<Self::Api>, value: BigUint<Self::Api>) -> bool {
        let caller = self.blockchain().get_caller();
        let caller_balance = self.balance_of(&caller).get();
        
        require!(caller_balance >= value, "Insufficient balance");
        
        self.balance_of(&caller).set(&(caller_balance - &value));
        
        let receiver_balance = self.balance_of(&to).get();
        self.balance_of(&to).set(&(receiver_balance + &value));
        
        self.transfer_event(&caller, &to, &value);
        
        true
    }
    
    #[endpoint]
    fn approve(&self, spender: ManagedAddress<Self::Api>, value: BigUint<Self::Api>) -> bool {
        let caller = self.blockchain().get_caller();
        self.allowance(&caller, &spender).set(&value);
        self.approval_event(&caller, &spender, &value);
        true
    }
    
    #[endpoint]
    fn transfer_from(
        &self,
        from: ManagedAddress<Self::Api>,
        to: ManagedAddress<Self::Api>,
        value: BigUint<Self::Api>,
    ) -> bool {
        let caller = self.blockchain().get_caller();
        let from_balance = self.balance_of(&from).get();
        let caller_allowance = self.allowance(&from, &caller).get();
        
        require!(from_balance >= value, "Insufficient balance");
        require!(caller_allowance >= value, "Insufficient allowance");
        
        self.balance_of(&from).set(&(from_balance - &value));
        
        let to_balance = self.balance_of(&to).get();
        self.balance_of(&to).set(&(to_balance + &value));
        
        self.allowance(&from, &caller).set(&(caller_allowance - &value));
        
        self.transfer_event(&from, &to, &value);
        true
    }
} 