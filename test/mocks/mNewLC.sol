// // SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.13;

// import "../../src/interfaces/IoDAO.sol";
// import "../../src/interfaces/iInstanceDAO.sol";
// import "../../src/interfaces/IMembrane.sol";
// import "../../src/interfaces/IMember1155.sol";
// import "../../src/interfaces/ILongCall.sol";

// import "openzeppelin-contracts/token/ERC20/IERC20.sol";

// import "../../src/errors.sol";

// contract LongCallUpgrade100 {
//     address MRaddress;
//     IoDAO ODAO;
//     IMemberRegistry iMR;

//     uint256 howManyDaysDelay;
//     mapping(uint256 => ExternallCall) getExternalCall;

//     error LongCall__NonR();

//     event CreatedExternalCall(address indexed willCall, address indexed createdBy, bytes callData);

//     constructor(uint256 howManyDaysDelay_) {
//         howManyDaysDelay = howManyDaysDelay_ * 1 days;
//     }

//     function createExternalCall(address callPoint_, bytes memory callData_) external returns (uint256 id) {
//         ExternallCall memory ecALL;
//         ecALL.callPointAddress = callPoint_;
//         ecALL.callData = callData_;
//         ecALL.lastCalledAt = block.timestamp + howManyDaysDelay;
//         /// @dev is this feature worth the risks?
//         ecALL.eligibleCaller = tx.origin;

//         id = uint256(keccak256(callData_)) - block.timestamp;
//         getExternalCall[id] = ecALL;

//         emit CreatedExternalCall(callPoint_, msg.sender, callData_);
//     }

//     function prepLongDistanceCall(uint256 id_) external returns (ExternallCall memory) {
//         if ((getExternalCall[id_].lastCalledAt) >= block.timestamp) revert LongCall__NonR();
//         getExternalCall[id_].lastCalledAt = block.timestamp + howManyDaysDelay;
//         return getExternalCall[id_];
//     }

//     function getLongDistanceCall(uint256 id_) external view returns (ExternallCall memory) {
//         return getExternalCall[id_];
//     }
// }
