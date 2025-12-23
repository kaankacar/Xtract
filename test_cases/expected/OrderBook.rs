#![no_std]

use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait OrderBook {
    #[storage_mapper("owner")]
    fn owner(&self) -> SingleValueMapper<ManagedAddress<Self::Api>>;

    #[storage_mapper("orderCount")]
    fn order_count(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("orderOwner")]
    fn order_owner(&self, key: &BigUint<Self::Api>) -> SingleValueMapper<ManagedAddress<Self::Api>>;

    #[storage_mapper("orderAmount")]
    fn order_amount(&self, key: &BigUint<Self::Api>) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("orderActive")]
    fn order_active(&self, key: &BigUint<Self::Api>) -> SingleValueMapper<bool>;

    #[event("OrderCreated")]
    fn order_created_event(&self, #[indexed] orderId: &BigUint<Self::Api>, #[indexed] creator: &ManagedAddress<Self::Api>, amount: &BigUint<Self::Api>);

    #[event("OrderCancelled")]
    fn order_cancelled_event(&self, #[indexed] orderId: &BigUint<Self::Api>);

    #[event("OrderFilled")]
    fn order_filled_event(&self, #[indexed] orderId: &BigUint<Self::Api>, #[indexed] filler: &ManagedAddress<Self::Api>);

    #[init]
    fn init(&self) {
        owner = self.blockchain().get_caller();
        orderCount = BigUint::from(0u32);
    }

    #[endpoint]
    fn create_order(&self, amount: BigUint<Self::Api>) {
        require!(amount > BigUint::from(0u32), "Invalid amount");
        orderCount = orderCount + BigUint::from(1u32);
        self.order_created_event(&orderCount, &self.blockchain().get_caller(), &amount.clone());
    }

    #[endpoint]
    fn cancel_order(&self, orderId: BigUint<Self::Api>) {
        require!(self.orderOwner(&orderId) == self.blockchain().get_caller(), "Not order owner");
        require!(self.orderActive(&orderId), "Order not active");
        self.order_cancelled_event(&orderId);
    }

    #[endpoint]
    fn fill_order(&self, orderId: BigUint<Self::Api>) {
        require!(self.orderActive(&orderId), "Order not active");
        self.order_filled_event(&orderId, &self.blockchain().get_caller());
    }

    #[view(getOrderAmount)]
    fn get_order_amount(&self, orderId: BigUint<Self::Api>) -> BigUint<Self::Api> {
        return self.orderAmount(&orderId);
    }

}