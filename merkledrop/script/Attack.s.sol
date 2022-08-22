// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import "../contracts/Setup.sol";
import "../test/Attack.sol";

contract CounterScript is Script {
    function run() public {
        Setup sc = Setup(vm.envAddress("SETUP_CONTRACT"));

        vm.startBroadcast();
        Attack attack = new Attack(sc.merkleDistributor());
        attack.attack();
    }
}
