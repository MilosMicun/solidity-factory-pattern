// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/TokenFactory.sol";

contract TokenFactoryTest is Test {
    TokenFactory factory;

    function setUp() public {
        factory = new TokenFactory();
    }

    function testCreateToken() public {
        address token = factory.createToken("Alpha", "ALP");
        assertTrue(token != address(0));
        MyToken deployedToken = MyToken(token);
        assertEq(deployedToken.owner(), address(this));
        assertEq(factory.tokens(0), token);
    }
}

