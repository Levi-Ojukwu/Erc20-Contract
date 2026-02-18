// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27;

import {Script, console} from "forge-std/Script.sol";
import {ERC20} from "../src/Erc20.sol";

contract Erc20Script is Script {
    ERC20 public erc20;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        erc20 = new ERC20("MyToken", "MTK", 18, 1000);

        vm.stopBroadcast();
    }
}
