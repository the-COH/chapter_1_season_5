// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

struct ExtCall {
    address[] contractAddressesToCall;
    bytes[] dataToCallWith;
    string shortDescription;
}

interface IExternalCall {
    function createExternalCall(address[] memory contracts_, bytes[] memory callDatas_, string memory description_)
        external
        returns (uint256);

    function getExternalCallbyID(uint256 id) external view returns (ExtCall memory);

    function incrementSelfNonce() external;

    function exeUpdate(uint256 whatExtCallId_) external returns (bool);

    function isValidCall(uint256 id_) external view returns (bool);

    function getNonceOf(address whom_) external view returns (uint256);
}
