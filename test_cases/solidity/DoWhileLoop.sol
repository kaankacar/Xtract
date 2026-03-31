// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DoWhileLoop {
    uint64 public count;

    function countUp(uint64 limit) public {
        uint64 i = 0;
        do {
            i = i + 1;
        } while (i < limit);
        count = i;
    }
}
