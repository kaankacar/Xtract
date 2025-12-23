// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RewardPool {
    address public owner;
    uint256 public totalRewards;
    uint256 public rewardRate;
    mapping(address => uint256) public pendingRewards;
    mapping(address => uint256) public lastUpdateTime;

    event RewardAdded(uint256 amount);
    event RewardClaimed(address indexed user, uint256 amount);
    event RewardRateUpdated(uint256 indexed oldRate, uint256 indexed newRate);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
        totalRewards = 0;
        rewardRate = 100;
    }

    function addRewards(uint256 amount) public onlyOwner {
        totalRewards = totalRewards + amount;
        emit RewardAdded(amount);
    }

    function claimReward() public {
        uint256 reward = pendingRewards[msg.sender];
        require(reward > 0, "No rewards");
        pendingRewards[msg.sender] = 0;
        lastUpdateTime[msg.sender] = block.timestamp;
        emit RewardClaimed(msg.sender, reward);
    }

    function updateRewardRate(uint256 newRate) public onlyOwner {
        emit RewardRateUpdated(rewardRate, newRate);
        rewardRate = newRate;
    }

    function getPendingReward(address user) public view returns (uint256) {
        return pendingRewards[user];
    }
}
