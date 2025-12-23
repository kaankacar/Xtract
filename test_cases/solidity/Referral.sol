// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Referral {
    address public owner;
    uint256 public referralBonus;
    mapping(address => address) public referrers;
    mapping(address => uint256) public referralCount;
    mapping(address => uint256) public earnings;

    event ReferralRegistered(address indexed user, address indexed referrer);
    event BonusPaid(address indexed referrer, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
        referralBonus = 100;
    }

    function register(address referrer) public {
        require(referrer != msg.sender, "Cannot refer self");
        require(referrers[msg.sender] == address(0), "Already registered");
        referrers[msg.sender] = referrer;
        referralCount[referrer] = referralCount[referrer] + 1;
        emit ReferralRegistered(msg.sender, referrer);
    }

    function payBonus(address referrer) public onlyOwner {
        uint256 bonus = referralBonus;
        earnings[referrer] = earnings[referrer] + bonus;
        emit BonusPaid(referrer, bonus);
    }

    function setBonus(uint256 newBonus) public onlyOwner {
        referralBonus = newBonus;
    }

    function getReferralCount(address referrer) public view returns (uint256) {
        return referralCount[referrer];
    }
}
