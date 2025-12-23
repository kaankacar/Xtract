// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Leaderboard {
    address public owner;
    mapping(address => uint256) public scores;
    uint256 public highestScore;
    address public leader;

    event ScoreUpdated(address indexed player, uint256 score);
    event NewLeader(address indexed player, uint256 score);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
        highestScore = 0;
    }

    function updateScore(address player, uint256 score) public onlyOwner {
        scores[player] = score;
        emit ScoreUpdated(player, score);
    }

    function submitScore(uint256 score) public {
        scores[msg.sender] = score;
        emit ScoreUpdated(msg.sender, score);
    }

    function claimLeadership() public {
        require(scores[msg.sender] > highestScore, "Not highest score");
        highestScore = scores[msg.sender];
        leader = msg.sender;
        emit NewLeader(msg.sender, highestScore);
    }

    function getScore(address player) public view returns (uint256) {
        return scores[player];
    }

    function getLeader() public view returns (address) {
        return leader;
    }
}
