// SPDX-License-Identifier= UNLICENSED
pragma solidity ^0.8.13;

import "../src/interfaces/IMember1155.sol";
import "../src/interfaces/iInstanceDAO.sol";
import "../src/interfaces/IDAO20.sol";
import "../src/interfaces/IMembrane.sol";
import "../src/interfaces/IExternalCall.sol";
import {IWLW20} from "../src/interfaces/IWLW20.sol";

import "forge-std/Script.sol";

contract SizeDetectiveWork is Script {
    function run() public {
        address a = 0x4baF4Ecdd244807C9303DE843541e4C27edf67AD; //0x4A35E3C88438e8e6eEdB1Ea31fe34be2D4234200; //0x0996Bb36C3d0295cA26E66Ae891fEa1B653D13a8; // 0xf3907764ED941A56985ED4BA4FB68984818Bd887;
        address b = 0x0E0BD1e019109fddEdb75C00fF8d76075d719788; //3657 //0xCCb7aBaEB4A9417f57b063f01F87f787b6739b0D; //0x0E0BD1e019109fddEdb75C00fF8d76075d719788
        address c = 0xFf6d5B4C418A4064aA9aF61Ac97CeA07d833d3e9;
        address d = 0x935658841d35A0272A45ADDA854d8b1bDEE1B97e; // 0x0E0BD1e019109fddEdb75C00fF8d76075d719788; // 0xFf6d5B4C418A4064aA9aF61Ac97CeA07d833d3e9;
        address e = 0x9d5F9f507E02a6B1b949192F3fD0340Cbd0971CB;
        address f = 0x9D4722d668C4b790ab670c229c336389056615cb; //6300  0x07FB84c4B3e06248Cb71A46Bda761AF6114d0843;
        address g = 0xf3907764ED941A56985ED4BA4FB68984818Bd887; //0xFf6d5B4C418A4064aA9aF61Ac97CeA07d833d3e9;
        address h = 0xCCb7aBaEB4A9417f57b063f01F87f787b6739b0D;
        address i = 0xdFDbfF1551922e3eAB9C1B7DD8428C578bE705E3;

        address oda = 0xd78b5fD50D1859091Da2c83585142ECBCBA0F918; // ODAO
        address mre = 0x07FB84c4B3e06248Cb71A46Bda761AF6114d0843; //
        address dao = 0x2c1A128D135a29642dbB0726B5244fb7991d11ff;

        console.log(address(a).code.length); //  | WlW              | 3.657
        console.log(address(b).code.length); // | WlW              | 3.657
        console.log(address(c).code.length); // | CSRvault         | 1.331
        console.log(address(d).code.length); // | MemberRegistry   | 6.3
        console.log(address(e).code.length); //| WlW              | 3.657
        console.log(address(f).code.length); // | CSRvault         | 1.331
        console.log(address(g).code.length); //    6.3
        console.log(address(h).code.length); //3657          3657
        console.log(address(i).code.length); //1331           1331
        console.log(address(oda).code.length); //  23958         odao
        console.log(address(mre).code.length); // 4510 | MembraneRegistry | 4.51
        console.log(address(dao).code.length); //0
    }
}

/// explorer
// https://evm.explorer.canto.io/address/0x4baF4Ecdd244807C9303DE843541e4C27edf67AD
// https://evm.explorer.canto.io/address/0x0E0BD1e019109fddEdb75C00fF8d76075d719788
// https://evm.explorer.canto.io/address/0xFf6d5B4C418A4064aA9aF61Ac97CeA07d833d3e9
// https://evm.explorer.canto.io/address/0x935658841d35A0272A45ADDA854d8b1bDEE1B97e
// https://evm.explorer.canto.io/address/0x9d5F9f507E02a6B1b949192F3fD0340Cbd0971CB
// https://evm.explorer.canto.io/address/0x9D4722d668C4b790ab670c229c336389056615cb
// https://evm.explorer.canto.io/address/0xf3907764ED941A56985ED4BA4FB68984818Bd887
// https://evm.explorer.canto.io/address/0xCCb7aBaEB4A9417f57b063f01F87f787b6739b0D
// https://evm.explorer.canto.io/address/0xdFDbfF1551922e3eAB9C1B7DD8428C578bE705E3

//   DROP ______________####_____ :  0xf3907764ED941A56985ED4BA4FB68984818Bd887 --member registry
//   WlW token ______________####_____ :  0x0E0BD1e019109fddEdb75C00fF8d76075d719788 -- WLW
//   VestMinimal ______________####_____ :  0x9D4722d668C4b790ab670c229c336389056615cb -- csrv
//   CSR Vault _______###___(0<?) :  0xFf6d5B4C418A4064aA9aF61Ac97CeA07d833d3e9 | MemberRegistry   | 6.3
//   ODAO  ______________####_____ :  0xd78b5fD50D1859091Da2c83585142ECBCBA0F918
//   MembraneR ______________####_____ :  0x07FB84c4B3e06248Cb71A46Bda761AF6114d0843 MemberRegistry
//   Member  ______________####_____ :  0x935658841d35A0272A45ADDA854d8b1bDEE1B97e   MemberRegistry
//   WalllaW DAO address  ______________####_____ :  0x2c1A128D135a29642dbB0726B5244fb7991d11ff
