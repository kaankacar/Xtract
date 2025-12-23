// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TokenBridge {
    address public owner;
    uint256 public bridgeFee;
    uint256 public totalBridged;
    mapping(address => uint256) public bridgedAmount;
    mapping(uint256 => bool) public processedNonces;

    event BridgeInitiated(address indexed user, uint256 amount, uint256 nonce);
    event BridgeCompleted(address indexed user, uint256 amount, uint256 nonce);
    event FeeUpdated(uint256 indexed oldFee, uint256 indexed newFee);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
        bridgeFee = 10;
        totalBridged = 0;
    }

    function initiateBridge(uint256 amount, uint256 nonce) public {
        require(amount > bridgeFee, "Amount too small");
        require(!processedNonces[nonce], "Nonce already used");
        processedNonces[nonce] = true;
        bridgedAmount[msg.sender] = bridgedAmount[msg.sender] + amount;
        totalBridged = totalBridged + amount;
        emit BridgeInitiated(msg.sender, amount, nonce);
    }

    function completeBridge(address user, uint256 amount, uint256 nonce) public onlyOwner {
        emit BridgeCompleted(user, amount, nonce);
    }

    function setFee(uint256 newFee) public onlyOwner {
        emit FeeUpdated(bridgeFee, newFee);
        bridgeFee = newFee;
    }

    function getBridgedAmount(address user) public view returns (uint256) {
        return bridgedAmount[user];
    }
}
