// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Points {
    address public admin;
    mapping(address => uint256) public points;
    uint256 public totalPoints;

    event PointsAdded(address indexed user, uint256 amount);
    event PointsDeducted(address indexed user, uint256 amount);
    event PointsTransferred(address indexed from, address indexed to, uint256 amount);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
        totalPoints = 0;
    }

    function addPoints(address user, uint256 amount) public onlyAdmin {
        points[user] = points[user] + amount;
        totalPoints = totalPoints + amount;
        emit PointsAdded(user, amount);
    }

    function deductPoints(address user, uint256 amount) public onlyAdmin {
        require(points[user] >= amount, "Insufficient points");
        points[user] = points[user] - amount;
        totalPoints = totalPoints - amount;
        emit PointsDeducted(user, amount);
    }

    function transferPoints(address to, uint256 amount) public {
        require(points[msg.sender] >= amount, "Insufficient points");
        points[msg.sender] = points[msg.sender] - amount;
        points[to] = points[to] + amount;
        emit PointsTransferred(msg.sender, to, amount);
    }

    function getPoints(address user) public view returns (uint256) {
        return points[user];
    }
}
