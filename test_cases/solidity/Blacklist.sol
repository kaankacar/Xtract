// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Blacklist {
    address public owner;
    mapping(address => bool) public blacklisted;
    uint256 public blacklistCount;

    event Blacklisted(address indexed account);
    event Unblacklisted(address indexed account);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier notBlacklisted() {
        require(!blacklisted[msg.sender], "Account is blacklisted");
        _;
    }

    constructor() {
        owner = msg.sender;
        blacklistCount = 0;
    }

    function addToBlacklist(address account) public onlyOwner {
        require(!blacklisted[account], "Already blacklisted");
        blacklisted[account] = true;
        blacklistCount = blacklistCount + 1;
        emit Blacklisted(account);
    }

    function removeFromBlacklist(address account) public onlyOwner {
        require(blacklisted[account], "Not blacklisted");
        blacklisted[account] = false;
        blacklistCount = blacklistCount - 1;
        emit Unblacklisted(account);
    }

    function isBlacklisted(address account) public view returns (bool) {
        return blacklisted[account];
    }

    function getBlacklistCount() public view returns (uint256) {
        return blacklistCount;
    }
}
