// // SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.13;

// import "./utils/functionality.t.sol";

// contract EndpWithdraw is Test, MyUtils {
//     /// like ragequit, withrdawals bubble up but not sideways
//     /// trickels through redistribute subDAo and feedMe
//     iInstanceDAO DAO;
//     IDAO20 internalT;
//     IERC20 baseT;

//     address[3] endpoints;
//     address[3] agents;
//     address[3] subDS;

//     iInstanceDAO D1d;
//     iInstanceDAO D2d;
//     iInstanceDAO D3d;

//     IDAO20 D1t;
//     IDAO20 D2t;
//     IDAO20 D3t;
//     uint256 basicMembrane;

//     IDAO20 D1Parent;
//     IDAO20 D2Parent;
//     IDAO20 D3Parent;

//     constructor() {
//         baseT = IERC20(new M20());
//     }

//     function setUp() public {
//         vm.prank(deployer);
//         DAO = iInstanceDAO(_createDAO(address(baseT)));

//         vm.startPrank(Agent1);
//         internalT = IDAO20(DAO.internalTokenAddress());
//         baseT = IERC20(DAO.baseTokenAddress());
//         baseT.approve(address(internalT), type(uint256).max);
//         internalT.wrapMint(1000 ether);

//         vm.stopPrank();
//         vm.prank(Agent1);
//         DAO.mintMembershipToken(Agent1);
//         vm.prank(Agent2);
//         DAO.mintMembershipToken(Agent2);
//         vm.prank(Agent3);
//         DAO.mintMembershipToken(Agent3);

//         agents = [Agent1, Agent2, Agent3];

//         vm.prank(Agent1);
//         basicMembrane = _createBasicMembrane();

//         vm.prank(Agent1);
//         subDS[0] = O.createSubDAO(basicMembrane, address(DAO));
//         vm.prank(Agent2);
//         subDS[1] = O.createSubDAO(basicMembrane, address(DAO));
//         vm.prank(Agent3);
//         subDS[2] = O.createSubDAO(basicMembrane, address(DAO));

//         for (uint256 i; i < 3;) {
//             vm.prank(agents[i]);
//             address sub = O.createSubDAO(uint160(address(agents[i])), subDS[i]);
//             endpoints[i] = sub;
//             unchecked {
//                 ++i;
//             }
//         }

//         D1d = iInstanceDAO(endpoints[0]);
//         D2d = iInstanceDAO(endpoints[1]);
//         D3d = iInstanceDAO(endpoints[2]);

//         D1t = IDAO20(D1d.internalTokenAddress());
//         D2t = IDAO20(D2d.internalTokenAddress());
//         D3t = IDAO20(D3d.internalTokenAddress());

//         D1Parent = IDAO20(D1d.baseTokenAddress());
//         D2Parent = IDAO20(D2d.baseTokenAddress());
//         D3Parent = IDAO20(D3d.baseTokenAddress());
//     }

//     function testExpected() public {
//         //// expected membership balances 0
//         assertTrue(iMR.howManyTotal(D1d.baseID()) == 0, "has 0");
//         assertTrue(iMR.howManyTotal(D2d.baseID()) == 0, "has 00");
//         assertTrue(iMR.howManyTotal(D3d.baseID()) == 0, "has 000");

//         //// is Endpoint Owner
//         assertTrue(D1d.endpoint() == Agent1, "huh1");
//         assertTrue(D2d.endpoint() == Agent2, "huh22");
//         assertTrue(D3d.endpoint() == Agent3, "huh333");

//         //// Endpoint Owner has no internal Token Balance afetr creating endpoint
//         assertTrue(D1t.balanceOf(Agent1) == 0, "has internal b1");
//         assertTrue(D2t.balanceOf(Agent2) == 0, "has internal b22");
//         assertTrue(D3t.balanceOf(Agent3) == 0, "has internal b333");
//     }

//     function testOneGivesTwo() public {
//         vm.startPrank(Agent1, Agent1);

//         internalT.approve(address(D2t), type(uint256).max);
//         internalT.wrapMint(100 ether);

//         IDAO20(iInstanceDAO(subDS[1]).baseTokenAddress()).approve(
//             iInstanceDAO(subDS[1]).internalTokenAddress(), type(uint256).max
//         );
//         IDAO20(iInstanceDAO(subDS[1]).internalTokenAddress()).wrapMint(100 ether);

//         iInstanceDAO(subDS[1]).mintMembershipToken(Agent1);

//         uint256 bi1 = iInstanceDAO(subDS[1]).baseInflationRate();
//         uint256 internalB1 = IERC20(iInstanceDAO(subDS[1]).baseTokenAddress()).balanceOf(subDS[1]);
//         assertTrue(D2d.endpoint() == Agent2);

//         assertTrue(
//             IERC20(iInstanceDAO(D2d).internalTokenAddress()).balanceOf(Agent2) == 0,
//             "expected Agent2 to have no balance"
//         );

//         DAO.signalInflation(100);
//         iInstanceDAO(subDS[1]).signalInflation(100);
//         uint256[] memory signalSub1 = new uint256[](1);
//         uint256[] memory signalPrimary = new uint256[](3);

//         signalSub1[0] = 10_000;
//         signalPrimary[0] = 3_000;
//         signalPrimary[1] = 3_000;
//         signalPrimary[2] = 3_000;

//         DAO.distributiveSignal(signalPrimary);
//         iInstanceDAO(subDS[1]).distributiveSignal(signalSub1);

//         assertTrue(IERC20(D2d.internalTokenAddress()).balanceOf(Agent2) == 0, "expected nada");

//         skip(365 days);

//         uint256 baseAddr1 = IERC20(D2d.baseTokenAddress()).balanceOf(address(D2d));
//         uint256 internalAddr1 = IERC20(D2d.baseTokenAddress()).balanceOf(address(D2d));

//         uint256 expectedMaxWithdraw = IERC20(D2d.baseTokenAddress()).totalSupply();
//         expectedMaxWithdraw = IERC20(D2d.baseTokenAddress()).totalSupply();

//         DAO.redistributeSubDAO(subDS[1]);
//         iInstanceDAO(subDS[1]).redistributeSubDAO(address(D2d));

//         expectedMaxWithdraw = IERC20(D2d.baseTokenAddress()).totalSupply();

//         assertTrue(IERC20(D2d.internalTokenAddress()).balanceOf(Agent2) == 0, "expected nada");

//         /// X
//         assertTrue(IERC20(D2d.baseTokenAddress()).balanceOf(Agent2) < 2, "expected something?");
//         /// X

//         D2d.feedMe();

//         ///---- dupliate redistributeSubDAO and feedME. X

//         expectedMaxWithdraw = IERC20(D2d.baseTokenAddress()).totalSupply();

//         assertTrue(IERC20(D2d.internalTokenAddress()).balanceOf(Agent2) == 0, "expected nada");

//         /// X
//         assertTrue(IERC20(D2d.baseTokenAddress()).balanceOf(Agent2) < 2, "expected something?");
//         /// X

//         uint256 baseAddr2 = IERC20(D2d.baseTokenAddress()).balanceOf(address(D2d));
//         uint256 internalAddr2 = IERC20(D2d.baseTokenAddress()).balanceOf(address(D2d));

//         uint256 bi2 = iInstanceDAO(subDS[1]).baseInflationRate();
//         uint256 internalB2 = IERC20(iInstanceDAO(subDS[1]).baseTokenAddress()).balanceOf(subDS[1]);

//         assertTrue(baseAddr1 < baseAddr2);

//         /// X
//         assertTrue(internalAddr1 < internalAddr2);
//         /// X
//         assertTrue(internalB1 < internalB2);
//         /// X
//         vm.stopPrank();

//         uint256 balanceinParentBeforeEndpointWithdraw = IERC20(D2d.baseTokenAddress()).balanceOf(Agent2);

//         uint256 howmuchToWithdraw = 100_000;

//         uint256 snap = vm.snapshot();
//         vm.prank(Agent2);
//         D2d.withdrawBurn(howmuchToWithdraw);

//         uint256 balanceinParentAfterEndpointWithdraw = IERC20(D2d.baseTokenAddress()).balanceOf(Agent2);
//         assertTrue(D2d.baseTokenAddress() == iInstanceDAO(subDS[1]).internalTokenAddress(), "zzz");
//         /// X
//         assertTrue(balanceinParentBeforeEndpointWithdraw < balanceinParentAfterEndpointWithdraw, "xxx");
//         /// X

//         vm.revertTo(snap);

//         vm.expectRevert();
//         vm.prank(Agent2);
//         D2d.withdrawBurn(expectedMaxWithdraw);

//         vm.expectRevert();
//         vm.prank(Agent2);
//         D2d.withdrawBurn(expectedMaxWithdraw / 2);

//         vm.prank(Agent2);
//         D2d.withdrawBurn(expectedMaxWithdraw / 3);

//         // assertTrue(iMR.getRoots(1).length == 1, "expected eq 1");
//         // assertTrue(iMR.getRoots(1)[0] == address(DAO), "expected DAO");
//         // assertTrue(iMR.getEndpoints(3).length == 3, "expected 3");
//         // assertTrue(iMR.getEndpoints(3)[2] == address(D3d), "expected D3d");
//         // assertTrue(iMR.getEndpoints(3)[0] == address(D1d), "expected D1d");
//     }
// }
