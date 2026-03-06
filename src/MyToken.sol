// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MyToken {
    address public owner;
    string public name;
    string public symbol;

    constructor(address _owner, string memory _name, string memory _symbol) {
        owner = _owner;
        name = _name;
        symbol = _symbol;
    }
}
