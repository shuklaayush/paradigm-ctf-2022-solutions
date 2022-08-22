// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "../contracts/Setup.sol";
import "./Attack.sol";

contract AttackTest is Test {
    function testAttackLocal() public {
        Setup sc = new Setup{value: 10 ether}();

        Attack attack = new Attack(sc);
        attack.attack{value: 40 ether}();

        WETH9 weth = sc.weth();
        assertEq(weth.balanceOf(address(attack.mcHelper())), 0);
    }
}
