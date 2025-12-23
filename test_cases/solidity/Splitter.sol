// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Splitter {
    address public owner;
    uint256 public splitCount;
    mapping(uint256 => address) public recipient;
    mapping(uint256 => uint256) public share;
    uint256 public totalShares;

    event RecipientAdded(uint256 indexed index, address indexed recipient, uint256 share);
    event RecipientRemoved(uint256 indexed index);
    event SplitExecuted(uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
        splitCount = 0;
        totalShares = 0;
    }

    function addRecipient(address _recipient, uint256 _share) public onlyOwner {
        require(_recipient != address(0), "Invalid recipient");
        require(_share > 0, "Invalid share");
        splitCount = splitCount + 1;
        recipient[splitCount] = _recipient;
        share[splitCount] = _share;
        totalShares = totalShares + _share;
        emit RecipientAdded(splitCount, _recipient, _share);
    }

    function removeRecipient(uint256 index) public onlyOwner {
        require(recipient[index] != address(0), "No recipient");
        totalShares = totalShares - share[index];
        recipient[index] = address(0);
        share[index] = 0;
        emit RecipientRemoved(index);
    }

    function split(uint256 amount) public onlyOwner {
        require(totalShares > 0, "No recipients");
        emit SplitExecuted(amount);
    }

    function getShare(uint256 index) public view returns (uint256) {
        return share[index];
    }
}
