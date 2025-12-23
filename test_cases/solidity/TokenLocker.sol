// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TokenLocker {
    address public owner;
    mapping(address => uint256) public lockedAmount;
    mapping(address => uint256) public lockExpiry;

    event TokensLocked(address indexed user, uint256 amount, uint256 expiry);
    event TokensUnlocked(address indexed user, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function lockTokens(uint256 amount, uint256 duration) public {
        require(amount > 0, "Invalid amount");
        require(duration > 0, "Invalid duration");
        lockedAmount[msg.sender] = lockedAmount[msg.sender] + amount;
        lockExpiry[msg.sender] = block.timestamp + duration;
        emit TokensLocked(msg.sender, amount, lockExpiry[msg.sender]);
    }

    function unlockTokens() public {
        require(lockedAmount[msg.sender] > 0, "No locked tokens");
        require(block.timestamp >= lockExpiry[msg.sender], "Not yet unlocked");
        uint256 amount = lockedAmount[msg.sender];
        lockedAmount[msg.sender] = 0;
        emit TokensUnlocked(msg.sender, amount);
    }

    function getLockedAmount(address user) public view returns (uint256) {
        return lockedAmount[user];
    }

    function getLockExpiry(address user) public view returns (uint256) {
        return lockExpiry[user];
    }
}
