#![no_std]

use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait Timer {
    #[storage_mapper("owner")]
    fn owner(&self) -> SingleValueMapper<ManagedAddress<Self::Api>>;

    #[storage_mapper("startTime")]
    fn start_time(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("duration")]
    fn duration(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("active")]
    fn active(&self) -> SingleValueMapper<bool>;

    #[event("TimerStarted")]
    fn timer_started_event(&self, startTime: &BigUint<Self::Api>, #[indexed] duration: &BigUint<Self::Api>);

    #[event("TimerStopped")]
    fn timer_stopped_event(&self, timestamp: &BigUint<Self::Api>);

    #[event("TimerReset")]
    fn timer_reset_event(&self);

    #[init]
    fn init(&self) {
        owner = self.blockchain().get_caller();
        active = false;
    }

    #[endpoint]
    fn start(&self, _duration: BigUint<Self::Api>) {
        require!(self.blockchain().get_caller() == owner, "Not owner");
        require!(!active, "Already active");
        startTime = self.blockchain().get_block_timestamp();
        duration = _duration;
        active = true;
        self.timer_started_event(&self.start_time().get(), &duration);
    }

    #[endpoint]
    fn stop(&self) {
        require!(self.blockchain().get_caller() == owner, "Not owner");
        require!(active, "Not active");
        active = false;
        self.timer_stopped_event(&self.blockchain().get_block_timestamp());
    }

    #[endpoint]
    fn reset(&self) {
        require!(self.blockchain().get_caller() == owner, "Not owner");
        startTime = BigUint::from(0u32);
        duration = BigUint::from(0u32);
        active = false;
        self.timer_reset_event();
    }

    #[view(isExpired)]
    fn is_expired(&self) -> bool {
        return active;
    }

    #[view(getTimeRemaining)]
    fn get_time_remaining(&self) -> BigUint<Self::Api> {
        return duration;
    }

}