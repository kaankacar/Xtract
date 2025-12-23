// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Registry {
    mapping(string => address) public registry;
    address public owner;

    event Registered(string indexed name, address indexed addr);
    event Unregistered(string indexed name);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function register(string memory name, address addr) public onlyOwner {
        require(addr != address(0), "Invalid address");
        registry[name] = addr;
        emit Registered(name, addr);
    }

    function unregister(string memory name) public onlyOwner {
        registry[name] = address(0);
        emit Unregistered(name);
    }

    function lookup(string memory name) public view returns (address) {
        return registry[name];
    }
}
