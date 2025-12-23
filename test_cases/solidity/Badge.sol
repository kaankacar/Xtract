// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Badge {
    address public admin;
    uint256 public badgeCount;
    mapping(uint256 => string) public badgeName;
    mapping(address => mapping(uint256 => bool)) public hasBadge;
    mapping(address => uint256) public badgeCountPerUser;

    event BadgeCreated(uint256 indexed badgeId, string name);
    event BadgeAwarded(address indexed user, uint256 indexed badgeId);
    event BadgeRevoked(address indexed user, uint256 indexed badgeId);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
        badgeCount = 0;
    }

    function createBadge(string memory name) public onlyAdmin {
        badgeCount = badgeCount + 1;
        badgeName[badgeCount] = name;
        emit BadgeCreated(badgeCount, name);
    }

    function awardBadge(address user, uint256 badgeId) public onlyAdmin {
        require(!hasBadge[user][badgeId], "Already has badge");
        hasBadge[user][badgeId] = true;
        badgeCountPerUser[user] = badgeCountPerUser[user] + 1;
        emit BadgeAwarded(user, badgeId);
    }

    function revokeBadge(address user, uint256 badgeId) public onlyAdmin {
        require(hasBadge[user][badgeId], "Does not have badge");
        hasBadge[user][badgeId] = false;
        badgeCountPerUser[user] = badgeCountPerUser[user] - 1;
        emit BadgeRevoked(user, badgeId);
    }

    function checkBadge(address user, uint256 badgeId) public view returns (bool) {
        return hasBadge[user][badgeId];
    }
}
