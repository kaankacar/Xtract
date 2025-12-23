#![no_std]

use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait Subscription {
    #[storage_mapper("owner")]
    fn owner(&self) -> SingleValueMapper<ManagedAddress<Self::Api>>;

    #[storage_mapper("subscriptionPrice")]
    fn subscription_price(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("subscriptionExpiry")]
    fn subscription_expiry(&self, key: &ManagedAddress<Self::Api>) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("isSubscribed")]
    fn is_subscribed(&self, key: &ManagedAddress<Self::Api>) -> SingleValueMapper<bool>;

    #[event("Subscribed")]
    fn subscribed_event(&self, #[indexed] user: &ManagedAddress<Self::Api>, expiry: &BigUint<Self::Api>);

    #[event("Unsubscribed")]
    fn unsubscribed_event(&self, #[indexed] user: &ManagedAddress<Self::Api>);

    #[event("PriceUpdated")]
    fn price_updated_event(&self, #[indexed] oldPrice: &BigUint<Self::Api>, #[indexed] newPrice: &BigUint<Self::Api>);

    #[init]
    fn init(&self) {
        owner = self.blockchain().get_caller();
        subscriptionPrice = BigUint::from(100u32);
    }

    #[endpoint]
    fn subscribe(&self, duration: BigUint<Self::Api>) {
        require!(duration > BigUint::from(0u32), "Invalid duration");
        uint256 expiry = self.blockchain().get_block_timestamp() + duration;
        self.subscribed_event(&self.blockchain().get_caller(), &expiry);
    }

    #[endpoint]
    fn unsubscribe(&self) {
        require!(self.isSubscribed(&self.blockchain().get_caller()), "Not subscribed");
        self.unsubscribed_event(&self.blockchain().get_caller());
    }

    #[endpoint]
    fn set_price(&self, newPrice: BigUint<Self::Api>) {
        require!(self.blockchain().get_caller() == owner, "Not owner");
        self.price_updated_event(&subscriptionPrice, &newPrice);
        subscriptionPrice = newPrice;
    }

    #[view(checkSubscription)]
    fn check_subscription(&self, user: ManagedAddress<Self::Api>) -> bool {
        return self.isSubscribed(&user);
    }

}