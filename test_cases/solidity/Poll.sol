// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Poll {
    address public creator;
    uint256 public optionCount;
    mapping(uint256 => uint256) public votes;
    mapping(address => bool) public hasVoted;
    bool public pollActive;

    event PollCreated(address indexed creator, uint256 options);
    event VoteCast(address indexed voter, uint256 option);
    event PollClosed(uint256 winningOption);

    modifier onlyCreator() {
        require(msg.sender == creator, "Not creator");
        _;
    }

    constructor() {
        creator = msg.sender;
        optionCount = 0;
        pollActive = false;
    }

    function createPoll(uint256 options) public onlyCreator {
        require(!pollActive, "Poll already active");
        optionCount = options;
        pollActive = true;
        emit PollCreated(msg.sender, options);
    }

    function castVote(uint256 option) public {
        require(pollActive, "Poll not active");
        require(!hasVoted[msg.sender], "Already voted");
        require(option < optionCount, "Invalid option");
        hasVoted[msg.sender] = true;
        votes[option] = votes[option] + 1;
        emit VoteCast(msg.sender, option);
    }

    function closePoll() public onlyCreator {
        require(pollActive, "Poll not active");
        pollActive = false;
        emit PollClosed(0);
    }

    function getVotes(uint256 option) public view returns (uint256) {
        return votes[option];
    }
}
