// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./utils/functionality.t.sol";

contract mintBurn is Test, MyUtils {
    /// like ragequit, withrdawals bubble up but not sideways
    iInstanceDAO DAO;
    IDAO20 internalT;
    IERC20 baseT;

    constructor() {
        baseT = IERC20(new M20());
    }

    function setUp() public {
        vm.prank(Agent1);
        DAO = iInstanceDAO(_createDAO(address(baseT)));
        vm.startPrank(Agent2);
        DAO.mintMembershipToken(Agent2);
        DAO.mintMembershipToken(Agent3);
        internalT = IDAO20(DAO.internalTokenAddress());
        baseT = IERC20(DAO.baseTokenAddress());
        baseT.approve(address(internalT), type(uint256).max);
        internalT.wrapMint(1000 ether);
        vm.stopPrank();

        _setCreateMembrane(address(DAO));
    }

    function testSimpleMint() public returns (uint256) {
        uint256 howM = baseT.balanceOf(Agent3);
        assertTrue(address(baseT) != address(internalT));
        uint256 b0 = internalT.balanceOf(Agent3);
        assertTrue(b0 == 0, "should not have balance");
        vm.prank(Agent3, Agent3);
        baseT.approve(address(internalT), type(uint256).max);
        console.log("I approve: ", internalT.base());
        vm.prank(Agent3, Agent3);
        internalT.wrapMint(howM - 1);
        uint256 b1 = internalT.balanceOf(Agent3);
        // assertTrue(b1 >= howM, "should now have balance");

        return howM;
    }

    function testSimpleBurn() public returns (uint256) {
        // assertTrue(internalT.balanceOf(Agent3) == 0, "has balance");
        // uint256 howM = testSimpleMint();
        // assertTrue(internalT.balanceOf(Agent3) > 0, "no balance");

        // uint256 s = vm.snapshot();

        // uint256 b = internalT.balanceOf(Agent3);
        // vm.prank(Agent3);
        // bool x = internalT.unwrapBurn(b / 2 - 1);
        // assertTrue(x, "not x");
        // // assertTrue(internalT.balanceOf(Agent3) >= howM / 2);
        // vm.expectRevert();
        // /// insufficient balance (this)
        // x = internalT.unwrapBurn(b / 2 - 1);

        // vm.prank(Agent3);
        // x = internalT.unwrapBurn(b / 2 - 1);
        // assertTrue(x, "NOT X 2");
        // assertTrue(internalT.balanceOf(Agent3) == 0);
        // assertTrue(baseT.balanceOf(Agent3) == howM - 1);

        // return baseT.balanceOf(Agent3);
    }

    function testTDiffImpact() public {
        uint256 b = testSimpleMint() - 1;
        uint256 s = vm.snapshot();
        vm.prank(Agent3);
        bool x = internalT.unwrapBurn(b);
        vm.prank(Agent2);
        DAO.signalInflation(100);

        assertTrue(b == baseT.balanceOf(Agent3), "dif token balances not equal");

        vm.prank(Agent3);
        internalT.wrapMint(b);
        assertTrue(b == internalT.balanceOf(Agent3), "dif token balances not equal");
        vm.prank(Agent3);
        assertTrue(internalT.unwrapBurn(b), "burn f");
        assertTrue(b == baseT.balanceOf(Agent3), "2 dif token balances not equal");

        vm.prank(Agent3);
        internalT.wrapMint(b);
        assertTrue(b == internalT.balanceOf(Agent3), "dif token balances not equal");
        skip(365 days);
        /// <---diff
        DAO.mintInflation();
        /// should be as part of mint burn
        vm.prank(Agent3);
        assertTrue(internalT.unwrapBurn(b), "burn f");
        assertTrue(b > baseT.balanceOf(Agent3), "2 dif token balances not equal");
    }
}
