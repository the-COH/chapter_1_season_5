// // SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.13;

// import "./utils/functionality.t.sol";

// contract reageQuit is Test, MyUtils {
//     /// like ragequit, withrdawals bubble up but not sideways
//     iInstanceDAO DAO;
//     IDAO20 internalT;
//     IERC20 baseT;

//     constructor() {
//         baseT = IERC20(new M20());
//     }

//     function setUp() public {
//         DAO = iInstanceDAO(_createDAO(address(baseT)));
//         internalT = IDAO20(DAO.internalTokenAddress());
//         baseT.approve(address(internalT), type(uint256).max);
//         internalT.wrapMint(1000 ether);
//         _setCreateMembrane(address(DAO));
//     }
// }
