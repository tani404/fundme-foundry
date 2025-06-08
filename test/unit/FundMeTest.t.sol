//SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test{
    FundMe fundMe;
    address USER = makeAddr("user"); //makeAddr is a cheatcode to make a dummy address based on the argument(name) passed in it

    function setUp() external{
        //fundMe = new FundMe();
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, 10e18); //passing funds to the dummy address - foundry cheatcode
    }

    function testMinimumDollarIsFive() public view{
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    } 

    function testOwnerIsMsgSender() public view{
        assertEq(fundMe.getOwner(), msg.sender); 
    }

    function testFundFailsWithoutEnoughEth() public{
        vm.prank(USER);
        vm.expectRevert();
        fundMe.fund{value: 1 wei}();
    }

    function testFundUpdatesFundedDataStructure() public{
        vm.prank(USER); //passing a dummy address -  foundry cheatcode
        fundMe.fund{value: 10e18}();

        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, 10e18);
    }

    function testAddsFunderToArrayOfFunders() public{
        vm.prank(USER);
        fundMe.fund{value: 10e18}();

        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }

    modifier funded(){
        vm.prank(USER);
        fundMe.fund{value: 10e18}();
        _;
    }

    function testOnlyOwnerCanWithdraw() public funded{

        vm.expectRevert();
        vm.prank(USER);
        fundMe.withdraw();
    }

    function testWithdrawWithASingleFunder() public{
        //arrange
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        //act
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        //assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;

        assertEq(startingFundMeBalance + startingOwnerBalance, endingOwnerBalance);
    }

    function testWithdrawWithMultipleFunders() public{
        uint160 numOfFunders = 10;
        uint160 startingFunderIndex = 1;

        for(uint160 i = startingFunderIndex; i < numOfFunders; i++){
            hoax(address(i), 10e18); //hoax: both prank and deal
            fundMe.fund{value: 10e18}();

            uint256 startingOwnerBalance = fundMe.getOwner().balance;
            uint256 startingFundMeBalance = address(fundMe).balance;

            vm.startPrank(fundMe.getOwner());
            fundMe.withdraw();
            vm.stopPrank();

            assert(address(fundMe).balance == 0);
            assertEq(startingFundMeBalance + startingOwnerBalance, fundMe.getOwner().balance);
     

        }

    }

    //as of solidity v0.8, you can no longer cast explicitly from address to uint256, you can now use: uint160(has the same amount of bytes as an address).
}