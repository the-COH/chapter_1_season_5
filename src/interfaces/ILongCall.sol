// // SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.13;

// struct ExternallCall {
//     address callPointAddress;
//     address eligibleCaller;
//     uint256 lastCalledAt;
//     bytes callData;
// }

// interface ILongCall {
//     function getLongDistanceCall(uint256 id_) external view returns (ExternallCall memory);

//     function createExternalCall(address callPoint_, bytes memory callData_) external returns (uint256 id);

//     function longDistanceCall(uint256 id) external returns (bool);

//     function prepLongDistanceCall(uint256 id_) external returns (ExternallCall memory);
// }
