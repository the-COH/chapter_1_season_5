// // SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.13;

// import "../src/Member1155.sol";

// import "forge-std/Script.sol";
// import "test/mocks/M202.sol";
// import "test/mocks/mockERC20.sol";
// import "test/mocks/M721.sol";
// import "test/mocks/MKR.sol";

// // import "../test/utils/functionality.t.sol";
// import "../src/interfaces/IMember1155.sol";
// import "../src/interfaces/iInstanceDAO.sol";
// import "../src/interfaces/IDAO20.sol";
// import "../src/interfaces/IMembrane.sol";
// import "../src/interfaces/ILongCall.sol";

// contract LocalDeploy is Script {
//     M20 Mock20;
//     M202 Mock202;
//     M721222 M721;
//     MKR mockMKR;

//     MemberRegistry M;
//     IoDAO O;
//     iInstanceDAO instance;
//     IMembrane MembraneR;

//     function run() public {
//         vm.startBroadcast(vm.envUint("GOERLI_PVK")); //// start 1

//         M = new MemberRegistry();
//         Mock20 = new M20();
//         Mock202 = new M202();
//         O = IoDAO(M.ODAOaddress());
//         MembraneR = IMembrane(M.MembraneRegistryAddress());
//         M721 = new M721222();
//         mockMKR = new MKR();

//         console.log("Member GOERLI ______________####_____ : ", address(M));
//         console.log("ODAO GOERLI ______________####_____ : ", M.ODAOaddress());
//         console.log("MembraneR ______________####_____ : ", M.MembraneRegistryAddress());
//         console.log("MKR GOERLI  ______________####_____ : ", address(mockMKR));
//     }
// }
