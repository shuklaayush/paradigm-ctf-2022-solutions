// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.7.6;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../contracts/Setup.sol";
import "./Common.sol";

contract AttackTest is Test {
    Challenge public ch;

    function testAttack() public {
        Setup sc = new Setup();
        Challenge chal = sc.challenge();

        chal.solve(SHA2_PRECOMPILE, SIGNATURE);

        assertTrue(sc.isSolved());
    }
}
