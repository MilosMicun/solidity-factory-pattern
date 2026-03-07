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

    function testCreateMultipleTokens() public {
        address bob = makeAddr("bob");
        vm.startPrank(bob);
        address token1 = factory.createToken("Alpha", "ALP");
        address token2 = factory.createToken("Beta", "BET");
        address token3 = factory.createToken("Gamma", "GAM");
        vm.stopPrank();
        assertEq(factory.getTokensCount(), 3);
        assertTrue(token1 != address(0));
        assertTrue(token2 != address(0));
        assertTrue(token3 != address(0));

        assertEq(factory.tokens(0), token1);
        assertEq(factory.tokens(1), token2);
        assertEq(factory.tokens(2), token3);

        assertEq(MyToken(token1).owner(), bob);
        assertEq(MyToken(token2).owner(), bob);
        assertEq(MyToken(token3).owner(), bob);
    }

    function testOwnerPropagationWithPrank() public {
        address bob = makeAddr("bob");
        vm.prank(bob);
        address token = factory.createToken("Alpha", "ALP");
        assertEq(MyToken(token).owner(), bob);
    }

    function testIsolatedTokenState() public {
        address tokenA = factory.createToken("Alpha", "ALP");
        address tokenB = factory.createToken("Beta", "BET");
        assertEq(MyToken(tokenA).name(), "Alpha");
        assertEq(MyToken(tokenB).name(), "Beta");

        assertEq(MyToken(tokenA).symbol(), "ALP");
        assertEq(MyToken(tokenB).symbol(), "BET");
    }

    function testRegistryIntegrity() public {
        address token1 = factory.createToken("Alpha", "ALP");
        address token2 = factory.createToken("Beta", "BET");

        assertEq(factory.tokens(0), token1);
        assertEq(factory.tokens(1), token2);
    }
}

