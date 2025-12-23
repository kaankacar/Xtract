// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract OrderBook {
    address public owner;
    uint256 public orderCount;
    mapping(uint256 => address) public orderOwner;
    mapping(uint256 => uint256) public orderAmount;
    mapping(uint256 => bool) public orderActive;

    event OrderCreated(uint256 indexed orderId, address indexed creator, uint256 amount);
    event OrderCancelled(uint256 indexed orderId);
    event OrderFilled(uint256 indexed orderId, address indexed filler);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
        orderCount = 0;
    }

    function createOrder(uint256 amount) public {
        require(amount > 0, "Invalid amount");
        orderCount = orderCount + 1;
        orderOwner[orderCount] = msg.sender;
        orderAmount[orderCount] = amount;
        orderActive[orderCount] = true;
        emit OrderCreated(orderCount, msg.sender, amount);
    }

    function cancelOrder(uint256 orderId) public {
        require(orderOwner[orderId] == msg.sender, "Not order owner");
        require(orderActive[orderId], "Order not active");
        orderActive[orderId] = false;
        emit OrderCancelled(orderId);
    }

    function fillOrder(uint256 orderId) public {
        require(orderActive[orderId], "Order not active");
        orderActive[orderId] = false;
        emit OrderFilled(orderId, msg.sender);
    }

    function getOrderAmount(uint256 orderId) public view returns (uint256) {
        return orderAmount[orderId];
    }
}
