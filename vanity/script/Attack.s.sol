// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.7.6;

import "forge-std/Script.sol";

import "../contracts/Setup.sol";
import "../test/Common.sol";

contract AttackScript is Script {
    function run() public {
        Setup sc = Setup(vm.envAddress("SETUP_CONTRACT"));
        Challenge chal = sc.challenge();

        vm.startBroadcast();
        chal.solve(SHA2_PRECOMPILE, SIGNATURE);
    }
}
