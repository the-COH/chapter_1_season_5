// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IMiniVest {
    /// @notice create vesting agreement
    /// @param _token ERC20 token contract address to be vested
    /// @param _beneficiary beneficiary of the vesting agreement
    /// @param _amount amount of tokens to be vested for over period
    /// @param _days durration of vestion period in days
    function setVest(address _token, address _beneficiary, uint256 _amount, uint256 _days) external returns (bool);

    /// @notice withdraws all tokens that have vested for given ERC20 contract address and _msgSender()
    /// @param _token ERC20 contract of token to be withdrawn
    function withdrawAvailable(address _token) external returns (bool);

    /// @notice withdraws available balance to WalllaW DAO.
    function withdrawToWallaW() external returns (bool);

    function WalllaWDAO() external returns (address);

    function WalllaWToken() external returns (address);
}
