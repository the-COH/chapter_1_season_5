// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// import "solmate/tokens/ERC20.sol";
import "openzeppelin-contracts/token/ERC20/ERC20.sol";

contract MKR is ERC20("MakerDAO", "MKR") {
    address vest1 = 0xb3F204a5F3dabef6bE51015fD57E307080Db6498;
    address vr = 0xb3F204a5F3dabef6bE51015fD57E307080Db6498;
    address parseb = 0xE7b30A037F5598E4e73702ca66A59Af5CC650Dcd;

    constructor() {
        _mint(vest1, 100_000 ether);
        _mint(vr, 200_000 ether);
        _mint(parseb, 220_000 ether);
    }
}
