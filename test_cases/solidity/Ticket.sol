// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ticket {
    address public owner;
    uint256 public ticketPrice;
    uint256 public totalTickets;
    uint256 public soldTickets;
    mapping(address => uint256) public ticketBalance;

    event TicketPurchased(address indexed buyer, uint256 quantity);
    event TicketTransferred(address indexed from, address indexed to, uint256 quantity);
    event TicketUsed(address indexed holder, uint256 quantity);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
        ticketPrice = 100;
        totalTickets = 1000;
        soldTickets = 0;
    }

    function buyTicket(uint256 quantity) public {
        require(soldTickets + quantity <= totalTickets, "Not enough tickets");
        ticketBalance[msg.sender] = ticketBalance[msg.sender] + quantity;
        soldTickets = soldTickets + quantity;
        emit TicketPurchased(msg.sender, quantity);
    }

    function transferTicket(address to, uint256 quantity) public {
        require(ticketBalance[msg.sender] >= quantity, "Insufficient tickets");
        ticketBalance[msg.sender] = ticketBalance[msg.sender] - quantity;
        ticketBalance[to] = ticketBalance[to] + quantity;
        emit TicketTransferred(msg.sender, to, quantity);
    }

    function useTicket(uint256 quantity) public {
        require(ticketBalance[msg.sender] >= quantity, "Insufficient tickets");
        ticketBalance[msg.sender] = ticketBalance[msg.sender] - quantity;
        emit TicketUsed(msg.sender, quantity);
    }

    function getBalance(address holder) public view returns (uint256) {
        return ticketBalance[holder];
    }
}
