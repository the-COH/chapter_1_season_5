// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract MExtCallBool {
    address public initiator;
    mapping(address => bool) agentSwitch;

    constructor() {
        initiator = msg.sender;
    }

    function flipSwitch() external returns (bool) {
        agentSwitch[msg.sender] = !agentSwitch[msg.sender];
    }

    function getSwitchStateOf(address ofWhom_) external view returns (bool) {
        return agentSwitch[ofWhom_];
    }
}
