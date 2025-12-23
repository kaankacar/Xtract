#![no_std]

use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait Points {
    #[storage_mapper("admin")]
    fn admin(&self) -> SingleValueMapper<ManagedAddress<Self::Api>>;

    #[storage_mapper("totalPoints")]
    fn total_points(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("points")]
    fn points(&self, key: &ManagedAddress<Self::Api>) -> SingleValueMapper<BigUint<Self::Api>>;

    #[event("PointsAdded")]
    fn points_added_event(&self, #[indexed] user: &ManagedAddress<Self::Api>, amount: &BigUint<Self::Api>);

    #[event("PointsDeducted")]
    fn points_deducted_event(&self, #[indexed] user: &ManagedAddress<Self::Api>, amount: &BigUint<Self::Api>);

    #[event("PointsTransferred")]
    fn points_transferred_event(&self, #[indexed] from: &ManagedAddress<Self::Api>, #[indexed] to: &ManagedAddress<Self::Api>, amount: &BigUint<Self::Api>);

    #[init]
    fn init(&self) {
        admin = self.blockchain().get_caller();
        totalPoints = BigUint::from(0u32);
    }

    #[endpoint]
    fn add_points(&self, user: ManagedAddress<Self::Api>, amount: BigUint<Self::Api>) {
        require!(self.blockchain().get_caller() == self.admin().get(), "Not admin");
        totalPoints = totalPoints + amount.clone();
        self.points_added_event(&user, &amount.clone());
    }

    #[endpoint]
    fn deduct_points(&self, user: ManagedAddress<Self::Api>, amount: BigUint<Self::Api>) {
        require!(self.blockchain().get_caller() == self.admin().get(), "Not admin");
        require!(self.points(&user) >= amount, "Insufficient points");
        totalPoints = totalPoints - amount.clone();
        self.points_deducted_event(&user, &amount.clone());
    }

    #[endpoint]
    fn transfer_points(&self, to: ManagedAddress<Self::Api>, amount: BigUint<Self::Api>) {
        require!(self.points(&self.blockchain().get_caller()) >= amount, "Insufficient points");
        self.points_transferred_event(&self.blockchain().get_caller(), &to, &amount.clone());
    }

    #[view(getPoints)]
    fn get_points(&self, user: ManagedAddress<Self::Api>) -> BigUint<Self::Api> {
        return self.points(&user);
    }

}