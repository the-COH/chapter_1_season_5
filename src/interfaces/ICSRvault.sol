// SPDX-License-Identifier: GPLv3
pragma solidity 0.8.13;

/// @notice Implementation of CIP-001 https://github.com/Canto-Improvement-Proposals/CIPs/blob/main/CIP-001.md
/// @dev Every contract is responsible to register itself in the constructor by calling `register(address)`.
///      If contract is using proxy pattern, it's possible to register retroactively, however past fees will be lost.
///      Recipient withdraws fees by calling `withdraw(uint256,address,uint256)`.
interface ICSRvault {
    function CSRtokenID() external returns (uint256);

    function selfRegister() external returns (bool);

    function withdrawBurn(uint256 amt) external returns (bool);

    function turnSaddr() external returns (address);

    function sharesTokenAddr() external view returns (address);
}
