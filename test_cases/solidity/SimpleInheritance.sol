// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Note: In practice, Ownable would be imported from a separate file
// For transpilation, the base contract should be flattened or handled separately

contract SimpleInheritance is Ownable {
    uint256 public value;

    event ValueUpdated(uint256 indexed newValue);

    constructor() {
        owner = msg.sender;
        value = 0;
    }

    function setValue(uint256 newValue) public {
        value = newValue;
        emit ValueUpdated(newValue);
    }

    function getValue() public view returns (uint256) {
        return value;
    }
}
