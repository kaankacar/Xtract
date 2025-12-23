// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Membership {
    address public owner;
    uint256 public membershipFee;
    uint256 public memberCount;
    mapping(address => bool) public isMember;
    mapping(address => uint256) public memberSince;

    event MemberJoined(address indexed member, uint256 timestamp);
    event MemberLeft(address indexed member);
    event FeeUpdated(uint256 indexed oldFee, uint256 indexed newFee);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier onlyMember() {
        require(isMember[msg.sender], "Not a member");
        _;
    }

    constructor() {
        owner = msg.sender;
        membershipFee = 100;
        memberCount = 0;
    }

    function join() public {
        require(!isMember[msg.sender], "Already a member");
        isMember[msg.sender] = true;
        memberSince[msg.sender] = block.timestamp;
        memberCount = memberCount + 1;
        emit MemberJoined(msg.sender, block.timestamp);
    }

    function leave() public onlyMember {
        isMember[msg.sender] = false;
        memberCount = memberCount - 1;
        emit MemberLeft(msg.sender);
    }

    function setFee(uint256 newFee) public onlyOwner {
        emit FeeUpdated(membershipFee, newFee);
        membershipFee = newFee;
    }

    function checkMembership(address account) public view returns (bool) {
        return isMember[account];
    }
}
