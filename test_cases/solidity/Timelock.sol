// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Timelock {
    address public owner;
    uint256 public unlockTime;
    uint256 public amount;
    bool public claimed;

    event Deposited(address indexed depositor, uint256 amount, uint256 unlockTime);
    event Claimed(address indexed claimer, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
        claimed = false;
    }

    function deposit(uint256 _amount, uint256 _unlockTime) public onlyOwner {
        require(!claimed, "Already claimed");
        require(_unlockTime > block.timestamp, "Unlock time in past");
        amount = _amount;
        unlockTime = _unlockTime;
        emit Deposited(msg.sender, _amount, _unlockTime);
    }

    function claim() public onlyOwner {
        require(!claimed, "Already claimed");
        require(block.timestamp >= unlockTime, "Not yet unlocked");
        claimed = true;
        emit Claimed(msg.sender, amount);
    }

    function getTimeRemaining() public view returns (uint256) {
        return unlockTime;
    }
}
