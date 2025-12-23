#![no_std]

use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait Certificate {
    #[storage_mapper("issuer")]
    fn issuer(&self) -> SingleValueMapper<ManagedAddress<Self::Api>>;

    #[storage_mapper("certificateCount")]
    fn certificate_count(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("certificateOwner")]
    fn certificate_owner(&self, key: &BigUint<Self::Api>) -> SingleValueMapper<ManagedAddress<Self::Api>>;

    #[storage_mapper("certificateValid")]
    fn certificate_valid(&self, key: &BigUint<Self::Api>) -> SingleValueMapper<bool>;

    #[storage_mapper("ownerCertificateCount")]
    fn owner_certificate_count(&self, key: &ManagedAddress<Self::Api>) -> SingleValueMapper<BigUint<Self::Api>>;

    #[event("CertificateIssued")]
    fn certificate_issued_event(&self, #[indexed] certId: &BigUint<Self::Api>, #[indexed] recipient: &ManagedAddress<Self::Api>);

    #[event("CertificateRevoked")]
    fn certificate_revoked_event(&self, #[indexed] certId: &BigUint<Self::Api>);

    #[event("CertificateTransferred")]
    fn certificate_transferred_event(&self, #[indexed] certId: &BigUint<Self::Api>, #[indexed] from: &ManagedAddress<Self::Api>, #[indexed] to: &ManagedAddress<Self::Api>);

    #[init]
    fn init(&self) {
        issuer = self.blockchain().get_caller();
        certificateCount = BigUint::from(0u32);
    }

    #[endpoint]
    fn issue_certificate(&self, recipient: ManagedAddress<Self::Api>) {
        require!(self.blockchain().get_caller() == issuer, "Not issuer");
        require!(recipient != address(BigUint::from(0u32), "Requirement not met");
        certificateCount = certificateCount + BigUint::from(1u32);
        self.certificate_issued_event(&certificateCount, &recipient);
    }

    #[endpoint]
    fn revoke_certificate(&self, certId: BigUint<Self::Api>) {
        require!(self.blockchain().get_caller() == issuer, "Not issuer");
        require!(self.certificateValid(&certId), "Not valid");
        self.certificate_revoked_event(&certId);
    }

    #[endpoint]
    fn transfer_certificate(&self, certId: BigUint<Self::Api>, to: ManagedAddress<Self::Api>) {
        require!(self.certificateOwner(&certId) == self.blockchain().get_caller(), "Not owner");
        require!(self.certificateValid(&certId), "Not valid");
        self.certificate_transferred_event(&certId, &self.blockchain().get_caller(), &to);
    }

    #[view(isValid)]
    fn is_valid(&self, certId: BigUint<Self::Api>) -> bool {
        return self.certificateValid(&certId);
    }

}