// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract OnlyOwner {
    address public owner;
    uint256 public value;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event ValueChanged(uint256 indexed newValue);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function setValue(uint256 newValue) public onlyOwner {
        value = newValue;
        emit ValueChanged(newValue);
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Invalid address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}
