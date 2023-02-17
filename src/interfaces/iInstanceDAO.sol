// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface iInstanceDAO {
    function signalInflation(uint256 percentagePerYear_) external returns (uint256 inflationRate);

    function mintMembershipToken(address to_) external returns (bool);

    function changeMembrane(uint256 membraneId_) external returns (uint256 membraneID);

    function executeCall(uint256 externalCallId) external returns (uint256);

    function distributiveSignal(uint256[] memory cronoOrderedDistributionAmts) external returns (uint256);

    function multicall(bytes[] memory) external returns (bytes[] memory results);

    function executeExternalLogic(uint256 callId_) external returns (bool);

    function feedMe() external returns (uint256);

    function redistributeSubDAO(address subDAO_) external returns (uint256);

    function mintInflation() external returns (uint256);

    function feedStart() external returns (uint256 minted);

    function withdrawBurn(uint256 amt_) external returns (uint256 amtWithdrawn);

    function gCheckPurge(address who_) external;

    /// only MR

    // function cleanIndecisionLog() external;

    /// view

    function getActiveIndecisions() external view returns (uint256[] memory);

    function stateOfExpressed(address user_, uint256 prefID_) external view returns (uint256[3] memory pref);

    function internalTokenAddress() external view returns (address);

    function endpoint() external view returns (address);

    function baseTokenAddress() external view returns (address);

    function baseID() external view returns (uint256);

    function instantiatedAt() external view returns (uint256);

    function getUserReDistribution(address ofWhom) external view returns (uint256[] memory);

    function baseInflationRate() external view returns (uint256);

    function baseInflationPerSec() external view returns (uint256);

    function isMember(address who_) external view returns (bool);

    function parentDAO() external view returns (address);

    function getILongDistanceAddress() external view returns (address);

    function uri() external view returns (string memory);
}
