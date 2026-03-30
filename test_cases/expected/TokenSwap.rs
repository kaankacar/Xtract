#![no_std]

use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait TokenSwap {
    #[storage_mapper("owner")]
    fn owner(&self) -> SingleValueMapper<ManagedAddress<Self::Api>>;

    #[storage_mapper("rate")]
    fn rate(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("totalSwapped")]
    fn total_swapped(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("swapHistory")]
    fn swap_history(&self, key: &ManagedAddress<Self::Api>) -> SingleValueMapper<BigUint<Self::Api>>;

    #[event("Swapped")]
    fn swapped_event(&self, #[indexed] user: &ManagedAddress<Self::Api>, amountIn: &BigUint<Self::Api>, #[indexed] amountOut: &BigUint<Self::Api>);

    #[event("RateUpdated")]
    fn rate_updated_event(&self, #[indexed] oldRate: &BigUint<Self::Api>, #[indexed] newRate: &BigUint<Self::Api>);

    #[init]
    fn init(&self) {
        owner = self.blockchain().get_caller();
        rate = BigUint::from(100u32);
        totalSwapped = BigUint::from(0u32);
    }

    #[endpoint]
    fn swap(&self, amountIn: BigUint<Self::Api>) {
        require!(amountIn > BigUint::from(0u32), "Invalid amount");
        let mut amountOut: BigUint<Self::Api> = amountIn * rate / BigUint::from(100u32);
        totalSwapped = totalSwapped + amountIn;
        self.swapped_event(&self.blockchain().get_caller(), &amountIn.clone(), &amountOut.clone());
    }

    #[endpoint]
    fn set_rate(&self, newRate: BigUint<Self::Api>) {
        require!(self.blockchain().get_caller() == owner, "Not owner");
        require!(newRate > BigUint::from(0u32), "Invalid rate");
        self.rate_updated_event(&rate, &newRate);
        rate = newRate;
    }

    #[view(getSwapHistory)]
    fn get_swap_history(&self, user: ManagedAddress<Self::Api>) -> BigUint<Self::Api> {
        return self.swapHistory(&user);
    }

}