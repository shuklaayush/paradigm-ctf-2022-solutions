// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import "../contracts/Setup.sol";
import "../test/Common.sol";

contract CounterScript is Script {
    bytes bytecode;

    function setUp() public {
        bytecode = fromHex(vm.readFile("test/attack.hex"));
    }

    function run() public {
        Setup sc = Setup(vm.envAddress("SETUP_CONTRACT"));

        vm.startBroadcast();
        Challenge chal = sc.challenge();
        chal.solve(bytecode);
    }
}
