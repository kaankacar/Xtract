// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Staking {
    mapping(address => uint256) public stakes;
    mapping(address => uint256) public rewards;
    uint256 public totalStaked;
    uint256 public rewardRate;

    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount);
    event RewardClaimed(address indexed user, uint256 amount);

    constructor() {
        rewardRate = 100;
    }

    function stake(uint256 amount) public {
        require(amount > 0, "Cannot stake zero");
        stakes[msg.sender] = stakes[msg.sender] + amount;
        totalStaked = totalStaked + amount;
        emit Staked(msg.sender, amount);
    }

    function unstake(uint256 amount) public {
        require(stakes[msg.sender] >= amount, "Insufficient stake");
        stakes[msg.sender] = stakes[msg.sender] - amount;
        totalStaked = totalStaked - amount;
        emit Unstaked(msg.sender, amount);
    }

    function claimReward() public {
        uint256 reward = rewards[msg.sender];
        require(reward > 0, "No reward");
        rewards[msg.sender] = 0;
        emit RewardClaimed(msg.sender, reward);
    }

    function getStake(address user) public view returns (uint256) {
        return stakes[user];
    }
}
