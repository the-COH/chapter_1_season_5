pragma solidity >=0.8.0;
//SPDX-License-Identifier: UNLICENSED
interface factoryMethod{
 
    function createNewPool(address,address,uint256,address) external ;
    function showFees() external view returns(uint256,uint256,uint256);
    function showPoolAddress(address) external view returns (address);
    function showUSD() external view returns (address);
}