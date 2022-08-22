// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import "../contracts/Setup.sol";
import "../test/Attack.sol";

contract AttackScript is Script {
    function setUp() public {}

    function run() public {
        Setup sc = Setup(vm.envAddress("SETUP_CONTRACT"));

        vm.startBroadcast();
        Attack attack = new Attack(sc);
        attack.attack{value: 40 ether}();
        vm.stopBroadcast();
    }
}
