// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./MyToken.sol";

contract TokenFactory {
    address[] public tokens;

    event TokenCreated(address indexed token, address indexed owner);

    function createToken(string memory _name, string memory _symbol) external returns (address) {
        MyToken token = new MyToken(msg.sender, _name, _symbol);
        tokens.push(address(token));

        emit TokenCreated(address(token), msg.sender);
        return address(token);
    }
}
