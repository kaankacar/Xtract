// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UncheckedArithmetic {
    uint64 public result;

    function addUnchecked(uint64 a, uint64 b) public {
        unchecked {
            result = a + b;
        }
    }
}
