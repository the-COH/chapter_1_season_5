// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./utils/functionality.t.sol";

import "../src/Member1155.sol";
import {WlWDrop} from "../src/Drop.sol";
import {WlW} from "../src/WLW.sol";
import {MiniVest} from "../src/VestMinimal.sol";
import {Turnstile} from "../src/utils/CantoTurnslide.sol";
import {ITurnstile} from "../src/interfaces/ICantoTurnstile.sol";
import {CSRvault} from "../src/CSRVault.sol";

contract WLWtests is Test {
    IWLW20 Walllawtoken;
    address boss;
    WlWDrop WDROP;
    address CSRv;
    MemberRegistry M;
    IoDAO O;
    MiniVest VestMinimal;
    WlWDrop DROP;
    IWLW20 WlWtoken;
    iInstanceDAO CantoBaseDAO;

    uint256 vestingDAOBalance;
    /// 90%
    uint256 airdropBalance;
    /// 5.22% airdrop
    uint256 foundersIfAny;
    /// 4.78% founder bribes

    constructor() {
        boss = 0xb3F204a5F3dabef6bE51015fD57E307080Db6498;
    }

    function setUp() public {
        vm.startPrank(boss);
        skip(1243 * 1 days);
        bytes32 MERKL_ROOT = 0xec8e5b143c9270c14113fb6e8efb0ca800a03419f46c621106efa6093372af2d;
        address mainnetTurnslideAddr = address(new Turnstile());

        WlWtoken = IWLW20(address(new  WlW()));
        vm.label(address(WlWtoken), "wlw token");
        CSRv = address(new CSRvault(address(WlWtoken),mainnetTurnslideAddr));
        M = new MemberRegistry(CSRv);
        vm.label(address(M), "MemberRegistry");
        O = IoDAO(M.ODAOaddress());
        vm.label(address(O), "ODAO");
        // MembraneR = IMembrane(M.MembraneRegistryAddress());
        // vm.label(address(MembraneR),"MembraneRegistry");

        // Turnstile TestnetTurnslide = new Turnstile();
        // ITurnstile MainnetTurnslide = ITurnstile(mainnetTurnslideAddr);

        /// create new dao
        CantoBaseDAO = iInstanceDAO(O.createDAO(address(WlWtoken)));

        uint256 k = 999999999999999999 * 10 ** 18;
        VestMinimal = new MiniVest(k, address(CantoBaseDAO), address(WlWtoken));
        /// int256 _k, address WALLLAW_DAO, address WALLLAW_TOKEN
        vm.label(address(VestMinimal), "VestMinimal");

        uint256 window = ((612 * 1 days) + 1676281337);

        /// setup airdrop
        DROP = new WlWDrop(window, address(WlWtoken));

        /// set merkle root
        DROP.setMerkleRoot(MERKL_ROOT);

        //// define balances
        vestingDAOBalance = 9_000_000;
        /// 90%
        airdropBalance = 522_000;
        /// 5.22% airdrop
        foundersIfAny = 478_000;
        /// 4.78% founder bribes

        address[] memory frens = new address[](3);
        uint256[] memory bagsizes = new uint256[](3);

        frens[0] = address(0xb3F204a5F3dabef6bE51015fD57E307080Db6498);
        WlWtoken.approve(address(VestMinimal), type(uint256).max);
        frens[1] = address(DROP);
        frens[2] = 0xE7b30A037F5598E4e73702ca66A59Af5CC650Dcd;

        bagsizes[0] = vestingDAOBalance * 1 ether;
        bagsizes[1] = airdropBalance * 1 ether;
        bagsizes[2] = foundersIfAny * 1 ether;

        WlWtoken.onlyOnce(frens, bagsizes, CSRv);

        WlWtoken.approve(address(VestMinimal), type(uint256).max);
        /// set linear vest to dao addr 90% (9 mil) over 612 days
        VestMinimal.setVest(address(WlWtoken), address(CantoBaseDAO), vestingDAOBalance, 1825);

        console.log("Member  ______________####_____ : ", address(M));
        console.log("ODAO  ______________####_____ : ", M.ODAOaddress());
        console.log("WalllaW DAO address  ______________####_____ : ", address(CantoBaseDAO));
        // console.log("MembraneR ______________####_____ : ", M.MembraneRegistryAddress());
        console.log("WlW token ______________####_____ : ", address(WlWtoken));
        console.log("DROP ______________####_____ : ", address(DROP));
        console.log("VestMinimal ______________####_____ : ", address(VestMinimal));
        console.log("parseb balance  ______________####_____ : ", WlWtoken.balanceOf(frens[2]));
        // console.log("DAO has vest _______###___(0<?) : ", VestMinimal.getVest(address(WlWtoken), address(CantoBaseDAO)));
        console.log("CSR Vault has vest _______###___(0<?) : ", CSRv);
        console.log("WF base DAO _______###___(0<?) : ", address(CantoBaseDAO));

        vm.stopPrank();
    }

    function testTrue() public {
        assertTrue(true);
    }

    function testVestingBug() public {
        // vm.prank(boss);
        assertTrue(WlWtoken.balanceOf(address(CantoBaseDAO)) == 0, "DAO should not have balance");
        VestMinimal.perSec();
        // skip(100);
        skip(5);

        assertTrue(WlWtoken.balanceOf(address(CantoBaseDAO)) == 0, "DAO should not have balance");
        VestMinimal.withdrawToWallaW();

        skip(365 * 1 days);

        assertTrue(WlWtoken.balanceOf(address(CantoBaseDAO)) > 0, "DAO should not have balance");
        VestMinimal.withdrawToWallaW();

        skip(365 * 1 days);

        assertTrue(WlWtoken.balanceOf(address(CantoBaseDAO)) > 0, "DAO should not have balance");
        VestMinimal.withdrawToWallaW();

        skip(365 * 1 days);

        assertTrue(WlWtoken.balanceOf(address(CantoBaseDAO)) > 0, "DAO should not have balance");
        VestMinimal.withdrawToWallaW();

        skip(365 * 1 days);

        assertTrue(vestingDAOBalance * 1 ether > WlWtoken.balanceOf(address(CantoBaseDAO)), "all transfered wtf");
    }
}
