// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RateLimiter {
    address public owner;
    uint256 public limit;
    uint256 public window;
    mapping(address => uint256) public lastAction;
    mapping(address => uint256) public actionCount;

    event ActionPerformed(address indexed user, uint256 count);
    event LimitUpdated(uint256 indexed oldLimit, uint256 indexed newLimit);
    event WindowUpdated(uint256 indexed oldWindow, uint256 indexed newWindow);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier rateLimit() {
        require(actionCount[msg.sender] < limit, "Rate limit exceeded");
        _;
    }

    constructor() {
        owner = msg.sender;
        limit = 10;
        window = 3600;
    }

    function performAction() public rateLimit {
        actionCount[msg.sender] = actionCount[msg.sender] + 1;
        lastAction[msg.sender] = block.timestamp;
        emit ActionPerformed(msg.sender, actionCount[msg.sender]);
    }

    function resetLimit(address user) public onlyOwner {
        actionCount[user] = 0;
    }

    function setLimit(uint256 newLimit) public onlyOwner {
        emit LimitUpdated(limit, newLimit);
        limit = newLimit;
    }

    function setWindow(uint256 newWindow) public onlyOwner {
        emit WindowUpdated(window, newWindow);
        window = newWindow;
    }

    function getActionCount(address user) public view returns (uint256) {
        return actionCount[user];
    }
}
