// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// import "solmate/tokens/ERC20.sol";
import "openzeppelin-contracts/token/ERC20/ERC20.sol";

contract M202 is ERC20("Mockv2", "M22") {
    address deployer = address(4896);
    address Agent1 = address(16);
    address Agent2 = address(32);
    address Agent3 = address(48);
    address add1 = 0xb3F204a5F3dabef6bE51015fD57E307080Db6498;
    address add2 = 0x65Cf1e0f55BD97696ce430aAcC97b5E7831E0fC2;
    address add3 = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    address anvil_1 = 0x01aFf83D7e116CFf1567DF3916Fae80AbE4AE643;
    address anvil_2 = 0x5457d92f47212E9287c1A1c31e708f574ab66125;
    address anvil_3 = 0x323525cB37428d72e33B8a3d9a72F848d08Bf2B7;
    address anvil_4 = 0x5df6cF21815ca55057bb5cA159A3130c193bb0a1;
    address anvil_5 = 0xEdc4E5c7FfAD492dE7c0c5889986aD3e8B578627;

    constructor() {
        _mint(address(0xb3F204a5F3dabef6bE51015fD57E307080Db6498), 10_000_000 ether);
        _mint(msg.sender, 1_000_000 ether);
        _mint(deployer, 400_000 ether);
        _mint(Agent1, 100_000 ether);
        _mint(add1, 100_000 ether);
        _mint(add2, 100_000 ether);
        _mint(add3, 100_000 ether);
        _mint(Agent2, 200_000 ether);
        _mint(Agent3, 300_000 ether);
        _mint(anvil_1, 100_000 ether);
        _mint(anvil_2, 100_000 ether);
        _mint(anvil_3, 100_000 ether);
        _mint(anvil_4, 200_000 ether);
        _mint(anvil_5, 300_000 ether);
        _mint(address(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266), 200_000 ether);
    }
}
