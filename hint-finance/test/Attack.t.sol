// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../contracts/Setup.sol";
import "./AmpAttack.sol";
import "./ERC777Attack.sol";
import "./SandAttack.sol";

contract CounterTest is Test {
    Setup sc;
    HintFinanceFactory hintFinanceFactory;

    function setUp() public {
        sc = new Setup{value: 30 ether}();
        hintFinanceFactory = HintFinanceFactory(sc.hintFinanceFactory());
    }

    function testERC777Attack() public {
        ERC20Like token = ERC20Like(sc.underlyingTokens(0));
        HintFinanceVault vault = HintFinanceVault(hintFinanceFactory.underlyingToVault(address(token)));

        ERC777Attack erc777Attack = new ERC777Attack{value: 20 ether}(token, vault);

        uint256 before = token.balanceOf(address(vault));
        erc777Attack.attack();
        assertLe(token.balanceOf(address(vault)), before / 100);
    }

    function testAMPAttack() public {
        ERC20Like token = ERC20Like(sc.underlyingTokens(2));
        HintFinanceVault vault = HintFinanceVault(hintFinanceFactory.underlyingToVault(address(token)));

        AmpAttack ampAttack = new AmpAttack{value: 20 ether}(token, vault);

        uint256 before = token.balanceOf(address(vault));
        ampAttack.attack();
        assertLe(token.balanceOf(address(vault)), before / 100);
    }

    // function testSandAttack() public {
    //     ERC20Like token = ERC20Like(sc.underlyingTokens(1));
    //     HintFinanceVault vault = HintFinanceVault(hintFinanceFactory.underlyingToVault(address(token)));

    //     SandAttack sandAttack = new SandAttack{value: 20 ether}(token, vault);

    //     uint256 before = token.balanceOf(address(vault));
    //     sandAttack.attack();
    //     assertLe(token.balanceOf(address(vault)), before / 100);
    // }
}
