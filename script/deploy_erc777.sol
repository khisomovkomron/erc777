// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {ERC777} from "../src/erc777.sol";

contract DeployERC777 is Script {

    function run() external returns(ERC777) {
        vm.startBroadcast();

        ERC777 erc = new ERC777();

        vm.stopBroadcast();

        return erc;
    }
}
