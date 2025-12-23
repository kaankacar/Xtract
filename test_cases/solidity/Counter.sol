// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Counter {
    uint256 public count;

    event CountIncremented(uint256 indexed newCount);
    event CountDecremented(uint256 indexed newCount);
    event CountReset();

    function increment() public {
        count = count + 1;
        emit CountIncremented(count);
    }

    function decrement() public {
        require(count > 0, "Counter underflow");
        count = count - 1;
        emit CountDecremented(count);
    }

    function reset() public {
        count = 0;
        emit CountReset();
    }

    function getCount() public view returns (uint256) {
        return count;
    }
}
