// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Lottery {
    address public owner;
    uint256 public ticketPrice;
    uint256 public ticketCount;
    uint256 public prizePool;
    bool public lotteryOpen;

    event TicketPurchased(address indexed buyer, uint256 ticketId);
    event WinnerSelected(address indexed winner, uint256 prize);
    event LotteryOpened(uint256 ticketPrice);
    event LotteryClosed();

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
        ticketPrice = 0;
        ticketCount = 0;
        prizePool = 0;
        lotteryOpen = false;
    }

    function openLottery(uint256 price) public onlyOwner {
        require(!lotteryOpen, "Already open");
        ticketPrice = price;
        lotteryOpen = true;
        emit LotteryOpened(price);
    }

    function buyTicket() public {
        require(lotteryOpen, "Lottery closed");
        ticketCount = ticketCount + 1;
        prizePool = prizePool + ticketPrice;
        emit TicketPurchased(msg.sender, ticketCount);
    }

    function closeLottery() public onlyOwner {
        require(lotteryOpen, "Already closed");
        lotteryOpen = false;
        emit LotteryClosed();
    }

    function getPrizePool() public view returns (uint256) {
        return prizePool;
    }
}
