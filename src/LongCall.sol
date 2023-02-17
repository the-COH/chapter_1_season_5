// // SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.13;

// import "./interfaces/IoDAO.sol";
// import "./interfaces/iInstanceDAO.sol";
// import "./interfaces/IMembrane.sol";
// import "./interfaces/IMember1155.sol";
// import "./interfaces/ILongCall.sol";

// import "openzeppelin-contracts/token/ERC20/IERC20.sol";

// import "./errors.sol";

// contract LongCall {
//     address MRaddress;
//     IoDAO ODAO;
//     IMemberRegistry iMR;

//     mapping(uint256 => ExternallCall) getExternalCall;

//     error LongCall__NonR();

//     event CreatedExternalCall(address indexed willCall, address indexed createdBy, bytes callData);

//     function createExternalCall(address callPoint_, bytes memory callData_) external returns (uint256 id) {
//         ExternallCall memory ecALL;
//         ecALL.callPointAddress = callPoint_;
//         ecALL.callData = callData_;
//         ecALL.lastCalledAt = block.timestamp + 5 days;
//         /// @dev is this feature worth the risks?
//         ecALL.eligibleCaller = tx.origin;

//         id = uint256(keccak256(callData_)) - block.timestamp;
//         getExternalCall[id] = ecALL;

//         emit CreatedExternalCall(callPoint_, msg.sender, callData_);
//     }

//     function prepLongDistanceCall(uint256 id_) external returns (ExternallCall memory) {
//         if ((getExternalCall[id_].lastCalledAt) >= block.timestamp) revert LongCall__NonR();
//         getExternalCall[id_].lastCalledAt = block.timestamp + 5 days;
//         return getExternalCall[id_];
//     }

//     function getLongDistanceCall(uint256 id_) external view returns (ExternallCall memory) {
//         return getExternalCall[id_];
//     }
// }
