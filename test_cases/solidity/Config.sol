// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Config {
    address public owner;
    mapping(string => uint256) public uintConfig;
    mapping(string => bool) public boolConfig;
    mapping(string => address) public addressConfig;

    event UintConfigSet(string indexed key, uint256 value);
    event BoolConfigSet(string indexed key, bool value);
    event AddressConfigSet(string indexed key, address value);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function setUint(string memory key, uint256 value) public onlyOwner {
        uintConfig[key] = value;
        emit UintConfigSet(key, value);
    }

    function setBool(string memory key, bool value) public onlyOwner {
        boolConfig[key] = value;
        emit BoolConfigSet(key, value);
    }

    function setAddress(string memory key, address value) public onlyOwner {
        addressConfig[key] = value;
        emit AddressConfigSet(key, value);
    }

    function getUint(string memory key) public view returns (uint256) {
        return uintConfig[key];
    }

    function getBool(string memory key) public view returns (bool) {
        return boolConfig[key];
    }

    function getAddress(string memory key) public view returns (address) {
        return addressConfig[key];
    }
}
