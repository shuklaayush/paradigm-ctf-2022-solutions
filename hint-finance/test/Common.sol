// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../contracts/Setup.sol";

interface IERC1820Registry {
    function setInterfaceImplementer(address _addr, bytes32 _interfaceHash, address _implementer) external;
}

interface IERC20ExecuteExtension {
    function getAdmin() external view returns (address);
    function getExecutionAdmin() external view returns (address);
    function isSuperOperator(address who) external view returns (bool);
    function isExecutionOperator(address who) external view returns (bool);
}

abstract contract AttackBase {
    function swapEthToToken(ERC20Like token, uint256 val) internal {
        UniswapV2RouterLike router = UniswapV2RouterLike(0xf164fC0Ec4E93095b804a4795bBe1e041497b92a);

        address weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
        address[] memory path = new address[](2);
        path[0] = weth;

        // swap for underlying tokens
        path[1] = address(token);
        router.swapExactETHForTokens{value: val}(0, path, address(this), block.timestamp);
    }
}
