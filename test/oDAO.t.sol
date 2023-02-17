// // SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.13;

// import "forge-std/Test.sol";

// import "../src/interfaces/IMember1155.sol";
// import "../src/interfaces/iInstanceDAO.sol";
// import "../src/interfaces/IDAO20.sol";
// import "../src/interfaces/IERC721.sol";
// import "../src/interfaces/IMembrane.sol";

// import "../src/oDAO.sol";
// import "../src/Member1155.sol";
// import "./mocks/mockERC20.sol";

// import {Turnstile} from "../../src/utils/CantoTurnslide.sol";

// contract oDao is Test {
//     IoDAO O;
//     IERC20 BaseE20;
//     IMemberRegistry iMR;
//     IMembrane iMB;
//     DAOinstance DAO;

//     address deployer = address(4896);
//     address Agent1 = address(16);
//     address Agent2 = address(32);
//     address Agent3 = address(48);
//                                     address mainnetTurnslideAddr = address( new Turnstile() );

//     function setUp() public {
//         vm.prank(deployer, deployer);

//         iMR = IMemberRegistry(address(new MemberRegistry(mainnetTurnslideAddr)));
//         iMB = IMembrane(iMR.MembraneRegistryAddress());
//         O = IoDAO(iMR.ODAOaddress());
//         BaseE20 = IERC20(address(new M20()));
//     }

//     function _createAnERC20() public returns (address) {
//         return address(new M20());
//     }

//     function _createBasicMembrane() public returns (uint256 basicMid) {
//         Membrane memory Mmm;
//         address[] memory tokens_ = new address[](1);
//         uint256[] memory balances_ = new uint[](1);

//         tokens_[0] = address(BaseE20);
//         balances_[0] = uint256(1000);

//         basicMid = iMB.createMembrane(tokens_, balances_, "veryMeta");
//     }

//     function testCreateNewDao() public returns (address Dinstnace) {
//         vm.prank(Agent3, Agent3);
//         Dinstnace = address(O.createDAO(address(BaseE20)));
//         DAO = DAOinstance(Dinstnace);

//         assertTrue(address(DAO) != address(0));
//         // assertTrue(DAO.baseID() == uint160(bytes20(address(DAO))));
//         // assertTrue(DAO.owner() == deployer); /// removed owner role

//         // assertTrue(iMR.getRoots(1).length == 1, "has root 1");
//         // assertTrue(iMR.getRoots(1)[0] == Dinstnace, "expected dao 1 to be root 1");
//     }

//     // function testTransferOwnership() public {
//     //     testCreateNewDao();

//     //     // assertTrue(DAO.owner() == deployer);
//     //     vm.prank(deployer, deployer);
//     //     BaseE20.approve(address(DAO), type(uint256).max - 1);
//     //     vm.prank(deployer);
//     //     DAO.giveOwnership(Agent1);
//     //     assertFalse(DAO.owner() == Agent1);
//     //     vm.prank(deployer);
//     //     DAO.giveOwnership(Agent1);
//     //     assertTrue(DAO.owner() == Agent1);
//     // }

//     function testCreatesSubDAO() public {
//         iInstanceDAO DI = iInstanceDAO(testCreateNewDao());
//         // vm.prank(deployer,deployer);
//         // DI.giveOwnership(Agent2);
//         // vm.prank(deployer,deployer);
//         // DI.giveOwnership(Agent2);

//         uint256 membraneID = _createBasicMembrane();
//         vm.expectRevert();
//         address subDAOaddr = O.createSubDAO(membraneID, address(DI));
//         vm.prank(deployer, deployer);
//         DI.mintMembershipToken(Agent1);
//         vm.prank(Agent1);
//         subDAOaddr = address(O.createSubDAO(membraneID, address(DI)));
//         assertTrue(subDAOaddr != address(0), "subdao is 0");

//         assertTrue(iMB.inUseMembraneId(subDAOaddr) != 0, "Has no membrane");
//     }

//     function testAddMembertoDAO() public {
//         iInstanceDAO DI = iInstanceDAO(testCreateNewDao());

//         assertFalse(iMR.balanceOf(deployer, DI.baseID()) == 1, "isNotCoreMember");
//         assertTrue(O.isDAO(address(DI)), "NOT!!!");

//         assertTrue(iMR.balanceOf(Agent2, DI.baseID()) == 0, "is alreadly member");
//         DI.mintMembershipToken(Agent2);
//         assertTrue(iMR.balanceOf(Agent2, DI.baseID()) == 1, "not member");
//         vm.expectRevert();
//         /// "AlreadyIn()"
//         DI.mintMembershipToken(Agent2);

//         // unatisfied token balances
//         // assertFalse(DI.mintMembershipToken(address(934591)));
//         address[] memory memberships = iMR.getActiveMembershipsOf(Agent2);
//         assertTrue(memberships.length > 0);
//         assertTrue(memberships[0] == address(DI));
//     }

//     function testChangesMembrane() public {
//         vm.prank(deployer, deployer);
//         address dInstance = address(O.createDAO(address(BaseE20)));
//         DAO = DAOinstance(dInstance);

//         /// active membrane of dInstance
//         uint256 currentMembrane;

//         currentMembrane = iMB.inUseMembraneId(dInstance);
//         assertTrue(currentMembrane == 0, "has unexpected default membrane");

//         address[] memory a = new address[](1);
//         uint256[] memory u = new uint[](1);

//         a[0] = DAO.baseTokenAddress();
//         u[0] = 101_000;
//         uint256 membrane1 = iMB.createMembrane(a, u, "url://deployer_hasaccessmeta");

//         vm.prank(Agent3);
//         IERC20 token2 = IERC20(_createAnERC20());

//         a[0] = address(token2);
//         u[0] = 101_000;
//         uint256 membrane2 = iMB.createMembrane(a, u, "url://deployer_noaccess");
//         // assertTrue(DAO.owner() == deployer, "owned not deployer");

//         vm.expectRevert(); // membraneNotFound();
//         iMB.setMembrane(2121, address(DAO));

//         vm.prank(dInstance);
//         iMB.setMembrane(membrane1, address(DAO));
//         assertTrue((iMB.inUseMembraneId(dInstance) == membrane1), "failed to set");
//         /// #### 1

//         skip(1);
//         vm.prank(Agent3, Agent3);
//         IDAO20(DAO.baseTokenAddress()).approve(DAO.internalTokenAddress(), type(uint256).max);

//         vm.prank(Agent3, Agent3);
//         skip(1);
//         IDAO20(DAO.internalTokenAddress()).wrapMint(10000099999999999);

//         vm.prank(address(343), address(343));
//         DAO.mintMembershipToken(Agent3);

//         assertTrue((iMB.inUseMembraneId(dInstance) == membrane1), "failed to set");
//         vm.prank(Agent3, Agent3);
//         DAO.changeMembrane(membrane1);
//         assertTrue((iMB.inUseMembraneId(dInstance) == membrane1), "failed to set");

//         //// basic interest rate flip
//         uint256 newInteresRate;
//         console.log("##############################################");
//         vm.prank(Agent1, Agent1);
//         vm.expectRevert();
//         /// DAOinstance__NotMember()
//         newInteresRate = DAO.signalInflation(5);

//         vm.startPrank(Agent1, Agent1);
//         BaseE20.approve(DAO.internalTokenAddress(), type(uint256).max);
//         IDAO20(DAO.internalTokenAddress()).wrapMint(3144960000 * 10000000);
//         vm.stopPrank();

//         vm.prank(Agent3, Agent3);
//         vm.expectRevert(); // [FAIL. Reason: >100!]
//         newInteresRate = DAO.signalInflation(101);
//         DAO.mintMembershipToken(Agent1);

//         vm.prank(Agent1, Agent1);
//         newInteresRate = DAO.signalInflation(0);

//         assertTrue(DAO.baseInflationRate() == 0, "inconsistent");
//         assertTrue(DAO.baseInflationPerSec() == 0, "not persec 0");

//         /// gCheck

//         assertTrue(iMB.gCheck(Agent1, address(DAO)), "expected Agent1 to be g");
//         assertFalse(iMB.gCheck(address(33335433), address(DAO)));

//         IERC20 token3 = IERC20(_createAnERC20());
//         a[0] = address(token3);
//         u[0] = 4294967294;
//         uint256 membrane3 = iMB.createMembrane(a, u, "url://deployer_noaccess");

//         vm.prank(Agent1, Agent1);
//         token3.approve(address(this), type(uint256).max);
//         token3.transferFrom(Agent1, address(111), token3.balanceOf(Agent1));
//         assertTrue(token3.balanceOf(Agent1) == 0, "still has banalce");

//         vm.prank(Agent1, Agent1);
//         DAO.changeMembrane(membrane3);

//         assertFalse(iMB.gCheck(Agent1, address(DAO)), "expected Agent1 to be g");
//         assertFalse(iMB.gCheck(address(111), address(DAO)));

//         /// #### test tipping point
//     }

//     function testCreatesMultipleSubDAO() public {
//         iInstanceDAO DI = iInstanceDAO(testCreateNewDao());

//         uint256 membraneID = _createBasicMembrane();
//         vm.expectRevert();
//         address subDAOaddr = O.createSubDAO(membraneID, address(DI));
//         vm.prank(deployer, deployer);
//         DI.mintMembershipToken(Agent1);
//         vm.prank(Agent1);
//         subDAOaddr = address(O.createSubDAO(membraneID, address(DI)));
//         assertTrue(subDAOaddr != address(0), "subdao is 0");

//         vm.prank(Agent1);
//         subDAOaddr = address(O.createSubDAO(membraneID, address(DI)));
//         assertTrue(subDAOaddr != address(0), "subdao is 0");

//         assertTrue(iMB.inUseMembraneId(subDAOaddr) != 0, "Has no membrane");
//     }
// }
