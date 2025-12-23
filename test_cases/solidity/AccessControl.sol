// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AccessControl {
    address public admin;
    mapping(address => bool) public operators;
    uint256 public operatorCount;

    event AdminChanged(address indexed oldAdmin, address indexed newAdmin);
    event OperatorAdded(address indexed operator);
    event OperatorRemoved(address indexed operator);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    modifier onlyOperator() {
        require(operators[msg.sender], "Not operator");
        _;
    }

    constructor() {
        admin = msg.sender;
        operatorCount = 0;
    }

    function changeAdmin(address newAdmin) public onlyAdmin {
        require(newAdmin != address(0), "Invalid admin");
        emit AdminChanged(admin, newAdmin);
        admin = newAdmin;
    }

    function addOperator(address operator) public onlyAdmin {
        require(!operators[operator], "Already operator");
        operators[operator] = true;
        operatorCount = operatorCount + 1;
        emit OperatorAdded(operator);
    }

    function removeOperator(address operator) public onlyAdmin {
        require(operators[operator], "Not operator");
        operators[operator] = false;
        operatorCount = operatorCount - 1;
        emit OperatorRemoved(operator);
    }

    function isOperator(address account) public view returns (bool) {
        return operators[account];
    }
}
