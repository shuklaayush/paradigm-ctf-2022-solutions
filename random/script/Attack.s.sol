// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import "../contracts/Setup.sol";

contract CounterScript is Script {
    function setUp() public {}

    function run() public {
        Setup sc = Setup(vm.envAddress("SETUP_CONTRACT"));
        Random rand = sc.random();

        vm.startBroadcast();
        rand.solve(4);
    }
}
