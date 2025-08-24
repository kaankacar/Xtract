// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    struct Proposal {
        string description;
        uint256 voteCount;
    }
    
    struct Voter {
        bool hasVoted;
        uint256 votedProposalId;
    }
    
    address public chairperson;
    mapping(address => Voter) public voters;
    Proposal[] public proposals;
    uint256 public votingEnd;
    bool public votingClosed;
    
    event ProposalCreated(uint256 indexed proposalId, string description);
    event VoteCast(address indexed voter, uint256 indexed proposalId);
    event VotingClosed(uint256 winningProposalId, string description, uint256 voteCount);
    
    modifier onlyChairperson() {
        require(msg.sender == chairperson, "Only chairperson can call this function");
        _;
    }
    
    modifier votingOpen() {
        require(block.timestamp < votingEnd, "Voting has ended");
        require(!votingClosed, "Voting has been closed");
        _;
    }
    
    constructor(uint256 durationInMinutes) {
        chairperson = msg.sender;
        votingEnd = block.timestamp + durationInMinutes * 1 minutes;
    }
    
    function addProposal(string memory description) public onlyChairperson votingOpen {
        proposals.push(Proposal({
            description: description,
            voteCount: 0
        }));
        
        emit ProposalCreated(proposals.length - 1, description);
    }
    
    function vote(uint256 proposalId) public votingOpen {
        require(proposalId < proposals.length, "Invalid proposal ID");
        Voter storage sender = voters[msg.sender];
        require(!sender.hasVoted, "Already voted");
        
        sender.hasVoted = true;
        sender.votedProposalId = proposalId;
        
        proposals[proposalId].voteCount++;
        
        emit VoteCast(msg.sender, proposalId);
    }
    
    function closeVoting() public onlyChairperson {
        require(!votingClosed, "Voting already closed");
        votingClosed = true;
        
        uint256 winningProposalId = getWinningProposal();
        emit VotingClosed(
            winningProposalId,
            proposals[winningProposalId].description,
            proposals[winningProposalId].voteCount
        );
    }
    
    function getWinningProposal() public view returns (uint256 winningProposalId) {
        uint256 winningVoteCount = 0;
        
        for (uint256 i = 0; i < proposals.length; i++) {
            if (proposals[i].voteCount > winningVoteCount) {
                winningVoteCount = proposals[i].voteCount;
                winningProposalId = i;
            }
        }
    }
    
    function getProposalCount() public view returns (uint256) {
        return proposals.length;
    }
    
    function getProposal(uint256 proposalId) public view returns (string memory description, uint256 voteCount) {
        require(proposalId < proposals.length, "Invalid proposal ID");
        return (proposals[proposalId].description, proposals[proposalId].voteCount);
    }
    
    function getVoterInfo(address voterAddress) public view returns (bool hasVoted, uint256 votedProposalId) {
        Voter memory voter = voters[voterAddress];
        return (voter.hasVoted, voter.votedProposalId);
    }
    
    function getRemainingTime() public view returns (uint256) {
        if (block.timestamp >= votingEnd || votingClosed) {
            return 0;
        }
        return votingEnd - block.timestamp;
    }
} 