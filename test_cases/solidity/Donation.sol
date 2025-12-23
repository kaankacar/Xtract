// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Donation {
    address public owner;
    address public beneficiary;
    uint256 public totalDonations;
    mapping(address => uint256) public donations;

    event DonationReceived(address indexed donor, uint256 amount);
    event Withdrawn(address indexed beneficiary, uint256 amount);
    event BeneficiaryChanged(address indexed oldBeneficiary, address indexed newBeneficiary);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
        beneficiary = msg.sender;
        totalDonations = 0;
    }

    function donate(uint256 amount) public {
        require(amount > 0, "Invalid amount");
        donations[msg.sender] = donations[msg.sender] + amount;
        totalDonations = totalDonations + amount;
        emit DonationReceived(msg.sender, amount);
    }

    function withdraw(uint256 amount) public onlyOwner {
        require(amount <= totalDonations, "Insufficient funds");
        totalDonations = totalDonations - amount;
        emit Withdrawn(beneficiary, amount);
    }

    function setBeneficiary(address newBeneficiary) public onlyOwner {
        require(newBeneficiary != address(0), "Invalid beneficiary");
        emit BeneficiaryChanged(beneficiary, newBeneficiary);
        beneficiary = newBeneficiary;
    }

    function getDonation(address donor) public view returns (uint256) {
        return donations[donor];
    }
}
