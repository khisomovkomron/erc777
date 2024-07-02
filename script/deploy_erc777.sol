// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "lib/forge-std/scr/Script.sol";
import {ERC777} from "../src/erc777.sol";

contract DeployERC777 is Script {

    function run() external returns(ERC777) {
        vm.startBroadcast();

        string memory name = "NewToken";
        string memory symbol = "NWT";
        uint256 granularity = 10;

        address[] memory defaultOperator;

        // defaultOperator[0] = address(0x123);
        // defaultOperator[1] = address(0x456);


        ERC777 erc = new ERC777(name, symbol, granularity, defaultOperator);

        vm.stopBroadcast();

        return erc;
    }
}
