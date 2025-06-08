//SPDX-License-Identifier: MIT
pragma solidity 0.8.30;
import { AggregatorV3Interface } from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

error NotOwner();

contract FundMe {
    using PriceConverter for uint256;
    uint256 public constant MINIMUM_USD = 5e18;

    address[] private funders;
    mapping(address => uint256) public addressToAmountFunded;
    address private immutable owner;
    AggregatorV3Interface private s_pricefeed;

    constructor(address priceFeed){
        owner = msg.sender;
        s_pricefeed = AggregatorV3Interface(priceFeed);
    }

    function fund() public payable{
        require(msg.value.getConversionRate(s_pricefeed) >= MINIMUM_USD, "didnt send enough eth");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner{
        uint256 fundersLength = funders.length; //this made the withdraw function more cheaper in terms of gas as we dont read the length of the funders array from the storage again and again in the for loop, that is by defining here, we just have to read once, as reading from storage causes min of 100 gas price
        for(uint256 funderIndex = 0; funderIndex < fundersLength; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);

        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call Failed");
    }

    function checkBalance() public view returns(uint256){
        return address(this).balance;
    }

    modifier onlyOwner(){
        if(msg.sender != owner){
            revert NotOwner();
        }
        _;
    }

    receive() external payable{
        fund();
    }
    
    fallback() external payable{
        fund();
    }

    function getAddressToAmountFunded(address fundingAddress) external view returns (uint256){
        return addressToAmountFunded[fundingAddress];
    }

    function getFunder(uint256 index) external view returns(address){
        return funders[index];
    }

    function getOwner() external view returns (address){
        return owner;
    }
}