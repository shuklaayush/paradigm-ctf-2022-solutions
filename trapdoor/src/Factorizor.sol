// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Vm.sol";

contract Factorizor {
    // Foundry cheat vm
    Vm public constant vm = Vm(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);

    function factorize(uint256) external returns (uint256, uint256) {
        string memory flag = vm.envString("FLAG");

        bytes32 i1;
        bytes32 i2;
        assembly {
            i1 := mload(add(flag, 0x20))
            i2 := mload(add(flag, 0x40))
        }
        return (uint256(i1), uint256(i2));
    }
}