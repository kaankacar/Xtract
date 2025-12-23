// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Subscription {
    address public owner;
    uint256 public subscriptionPrice;
    mapping(address => uint256) public subscriptionExpiry;
    mapping(address => bool) public isSubscribed;

    event Subscribed(address indexed user, uint256 expiry);
    event Unsubscribed(address indexed user);
    event PriceUpdated(uint256 indexed oldPrice, uint256 indexed newPrice);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
        subscriptionPrice = 100;
    }

    function subscribe(uint256 duration) public {
        require(duration > 0, "Invalid duration");
        uint256 expiry = block.timestamp + duration;
        subscriptionExpiry[msg.sender] = expiry;
        isSubscribed[msg.sender] = true;
        emit Subscribed(msg.sender, expiry);
    }

    function unsubscribe() public {
        require(isSubscribed[msg.sender], "Not subscribed");
        isSubscribed[msg.sender] = false;
        emit Unsubscribed(msg.sender);
    }

    function setPrice(uint256 newPrice) public onlyOwner {
        emit PriceUpdated(subscriptionPrice, newPrice);
        subscriptionPrice = newPrice;
    }

    function checkSubscription(address user) public view returns (bool) {
        return isSubscribed[user];
    }
}
