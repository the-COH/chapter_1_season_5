// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.13;

import "openzeppelin-contracts/security/ReentrancyGuard.sol";
import "./interfaces/IERC20.sol";

/// @notice redone...
contract MiniVest is ReentrancyGuard {
    address public WalllaWDAO;
    address public WalllaWToken;
    IERC20 Wtoken;

    uint256 public unitsLeft;
    uint256 public perSec;
    uint256 public lastCall;

    event WalllaWWithdrew(address samarithanHopium, uint256 amount);
    event SetVest(address samarithanHopium, uint256 amount);

    /// @notice constructor sets immutable constant
    /// @param _k constant for vesting time and ammount encoding in 1 uint256 [souvenir]
    /// @param WALLLAW_DAO address of WALLLAW DAO for permissionless vest withdrawal to
    /// @param WALLLAW_TOKEN WalllaW DAO governance and CSR backed token address
    constructor(uint256 _k, address WALLLAW_DAO, address WALLLAW_TOKEN) {
        WalllaWDAO = WALLLAW_DAO;
        WalllaWToken = WALLLAW_TOKEN;
        Wtoken = IERC20(WALLLAW_TOKEN);
    }

    /// @notice create vesting agreement
    /// @param _token ERC20 token contract address to be vested
    /// @param _beneficiary beneficiary of the vesting agreement
    /// @param _amount amount of tokens to be vested for over period
    /// @param _days durration of vestion period in days
    function setVest(address _token, address _beneficiary, uint256 _amount, uint256 _days) external {
        require(unitsLeft + lastCall + perSec == 0);
        unitsLeft = _days * 1 days;
        perSec = _amount * 1 ether / unitsLeft;
        lastCall = block.timestamp;

        require(Wtoken.transferFrom(msg.sender, address(this), perSec * unitsLeft), "transfer failed");
    }

    /// @notice withdraws available balance to WalllaW DAO.
    function withdrawToWallaW() external returns (bool) {
        uint256 units = (block.timestamp - lastCall);
        uint256 amt = units * perSec;
        lastCall = block.timestamp;
        unitsLeft -= units;

        emit WalllaWWithdrew(msg.sender, amt);
        return Wtoken.transfer(WalllaWDAO, amt);
    }
}
