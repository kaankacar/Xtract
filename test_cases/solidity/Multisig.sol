// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Multisig {
    mapping(address => bool) public owners;
    uint256 public required;
    uint256 public transactionCount;

    event OwnerAdded(address indexed owner);
    event TransactionSubmitted(uint256 indexed txId);
    event TransactionConfirmed(uint256 indexed txId, address indexed owner);
    event TransactionExecuted(uint256 indexed txId);

    modifier onlyOwner() {
        require(owners[msg.sender], "Not owner");
        _;
    }

    constructor() {
        owners[msg.sender] = true;
        required = 1;
        transactionCount = 0;
    }

    function addOwner(address owner) public onlyOwner {
        require(!owners[owner], "Already owner");
        owners[owner] = true;
        emit OwnerAdded(owner);
    }

    function setRequired(uint256 count) public onlyOwner {
        require(count > 0, "Invalid count");
        required = count;
    }

    function submitTransaction() public onlyOwner {
        transactionCount = transactionCount + 1;
        emit TransactionSubmitted(transactionCount);
    }

    function confirmTransaction(uint256 txId) public onlyOwner {
        emit TransactionConfirmed(txId, msg.sender);
    }

    function executeTransaction(uint256 txId) public onlyOwner {
        emit TransactionExecuted(txId);
    }
}
