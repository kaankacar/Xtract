#![no_std]

use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait AccessControl {
    #[storage_mapper("admin")]
    fn admin(&self) -> SingleValueMapper<ManagedAddress<Self::Api>>;

    #[storage_mapper("operatorCount")]
    fn operator_count(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("operators")]
    fn operators(&self, key: &ManagedAddress<Self::Api>) -> SingleValueMapper<bool>;

    #[event("AdminChanged")]
    fn admin_changed_event(&self, #[indexed] oldAdmin: &ManagedAddress<Self::Api>, #[indexed] newAdmin: &ManagedAddress<Self::Api>);

    #[event("OperatorAdded")]
    fn operator_added_event(&self, #[indexed] operator: &ManagedAddress<Self::Api>);

    #[event("OperatorRemoved")]
    fn operator_removed_event(&self, #[indexed] operator: &ManagedAddress<Self::Api>);

    #[init]
    fn init(&self) {
        admin = self.blockchain().get_caller();
        operatorCount = BigUint::from(0u32);
    }

    #[endpoint]
    fn change_admin(&self, newAdmin: ManagedAddress<Self::Api>) {
        require!(self.blockchain().get_caller() == self.admin().get(), "Not admin");
        require!(newAdmin != address(BigUint::from(0u32), "Requirement not met");
        self.admin_changed_event(&self.admin().get(), &newAdmin);
        admin = newAdmin;
    }

    #[endpoint]
    fn add_operator(&self, operator: ManagedAddress<Self::Api>) {
        require!(self.blockchain().get_caller() == self.admin().get(), "Not admin");
        require!(!self.operators(&operator), "Already operator");
        operatorCount = operatorCount + BigUint::from(1u32);
        self.operator_added_event(&operator);
    }

    #[endpoint]
    fn remove_operator(&self, operator: ManagedAddress<Self::Api>) {
        require!(self.blockchain().get_caller() == self.admin().get(), "Not admin");
        require!(self.operators(&operator), "Not operator");
        operatorCount = operatorCount - BigUint::from(1u32);
        self.operator_removed_event(&operator);
    }

    #[view(isOperator)]
    fn is_operator(&self, account: ManagedAddress<Self::Api>) -> bool {
        return self.operators(&account);
    }

}