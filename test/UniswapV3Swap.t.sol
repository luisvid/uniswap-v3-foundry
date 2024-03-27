// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { PRBTest } from "@prb/test/src/PRBTest.sol";
import { console2 } from "forge-std/src/console2.sol";
import { StdCheats } from "forge-std/src/StdCheats.sol";

import { UniswapV3Swap, IERC20, IWETH } from "../src/UniswapV3Swap.sol";

address constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
address constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
address constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

contract UniV3SwapTest is PRBTest, StdCheats {
    IWETH private weth = IWETH(WETH);
    IERC20 private dai = IERC20(DAI);
    IERC20 private usdc = IERC20(USDC);

    UniswapV3Swap private uni;

    // the identifiers of the forks
    uint256 mainnetFork;

    function setUp() public {
        // Access the RPC URL from environment variables
        // Create and Select the fork for subsequent operations
        mainnetFork = vm.createSelectFork({ urlOrAlias: vm.envString("MAINNET_FORK_URL") });

        // Instantiate the contract-under-test.
        uni = new UniswapV3Swap();
    }

    function testCanSelectFork() public {
        // select the fork
        vm.selectFork(mainnetFork);
        assertEq(vm.activeFork(), mainnetFork);
    }

    function testSingleHop() public {
        weth.deposit{ value: 1e18 }();
        weth.approve(address(uni), 1e18);

        uint256 amountOut = uni.swapExactInputSingleHop(WETH, DAI, 3000, 1e18);

        console2.log("DAI", amountOut);
    }

    function testMultiHop() public {
        weth.deposit{ value: 1e18 }();
        weth.approve(address(uni), 1e18);

        bytes memory path = abi.encodePacked(WETH, uint24(3000), USDC, uint24(100), DAI);

        uint256 amountOut = uni.swapExactInputMultiHop(path, WETH, 1e18);

        console2.log("DAI", amountOut);
    }
}
