pragma solidity >=0.8.0;
//SPDX-License-Identifier: UNLICENSED

interface poolMethods{

    function showTokenAddress() external view returns(address);//show the address of the token of the pool

    function showPoolBalance() external view returns(uint256,uint256); //show the balance of BUSD-Token pair

    function buyToken(uint256) external; //buy the token from the said pool

    function sellToken(uint256) external; //sell the token back to said pool

    function viewBuyTax() external view returns (uint256); //view the buy tax

    function viewSellTax() external view returns (uint256);//view the sell tax

    function beneficieryAddress(address) external view returns(address);//return the address of the account receiving tax

    function approveEmergencyWithdraw() external;// allow emergency withdrawl of Liquidity

    function tokenPerUSD() external view  returns(uint256);

    function USDPerToken() external view returns(uint256);

    function changeBeneficieryAddress(address ben) external;

}
