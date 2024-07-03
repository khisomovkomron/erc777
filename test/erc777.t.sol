// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "lib/forge-std/src/Test.sol";
import {ERC777} from "../src/erc777.sol";
import {DeployERC777} from "../script/deploy_erc777.sol";

contract ERC777TEST is Test {
    ERC777 public token;

    address operator_1 = address(0x123);
    address operator_2 = address(0x456);
    address operator_3 = address(0x789);
    uint256 amount = 2 ether;
    bytes data = hex"1234";

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

    // function testDefaultOperators() public view{
    //     address mDefaultOperators = token.defaultOperators();
    //     for (uint256 i =0; i < mDefaultOperators.length; i++){
    //         console.log("Default Operators:", mDefaultOperators[i]);

    //     }
    // }

    function testMint() public{
        token.mint(amount);
        console.log(token.balanceOf(msg.sender));
        assertEq(token.totalSupply(), 2 ether);
    }

    function testSend() public{
        token.mint(amount*2);
        console.log(token.balanceOf(msg.sender));
        token.send(operator_1, amount, data);
        assertEq(token.balanceOf(operator_1), 2 ether);
    }

    function testAuthorizeOperator() public {
        token.authorizeOperator(operator_3);
        assertEq(token.getmAuthorizedOperators(operator_3), true);
    }

    function testAuthorizeOperatorWithDefaultOperator() public {
        token.authorizeOperator(operator_1);
        assertEq(token.getmRevokeDefaultOperators(operator_1), false);
    }

    function testCannotAuthorizeOperator() public {
        vm.expectRevert();
        token.authorizeOperator(msg.sender);
    }

    function testRevokeOperator() public {
        token.revokeOperator(operator_1);
        assertEq(token.getmAuthorizedOperators(operator_1), false);
    }

    function testRevokeOperatorWithDefaultOperator() public {
        token.revokeOperator(operator_1);
        assertEq(token.getmRevokeDefaultOperators(operator_1), true);
    }

    function testRevokeOperatorWithoutDefaultOperator() public {
        token.revokeOperator(operator_3);
        assertEq(token.getmAuthorizedOperators(operator_1), false);
    }

    function testCannotRevokeOperator() public {
        vm.expectRevert();
        token.revokeOperator(msg.sender);
    }

}
