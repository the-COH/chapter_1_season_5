pragma solidity >=0.8.0;

//SPDX-License-Identifier: UNLICENSED

import "./AutoLPBetterSwap.sol";

contract BetterSwapTokenFactory{

    address public owner;
    address public fundHolder;
    uint256 public fee=20*1e18;
    address USD=0xc58c3144c9CC63C9Fcc3eAe8d543DE9eFE27BeEF;
    IBEP20 con;
    mapping(address=> address[]) public tokensCreatedByAddress;

    constructor(address _fundHolder){

        owner=msg.sender;
        fundHolder = _fundHolder;
        con = IBEP20(USD);
    }

    function setTokenCreationFee(uint256 feeAMT) external{
        require(msg.sender==owner,"You are not the father");
        fee = feeAMT*10**18;
    }

    function changeOwner(address newOwner) external{
        require(msg.sender==owner,"You are not the father");
        owner = newOwner;
    }

    function changeFundHolder(address holder) external{
        require(msg.sender==owner,"You are not the father");
        fundHolder = holder;
    }
    function lastTkCreated(address u) external view returns(address){
        return tokensCreatedByAddress[u][tokensCreatedByAddress[u].length-1];
    }

    function createSimpleToken(string memory name, string memory symbol,
                            uint256 supply,uint256 [] memory TbuyTax,address [] memory wallets,uint256 LP, uint256 burn) external returns(address) {
                con.transferFrom(msg.sender,fundHolder,fee);
                AutoLPBetterSwap newContract = new AutoLPBetterSwap(name,symbol,supply,TbuyTax,wallets, LP, burn,msg.sender);

                tokensCreatedByAddress[msg.sender].push(address(newContract));

                return (address(newContract));
    }




}