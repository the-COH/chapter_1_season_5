// // SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.13;

// import "./utils/functionality.t.sol";
// import "./mocks/mExtern.sol";
// import "./mocks/mNewLC.sol";

// contract ExternalCall is Test, MyUtils {
//     iInstanceDAO DAO;
//     DelegStore MockExt;
//     LongCallUpgrade100 newLongCallLogic100;
//     address mxt;

//     constructor() {
//         MockExt = new DelegStore();
//         mxt = address(MockExt);
//         DAO = iInstanceDAO(_createDAO(address(BaseE20)));
//         newLongCallLogic100 = new LongCallUpgrade100(100);
//     }

//     function _createSimpleExternalCall() public returns (uint256) {
//         return iLG.createExternalCall(mxt, abi.encodeWithSignature("changeODAOAddress(uint256)", 999999999));
//     }

//     function testCreateExternalCall() public {
//         DAO.mintMembershipToken(Agent1);
//         vm.prank(Agent1, Agent1);
//         uint256 id = _createSimpleExternalCall();

//         assertTrue(id > 0);
//         assertTrue(MockExt.baseID() == 5);

//         vm.prank(Agent1);
//         vm.expectRevert(); //"NonR()"
//         bool t = DAO.executeExternalLogic(id);

//         vm.prank(Agent1);
//         skip(1 days);
//         vm.expectRevert(); // "NonR()"
//         t = DAO.executeExternalLogic(id);

//         vm.prank(Agent2);
//         skip(4 days);
//         vm.expectRevert(); // "DAOinstance__NotMember()"
//         t = DAO.executeExternalLogic(id);
//         assertFalse(t);

//         vm.prank(Agent2);
//         DAO.mintMembershipToken(Agent2);
//         skip(4 days);
//         vm.expectRevert(); // "DAOinstance__NotMember()"
//         t = DAO.executeExternalLogic(id);
//         assertFalse(t);

//         assertTrue(MockExt.baseID() == 5);

//         vm.prank(Agent1, Agent1);
//         skip(6 days);
//         t = DAO.executeExternalLogic(id);

//         assertTrue(t);
//         assertTrue(DAO.baseID() == 999999999);
//     }

//     function _createReplaceExternalCallLogic() public returns (uint256) {
//         return iLG.createExternalCall(
//             mxt, abi.encodeWithSignature("replaceILongDistanceCalLogic(address)", address(newLongCallLogic100))
//         );
//     }

//     function testReplaceLongCallLogic() public {
//         vm.prank(Agent1, Agent1);
//         uint256 id = _createReplaceExternalCallLogic();

//         address current = DAO.getILongDistanceAddress();

//         DAO.mintMembershipToken(Agent1);
//         vm.prank(Agent1, Agent1);
//         vm.expectRevert(); //"LongCall__NonR()"
//         bool t = DAO.executeExternalLogic(id);

//         vm.prank(Agent1, Agent1);
//         skip(10 days);
//         t = DAO.executeExternalLogic(id);

//         assertTrue(current != DAO.getILongDistanceAddress());

//         iLG = ILongCall(DAO.getILongDistanceAddress());
//         uint256 id2 = iLG.createExternalCall(mxt, abi.encodeWithSignature("changeODAOAddress(uint256)", 999999999));

//         skip(9);
//         vm.prank(Agent1, Agent1); // 10
//         vm.expectRevert();
//         /// "LongCall__NonR()"
//         t = DAO.executeExternalLogic(id2);

//         skip(10 days);
//         vm.prank(Agent1, Agent1); // 10
//         vm.expectRevert();
//         /// "LongCall__NonR()"
//         t = DAO.executeExternalLogic(id2);

//         skip(99 days);
//         vm.prank(Agent1, Agent1); // 10
//         t = DAO.executeExternalLogic(id2);
//         assertTrue(t);
//     }
// }
