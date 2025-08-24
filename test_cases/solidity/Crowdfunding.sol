// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Crowdfunding {
    struct Campaign {
        address creator;
        uint256 goal;
        uint256 pledged;
        uint32 startAt;
        uint32 endAt;
        bool claimed;
    }
    
    uint256 public count;
    mapping(uint256 => Campaign) public campaigns;
    mapping(uint256 => mapping(address => uint256)) public pledges;
    
    event CampaignCreated(uint256 indexed id, address indexed creator, uint256 goal, uint32 startAt, uint32 endAt);
    event PledgeCreated(uint256 indexed id, address indexed pledger, uint256 amount);
    event Unpledged(uint256 indexed id, address indexed pledger, uint256 amount);
    event Claimed(uint256 indexed id, address creator, uint256 amount);
    event Refunded(uint256 indexed id, address indexed pledger, uint256 amount);
    
    modifier campaignExists(uint256 id) {
        require(id < count, "Campaign does not exist");
        _;
    }
    
    function createCampaign(uint256 goal, uint32 startAt, uint32 endAt) external returns (uint256) {
        require(startAt >= block.timestamp, "Start time must be in the future");
        require(endAt > startAt, "End time must be after start time");
        require(endAt <= block.timestamp + 90 days, "End time too far in the future");
        
        uint256 id = count++;
        Campaign storage campaign = campaigns[id];
        campaign.creator = msg.sender;
        campaign.goal = goal;
        campaign.startAt = startAt;
        campaign.endAt = endAt;
        
        emit CampaignCreated(id, msg.sender, goal, startAt, endAt);
        return id;
    }
    
    function pledge(uint256 id) external payable campaignExists(id) {
        Campaign storage campaign = campaigns[id];
        require(block.timestamp >= campaign.startAt, "Campaign not started");
        require(block.timestamp <= campaign.endAt, "Campaign ended");
        
        campaign.pledged += msg.value;
        pledges[id][msg.sender] += msg.value;
        
        emit PledgeCreated(id, msg.sender, msg.value);
    }
    
    function unpledge(uint256 id, uint256 amount) external campaignExists(id) {
        Campaign storage campaign = campaigns[id];
        require(block.timestamp <= campaign.endAt, "Campaign ended");
        require(pledges[id][msg.sender] >= amount, "Not enough pledged");
        
        campaign.pledged -= amount;
        pledges[id][msg.sender] -= amount;
        
        payable(msg.sender).transfer(amount);
        
        emit Unpledged(id, msg.sender, amount);
    }
    
    function claim(uint256 id) external campaignExists(id) {
        Campaign storage campaign = campaigns[id];
        require(campaign.creator == msg.sender, "Not campaign creator");
        require(block.timestamp > campaign.endAt, "Campaign not ended");
        require(campaign.pledged >= campaign.goal, "Goal not reached");
        require(!campaign.claimed, "Already claimed");
        
        campaign.claimed = true;
        payable(campaign.creator).transfer(campaign.pledged);
        
        emit Claimed(id, campaign.creator, campaign.pledged);
    }
    
    function refund(uint256 id) external campaignExists(id) {
        Campaign storage campaign = campaigns[id];
        require(block.timestamp > campaign.endAt, "Campaign not ended");
        require(campaign.pledged < campaign.goal, "Goal reached");
        
        uint256 pledgeAmount = pledges[id][msg.sender];
        require(pledgeAmount > 0, "Nothing to refund");
        
        pledges[id][msg.sender] = 0;
        payable(msg.sender).transfer(pledgeAmount);
        
        emit Refunded(id, msg.sender, pledgeAmount);
    }
    
    function getCampaign(uint256 id) external view campaignExists(id) returns (
        address creator,
        uint256 goal,
        uint256 pledged,
        uint32 startAt,
        uint32 endAt,
        bool claimed
    ) {
        Campaign memory campaign = campaigns[id];
        return (
            campaign.creator,
            campaign.goal,
            campaign.pledged,
            campaign.startAt,
            campaign.endAt,
            campaign.claimed
        );
    }
} 