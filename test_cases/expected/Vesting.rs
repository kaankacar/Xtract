#![no_std]

use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait Vesting {
    #[storage_mapper("beneficiary")]
    fn beneficiary(&self) -> SingleValueMapper<ManagedAddress<Self::Api>>;

    #[storage_mapper("startTime")]
    fn start_time(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("duration")]
    fn duration(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("totalAmount")]
    fn total_amount(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("released")]
    fn released(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[event("TokensReleased")]
    fn tokens_released_event(&self, #[indexed] beneficiary: &ManagedAddress<Self::Api>, amount: &BigUint<Self::Api>);

    #[event("VestingScheduleCreated")]
    fn vesting_schedule_created_event(&self, #[indexed] beneficiary: &ManagedAddress<Self::Api>, amount: &BigUint<Self::Api>, #[indexed] duration: &BigUint<Self::Api>);

    #[init]
    fn init(&self) {
        beneficiary = self.blockchain().get_caller();
        released = BigUint::from(0u32);
    }

    #[endpoint]
    fn create_schedule(&self, _beneficiary: ManagedAddress<Self::Api>, _amount: BigUint<Self::Api>, _duration: BigUint<Self::Api>) {
        require!(_beneficiary != address(BigUint::from(0u32), "Requirement not met");
        require!(_amount > BigUint::from(0u32), "Invalid amount");
        require!(_duration > BigUint::from(0u32), "Invalid duration");
        beneficiary = _beneficiary;
        totalAmount = _amount;
        duration = _duration;
        startTime = self.blockchain().get_block_timestamp();
        self.vesting_schedule_created_event(&_beneficiary, &_amount.clone(), &_duration);
    }

    #[endpoint]
    fn release(&self) {
        require!(self.blockchain().get_caller() == beneficiary, "Not beneficiary");
        let mut releasable: BigUint<Self::Api> = totalAmount - released;
        require!(releasable > BigUint::from(0u32), "Nothing to release");
        released = released + releasable;
        self.tokens_released_event(&beneficiary, &releasable);
    }

    #[view(getVestedAmount)]
    fn get_vested_amount(&self) -> BigUint<Self::Api> {
        return released;
    }

    #[view(getRemainingAmount)]
    fn get_remaining_amount(&self) -> BigUint<Self::Api> {
        return totalAmount - released;
    }

}