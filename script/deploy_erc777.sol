// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Script} from "../lib/forge-std/src/Script.sol";
import {ERC777} from "../src/erc777.sol";

contract DeployERC777 is Script {
        address operator_1 = address(0x123);
        address operator_2 = address(0x456);
        address operator_3 = address(0x789);

    function run() external returns(ERC777) {
        vm.startBroadcast();



        string memory name = "NewToken";
        string memory symbol = "NWT";
        uint256 granularity = 10;

        // defaultOperator[0] = address(0x123);
        // defaultOperator[1] = address(0x456);


        ERC777 erc = new ERC777(name, symbol, granularity, operator_1);

        vm.stopBroadcast();

        return erc;
    }
}
