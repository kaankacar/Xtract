// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Lockable {
    address public owner;
    bool public locked;
    uint256 public unlockTime;
    uint256 public value;

    event Locked(uint256 until);
    event Unlocked();
    event ValueSet(uint256 indexed newValue);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier notLocked() {
        require(!locked, "Contract is locked");
        _;
    }

    constructor() {
        owner = msg.sender;
        locked = false;
        value = 0;
    }

    function lock(uint256 duration) public onlyOwner notLocked {
        locked = true;
        unlockTime = block.timestamp + duration;
        emit Locked(unlockTime);
    }

    function unlock() public onlyOwner {
        require(locked, "Not locked");
        require(block.timestamp >= unlockTime, "Not yet unlocked");
        locked = false;
        emit Unlocked();
    }

    function setValue(uint256 newValue) public onlyOwner notLocked {
        value = newValue;
        emit ValueSet(newValue);
    }

    function getValue() public view returns (uint256) {
        return value;
    }
}
