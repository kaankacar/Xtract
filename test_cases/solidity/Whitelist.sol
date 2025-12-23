// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Whitelist {
    address public owner;
    mapping(address => bool) public whitelisted;
    uint256 public whitelistCount;

    event AddedToWhitelist(address indexed account);
    event RemovedFromWhitelist(address indexed account);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier onlyWhitelisted() {
        require(whitelisted[msg.sender], "Not whitelisted");
        _;
    }

    constructor() {
        owner = msg.sender;
        whitelistCount = 0;
    }

    function addToWhitelist(address account) public onlyOwner {
        require(!whitelisted[account], "Already whitelisted");
        whitelisted[account] = true;
        whitelistCount = whitelistCount + 1;
        emit AddedToWhitelist(account);
    }

    function removeFromWhitelist(address account) public onlyOwner {
        require(whitelisted[account], "Not whitelisted");
        whitelisted[account] = false;
        whitelistCount = whitelistCount - 1;
        emit RemovedFromWhitelist(account);
    }

    function isWhitelisted(address account) public view returns (bool) {
        return whitelisted[account];
    }
}
