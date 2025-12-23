// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Deposit {
    address public owner;
    uint256 public minDeposit;
    uint256 public maxDeposit;
    uint256 public totalDeposits;
    mapping(address => uint256) public userDeposits;

    event DepositMade(address indexed user, uint256 amount);
    event WithdrawalMade(address indexed user, uint256 amount);
    event LimitsUpdated(uint256 minDeposit, uint256 maxDeposit);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
        minDeposit = 100;
        maxDeposit = 10000;
        totalDeposits = 0;
    }

    function deposit(uint256 amount) public {
        require(amount >= minDeposit, "Below minimum");
        require(amount <= maxDeposit, "Above maximum");
        userDeposits[msg.sender] = userDeposits[msg.sender] + amount;
        totalDeposits = totalDeposits + amount;
        emit DepositMade(msg.sender, amount);
    }

    function withdraw(uint256 amount) public {
        require(userDeposits[msg.sender] >= amount, "Insufficient balance");
        userDeposits[msg.sender] = userDeposits[msg.sender] - amount;
        totalDeposits = totalDeposits - amount;
        emit WithdrawalMade(msg.sender, amount);
    }

    function setLimits(uint256 newMin, uint256 newMax) public onlyOwner {
        require(newMin <= newMax, "Invalid limits");
        minDeposit = newMin;
        maxDeposit = newMax;
        emit LimitsUpdated(newMin, newMax);
    }

    function getDeposit(address user) public view returns (uint256) {
        return userDeposits[user];
    }
}
