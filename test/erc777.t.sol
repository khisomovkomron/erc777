// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {ERC777} from "../src/erc777.sol";
import {DeployERC777} from "../script/deploy_erc777.sol";

contract ERC777TEST is Test {
    ERC777 public token;

    function setUp() public {
        DeployERC777 deploy_erc = new DeployERC777();

        token = deploy_erc.run();
        
    }

    function testName() public view{
        string memory expectedName = "NewToken";
        string memory actualName = token.name();
        console.log("Expected Name:", expectedName);
        console.log("Actual Name:", actualName);

        assert(keccak256(abi.encodePacked(expectedName)) == keccak256(abi.encodePacked(actualName)));
    }

    function testSymbol() public view{
        string memory expectedSymbol = "NWT";
        string memory actualSymbol = token.symbol();
        console.log("Expected Symbol:", expectedSymbol);
        console.log("Actual Symbol:", actualSymbol);

        assert(keccak256(abi.encodePacked(expectedSymbol)) == keccak256(abi.encodePacked(actualSymbol)));
    }

    function testGranularity() public view{
        uint256 expectedGranularity = 10;
        uint256 actualGranularity = token.granularity();
        console.log("Expected Granularity:", expectedGranularity);
        console.log("Actual Granularity:", actualGranularity);

        assert(keccak256(abi.encodePacked(expectedGranularity)) == keccak256(abi.encodePacked(actualGranularity)));
    }

    function testTotalSupply() public view{
        uint256 expectedTotalSupply = 0;
        uint256 actualTotalSupply = token.totalSupply();
        console.log("Expected TotalSupply:", expectedTotalSupply);
        console.log("Actual TotalSupply:", actualTotalSupply);

        assert(keccak256(abi.encodePacked(expectedTotalSupply)) == keccak256(abi.encodePacked(actualTotalSupply)));
    }

}
