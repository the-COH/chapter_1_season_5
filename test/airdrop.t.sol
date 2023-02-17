// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./utils/functionality.t.sol";
import {WlWDrop} from "../src/Drop.sol";
import {WlW} from "../src/WLW.sol";
import {IWLW20} from "../src/interfaces/IWLW20.sol";
import {Turnstile} from "../src/utils/CantoTurnslide.sol";
import {CSRvault} from "../src/CSRVault.sol";

contract WLWtests is Test {
    IWLW20 Walllawtoken;
    address boss;
    WlWDrop WDROP;
    address CSRv;
    bytes32 MERKL_ROOT = 0x8434b51bdaf035c90b9cf7c2e22f964608d7abd9defae0be013d582779839876;

    constructor() {
        boss = address(22);
        address mainnetTurnslideAddr = address(new Turnstile());
        vm.prank(boss);
        Walllawtoken = IWLW20(address(new WlW()));
        CSRv = address(new CSRvault(address(Walllawtoken),mainnetTurnslideAddr));

        uint256 endDropAt = block.timestamp + 512 days;
        vm.prank(boss);
        WDROP = new WlWDrop( endDropAt, address(Walllawtoken));
    }

    function setUp() public {
        vm.label(address(Walllawtoken), "WALL20");
        vm.label(address(WDROP), "DROP");
    }

    function testWlWDeploys() public {
        assertTrue(Walllawtoken.owner() == boss);
    }

    function testMints() public {
        address[] memory frens = new address[](2);
        uint256[] memory bagsizes = new uint256[](2);

        frens[0] = address(1);
        frens[1] = address(2);

        bagsizes[0] = 1 ether;
        bagsizes[1] = 2 ether;

        assertTrue(Walllawtoken.owner() == boss, "expected to have boss");
        assertTrue(Walllawtoken.balanceOf(frens[1]) + Walllawtoken.balanceOf(frens[0]) == 0, "no balance");

        vm.expectRevert();
        Walllawtoken.onlyOnce(frens, bagsizes, CSRv);

        vm.prank(boss);
        Walllawtoken.onlyOnce(frens, bagsizes, CSRv);

        assertTrue(
            Walllawtoken.balanceOf(frens[1]) + Walllawtoken.balanceOf(frens[0]) == bagsizes[0] * 3, "bags not found"
        );
        assertTrue(Walllawtoken.owner() == address(0), "expected no bossmaam");
    }

    function testSetMerkl() public {
        assertTrue(WDROP.merkleRoot() == bytes32(0));
        vm.expectRevert();
        WDROP.setMerkleRoot(MERKL_ROOT);

        vm.prank(boss);
        WDROP.setMerkleRoot(MERKL_ROOT);

        vm.expectRevert();
        vm.prank(boss);
        WDROP.setMerkleRoot(MERKL_ROOT);

        assertTrue(WDROP.merkleRoot() == MERKL_ROOT, "merkl not set");
    }
}
