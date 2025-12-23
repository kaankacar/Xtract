// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TokenVault {
    mapping(address => uint256) public balances;
    uint256 public totalDeposited;

    event Deposit(address indexed user, uint256 amount);
    event Withdrawal(address indexed user, uint256 amount);

    function deposit(uint256 amount) public {
        require(amount > 0, "Amount must be positive");
        balances[msg.sender] = balances[msg.sender] + amount;
        totalDeposited = totalDeposited + amount;
        emit Deposit(msg.sender, amount);
    }

    function withdraw(uint256 amount) public {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] = balances[msg.sender] - amount;
        totalDeposited = totalDeposited - amount;
        emit Withdrawal(msg.sender, amount);
    }

    function getBalance(address user) public view returns (uint256) {
        return balances[user];
    }
}
