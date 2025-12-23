// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Timer {
    address public owner;
    uint256 public startTime;
    uint256 public duration;
    bool public active;

    event TimerStarted(uint256 startTime, uint256 duration);
    event TimerStopped(uint256 timestamp);
    event TimerReset();

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
        active = false;
    }

    function start(uint256 _duration) public onlyOwner {
        require(!active, "Already active");
        startTime = block.timestamp;
        duration = _duration;
        active = true;
        emit TimerStarted(startTime, duration);
    }

    function stop() public onlyOwner {
        require(active, "Not active");
        active = false;
        emit TimerStopped(block.timestamp);
    }

    function reset() public onlyOwner {
        startTime = 0;
        duration = 0;
        active = false;
        emit TimerReset();
    }

    function isExpired() public view returns (bool) {
        return active;
    }

    function getTimeRemaining() public view returns (uint256) {
        return duration;
    }
}
