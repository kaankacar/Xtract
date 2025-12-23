// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Claimer {
    address public owner;
    uint256 public claimAmount;
    mapping(address => bool) public hasClaimed;
    mapping(address => uint256) public claimedAt;
    uint256 public totalClaimed;

    event Claimed(address indexed user, uint256 amount, uint256 timestamp);
    event ClaimAmountUpdated(uint256 indexed oldAmount, uint256 indexed newAmount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
        claimAmount = 100;
        totalClaimed = 0;
    }

    function claim() public {
        require(!hasClaimed[msg.sender], "Already claimed");
        hasClaimed[msg.sender] = true;
        claimedAt[msg.sender] = block.timestamp;
        totalClaimed = totalClaimed + claimAmount;
        emit Claimed(msg.sender, claimAmount, block.timestamp);
    }

    function setClaimAmount(uint256 newAmount) public onlyOwner {
        emit ClaimAmountUpdated(claimAmount, newAmount);
        claimAmount = newAmount;
    }

    function checkClaimed(address user) public view returns (bool) {
        return hasClaimed[user];
    }

    function getTotalClaimed() public view returns (uint256) {
        return totalClaimed;
    }
}
