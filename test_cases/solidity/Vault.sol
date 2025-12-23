// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Vault {
    address public guardian;
    uint256 public withdrawalDelay;
    mapping(address => uint256) public balances;
    mapping(address => uint256) public pendingWithdrawals;
    mapping(address => uint256) public withdrawalTime;

    event Deposited(address indexed user, uint256 amount);
    event WithdrawalRequested(address indexed user, uint256 amount, uint256 unlockTime);
    event WithdrawalCompleted(address indexed user, uint256 amount);
    event WithdrawalCancelled(address indexed user);

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not guardian");
        _;
    }

    constructor() {
        guardian = msg.sender;
        withdrawalDelay = 86400;
    }

    function deposit(uint256 amount) public {
        require(amount > 0, "Invalid amount");
        balances[msg.sender] = balances[msg.sender] + amount;
        emit Deposited(msg.sender, amount);
    }

    function requestWithdrawal(uint256 amount) public {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] = balances[msg.sender] - amount;
        pendingWithdrawals[msg.sender] = amount;
        withdrawalTime[msg.sender] = block.timestamp + withdrawalDelay;
        emit WithdrawalRequested(msg.sender, amount, withdrawalTime[msg.sender]);
    }

    function completeWithdrawal() public {
        require(pendingWithdrawals[msg.sender] > 0, "No pending withdrawal");
        require(block.timestamp >= withdrawalTime[msg.sender], "Delay not passed");
        uint256 amount = pendingWithdrawals[msg.sender];
        pendingWithdrawals[msg.sender] = 0;
        emit WithdrawalCompleted(msg.sender, amount);
    }

    function cancelWithdrawal() public {
        require(pendingWithdrawals[msg.sender] > 0, "No pending withdrawal");
        uint256 amount = pendingWithdrawals[msg.sender];
        pendingWithdrawals[msg.sender] = 0;
        balances[msg.sender] = balances[msg.sender] + amount;
        emit WithdrawalCancelled(msg.sender);
    }
}
