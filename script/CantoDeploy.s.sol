// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../src/Member1155.sol";
import {WlWDrop} from "../src/Drop.sol";
import {WlW} from "../src/WLW.sol";
import {WlW} from "../src/WLW.sol";
import {MiniVest} from "../src/VestMinimal.sol";
import {Turnstile} from "../src/utils/CantoTurnslide.sol";
import {ITurnstile} from "../src/interfaces/ICantoTurnstile.sol";
import {CSRvault} from "../src/CSRVault.sol";

import "forge-std/Script.sol";

contract LocalDeploy is Script {
    MemberRegistry M;
    IoDAO O;
    iInstanceDAO instance;
    IMembrane MembraneR;
    WlWDrop DROP;
    WlW WlWtoken;
    MiniVest VestMinimal;

    address mainnetTurnslideAddr = 0xEcf044C5B4b867CFda001101c617eCd347095B44;

    function run() public {
        // vm.startBroadcast(vm.envUint("ANVIL_1")); //// start 1
        // payable(address(0xb3F204a5F3dabef6bE51015fD57E307080Db6498)).send(1 ether);
        // vm.stopBroadcast();
        vm.startBroadcast(vm.envUint("GOERLI_PVK")); //// start 1

        //// ____

        bytes32 MERKL_ROOT = 0xec8e5b143c9270c14113fb6e8efb0ca800a03419f46c621106efa6093372af2d;
        //address mainnetTurnslideAddr = address(new Turnstile());

        WlWtoken = new  WlW();
        vm.label(address(WlWtoken), "wlw token");
        address CSRv = address(new CSRvault(address(WlWtoken),mainnetTurnslideAddr));
        M = new MemberRegistry(CSRv);
        vm.label(address(M), "MemberRegistry");
        O = IoDAO(M.ODAOaddress());
        vm.label(address(O), "ODAO");
        // MembraneR = IMembrane(M.MembraneRegistryAddress());
        // vm.label(address(MembraneR),"MembraneRegistry");

        // Turnstile TestnetTurnslide = new Turnstile();
        // ITurnstile MainnetTurnslide = ITurnstile(mainnetTurnslideAddr);

        /// create new dao
        iInstanceDAO CantoBaseDAO = iInstanceDAO(O.createDAO(address(WlWtoken)));

        uint256 k = 99999999999999999 * 10 ** 18;
        VestMinimal = new MiniVest(k, address(CantoBaseDAO), address(WlWtoken));
        /// int256 _k, address WALLLAW_DAO, address WALLLAW_TOKEN
        vm.label(address(VestMinimal), "VestMinimal");

        uint256 window = ((612 * 1 days) + 1676281337);

        /// setup airdrop
        DROP = new WlWDrop(window, address(WlWtoken));

        /// set merkle root
        DROP.setMerkleRoot(MERKL_ROOT);

        //// define balances
        uint256 vestingDAOBalance = 9_000_000;
        /// 90%
        uint256 airdropBalance = 522_000;
        /// 5.22% airdrop
        uint256 foundersIfAny = 478_000;
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

        console.log("DROP ______________####_____ : ", address(DROP));
        console.log("WlW token ______________####_____ : ", address(WlWtoken));
        console.log("VestMinimal ______________####_____ : ", address(VestMinimal));
        console.log("CSR Vault _______###___(0<?) : ", CSRv);
        console.log("ODAO  ______________####_____ : ", M.ODAOaddress());
        console.log("MembraneR ______________####_____ : ", M.MembraneRegistryAddress());

        console.log("Member  ______________####_____ : ", address(M));
        console.log("WalllaW DAO address  ______________####_____ : ", address(CantoBaseDAO));
        console.log("parseb balance  ______________####_____ : ", WlWtoken.balanceOf(frens[2]));
        console.log("DAO has vest _______###___(persec) : ", VestMinimal.perSec());
    }
}
