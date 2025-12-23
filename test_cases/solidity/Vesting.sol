// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Vesting {
    address public beneficiary;
    uint256 public startTime;
    uint256 public duration;
    uint256 public totalAmount;
    uint256 public released;

    event TokensReleased(address indexed beneficiary, uint256 amount);
    event VestingScheduleCreated(address indexed beneficiary, uint256 amount, uint256 duration);

    constructor() {
        beneficiary = msg.sender;
        released = 0;
    }

    function createSchedule(address _beneficiary, uint256 _amount, uint256 _duration) public {
        require(_beneficiary != address(0), "Invalid beneficiary");
        require(_amount > 0, "Invalid amount");
        require(_duration > 0, "Invalid duration");
        beneficiary = _beneficiary;
        totalAmount = _amount;
        duration = _duration;
        startTime = block.timestamp;
        emit VestingScheduleCreated(_beneficiary, _amount, _duration);
    }

    function release() public {
        require(msg.sender == beneficiary, "Not beneficiary");
        uint256 releasable = totalAmount - released;
        require(releasable > 0, "Nothing to release");
        released = released + releasable;
        emit TokensReleased(beneficiary, releasable);
    }

    function getVestedAmount() public view returns (uint256) {
        return released;
    }

    function getRemainingAmount() public view returns (uint256) {
        return totalAmount - released;
    }
}
