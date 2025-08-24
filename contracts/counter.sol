//SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

contract counter{

    uint public count;

    function increase() public {
        //count++;
       count = count + 1;
        //count += 1;
    }
    
    function decrease() public{
        //count--;
       // count = count - 1;
        count -= 1;
    }
}