// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "../contracts/Setup.sol";

contract AttackTest is Test {
    function testLocal() public {
        Setup sc = new Setup();

        Random rand = sc.random();
        rand.solve(4);

        assertTrue(sc.isSolved());
    }
}
