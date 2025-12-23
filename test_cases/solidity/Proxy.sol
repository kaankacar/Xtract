// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Proxy {
    address public admin;
    address public implementation;
    bool public initialized;

    event ImplementationUpdated(address indexed oldImpl, address indexed newImpl);
    event AdminChanged(address indexed oldAdmin, address indexed newAdmin);
    event Initialized();

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
        initialized = false;
    }

    function initialize(address impl) public onlyAdmin {
        require(!initialized, "Already initialized");
        require(impl != address(0), "Invalid implementation");
        implementation = impl;
        initialized = true;
        emit Initialized();
    }

    function upgradeTo(address newImpl) public onlyAdmin {
        require(newImpl != address(0), "Invalid implementation");
        emit ImplementationUpdated(implementation, newImpl);
        implementation = newImpl;
    }

    function changeAdmin(address newAdmin) public onlyAdmin {
        require(newAdmin != address(0), "Invalid admin");
        emit AdminChanged(admin, newAdmin);
        admin = newAdmin;
    }

    function getImplementation() public view returns (address) {
        return implementation;
    }
}
