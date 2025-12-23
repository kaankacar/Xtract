// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Auction {
    address public owner;
    address public highestBidder;
    uint256 public highestBid;
    uint256 public auctionEndTime;
    bool public ended;

    event BidPlaced(address indexed bidder, uint256 amount);
    event AuctionEnded(address indexed winner, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
        highestBid = 0;
        ended = false;
    }

    function startAuction(uint256 duration) public onlyOwner {
        require(!ended, "Auction ended");
        auctionEndTime = block.timestamp + duration;
    }

    function bid(uint256 amount) public {
        require(!ended, "Auction ended");
        require(amount > highestBid, "Bid too low");
        highestBidder = msg.sender;
        highestBid = amount;
        emit BidPlaced(msg.sender, amount);
    }

    function endAuction() public onlyOwner {
        require(!ended, "Already ended");
        ended = true;
        emit AuctionEnded(highestBidder, highestBid);
    }

    function getHighestBid() public view returns (uint256) {
        return highestBid;
    }
}
