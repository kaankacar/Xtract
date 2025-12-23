// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Escrow {
    address public buyer;
    address public seller;
    address public arbiter;
    uint256 public amount;
    bool public released;
    bool public refunded;

    event Deposited(address indexed buyer, uint256 amount);
    event Released(address indexed seller, uint256 amount);
    event Refunded(address indexed buyer, uint256 amount);

    constructor() {
        buyer = msg.sender;
        released = false;
        refunded = false;
    }

    function setSeller(address _seller) public {
        require(msg.sender == buyer, "Only buyer");
        seller = _seller;
    }

    function setArbiter(address _arbiter) public {
        require(msg.sender == buyer, "Only buyer");
        arbiter = _arbiter;
    }

    function deposit(uint256 _amount) public {
        require(msg.sender == buyer, "Only buyer");
        require(!released, "Already released");
        require(!refunded, "Already refunded");
        amount = _amount;
        emit Deposited(buyer, _amount);
    }

    function release() public {
        require(msg.sender == buyer, "Only buyer");
        require(!released, "Already released");
        require(!refunded, "Already refunded");
        released = true;
        emit Released(seller, amount);
    }

    function refund() public {
        require(msg.sender == arbiter, "Only arbiter");
        require(!released, "Already released");
        require(!refunded, "Already refunded");
        refunded = true;
        emit Refunded(buyer, amount);
    }
}
