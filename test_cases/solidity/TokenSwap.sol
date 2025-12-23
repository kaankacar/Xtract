// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TokenSwap {
    address public owner;
    uint256 public rate;
    uint256 public totalSwapped;
    mapping(address => uint256) public swapHistory;

    event Swapped(address indexed user, uint256 amountIn, uint256 amountOut);
    event RateUpdated(uint256 indexed oldRate, uint256 indexed newRate);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
        rate = 100;
        totalSwapped = 0;
    }

    function swap(uint256 amountIn) public {
        require(amountIn > 0, "Invalid amount");
        uint256 amountOut = amountIn * rate / 100;
        swapHistory[msg.sender] = swapHistory[msg.sender] + amountIn;
        totalSwapped = totalSwapped + amountIn;
        emit Swapped(msg.sender, amountIn, amountOut);
    }

    function setRate(uint256 newRate) public onlyOwner {
        require(newRate > 0, "Invalid rate");
        emit RateUpdated(rate, newRate);
        rate = newRate;
    }

    function getSwapHistory(address user) public view returns (uint256) {
        return swapHistory[user];
    }
}
