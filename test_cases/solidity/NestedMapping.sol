// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract NestedMapping {
    mapping(address => mapping(address => uint256)) public allowance;

    event Approval(address indexed owner, address indexed spender, uint256 value);

    function approve(address spender, uint256 amount) public returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function getAllowance(address owner, address spender) public view returns (uint256) {
        return allowance[owner][spender];
    }
}
