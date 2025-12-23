// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Governance {
    address public governor;
    uint256 public proposalCount;
    uint256 public votingPeriod;
    mapping(uint256 => uint256) public proposalVotes;
    mapping(address => bool) public hasVoted;

    event ProposalCreated(uint256 indexed proposalId, address indexed proposer);
    event Voted(uint256 indexed proposalId, address indexed voter, bool support);
    event ProposalExecuted(uint256 indexed proposalId);

    modifier onlyGovernor() {
        require(msg.sender == governor, "Not governor");
        _;
    }

    constructor() {
        governor = msg.sender;
        proposalCount = 0;
        votingPeriod = 86400;
    }

    function createProposal() public {
        proposalCount = proposalCount + 1;
        emit ProposalCreated(proposalCount, msg.sender);
    }

    function vote(uint256 proposalId, bool support) public {
        require(!hasVoted[msg.sender], "Already voted");
        hasVoted[msg.sender] = true;
        proposalVotes[proposalId] = proposalVotes[proposalId] + 1;
        emit Voted(proposalId, msg.sender, support);
    }

    function execute(uint256 proposalId) public onlyGovernor {
        emit ProposalExecuted(proposalId);
    }

    function getVotes(uint256 proposalId) public view returns (uint256) {
        return proposalVotes[proposalId];
    }
}
