// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.23 <0.9.0;

import { UniswapV3Swap } from "../src/UniswapV3Swap.sol";

import { BaseScript } from "./Base.s.sol";

/// @dev See the Solidity Scripting tutorial: https://book.getfoundry.sh/tutorials/solidity-scripting
contract Deploy is BaseScript {
    function run() public broadcast returns (UniswapV3Swap uniswapV3Swap) {
        uniswapV3Swap = new UniswapV3Swap();
    }
}
