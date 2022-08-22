// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "../contracts/Setup.sol";
import "./HexUtils.sol";

contract AttackTest is Test {
    bytes bytecode;

    function setUp() public {
        bytecode = fromHex(vm.readFile("test/attack.hex"));
    }

    function testAttackLocal() public {
        Setup sc = new Setup();
        Challenge chal = sc.challenge();

        chal.solve(bytecode);
        assertTrue(sc.isSolved());
    }

    function testAttackServer() public {
        Setup sc = Setup(vm.envAddress("SETUP_CONTRACT"));
        vm.createSelectFork(vm.envString("RPC_URL"));

        Challenge chal = sc.challenge();
        chal.solve(bytecode);
    }
}
