// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TokenMinter {
    address public owner;
    string public name;
    string public symbol;
    uint256 public totalSupply;
    mapping(address => uint256) public balances;
    mapping(address => bool) public minters;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Minted(address indexed to, uint256 amount);
    event Burned(address indexed from, uint256 amount);
    event MinterAdded(address indexed minter);
    event MinterRemoved(address indexed minter);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier onlyMinter() {
        require(minters[msg.sender], "Not minter");
        _;
    }

    constructor() {
        owner = msg.sender;
        name = "MintableToken";
        symbol = "MTK";
        totalSupply = 0;
        minters[msg.sender] = true;
    }

    function mint(address to, uint256 amount) public onlyMinter {
        require(to != address(0), "Invalid address");
        balances[to] = balances[to] + amount;
        totalSupply = totalSupply + amount;
        emit Minted(to, amount);
    }

    function burn(uint256 amount) public {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] = balances[msg.sender] - amount;
        totalSupply = totalSupply - amount;
        emit Burned(msg.sender, amount);
    }

    function addMinter(address minter) public onlyOwner {
        minters[minter] = true;
        emit MinterAdded(minter);
    }

    function removeMinter(address minter) public onlyOwner {
        minters[minter] = false;
        emit MinterRemoved(minter);
    }

    function balanceOf(address account) public view returns (uint256) {
        return balances[account];
    }
}
