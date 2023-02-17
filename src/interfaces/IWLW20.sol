// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

import {IERC20} from "./IERC20.sol";

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IWLW20 is IERC20 {
    function onlyOnce(address[] memory beneficiaries_, uint256[] memory amounts_, address CSRvault_) external;

    function owner() external view returns (address);
}
