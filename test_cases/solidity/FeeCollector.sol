// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FeeCollector {
    address public owner;
    address public treasury;
    uint256 public feePercent;
    uint256 public totalCollected;

    event FeeCollected(address indexed from, uint256 amount, uint256 fee);
    event FeePercentChanged(uint256 indexed oldPercent, uint256 indexed newPercent);
    event TreasuryChanged(address indexed oldTreasury, address indexed newTreasury);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
        treasury = msg.sender;
        feePercent = 100;
    }

    function collectFee(uint256 amount) public {
        require(amount > 0, "Invalid amount");
        uint256 fee = amount * feePercent / 10000;
        totalCollected = totalCollected + fee;
        emit FeeCollected(msg.sender, amount, fee);
    }

    function setFeePercent(uint256 newPercent) public onlyOwner {
        require(newPercent <= 1000, "Fee too high");
        emit FeePercentChanged(feePercent, newPercent);
        feePercent = newPercent;
    }

    function setTreasury(address newTreasury) public onlyOwner {
        require(newTreasury != address(0), "Invalid treasury");
        emit TreasuryChanged(treasury, newTreasury);
        treasury = newTreasury;
    }
}
