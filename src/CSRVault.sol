// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// import "./interfaces/IMember1155.sol";
// import "./interfaces/IoDAO.sol";
// import "./interfaces/iInstanceDAO.sol";
// import "./interfaces/IMembrane.sol";
// import "./interfaces/IExternalCall.sol";
// import "./utils/Address.sol";
// import "./DAO20.sol";
// import "./errors.sol";

import "./interfaces/IERC20.sol";
import "./interfaces/ICantoTurnstile.sol";

/// @notice CSRVault accumulates CANTO from CSR and makes it redeamable in exchange for the burning of one known and FRIENDLY (@security) token.

contract CSRvault {
    uint256 public CSRtokenID;
    address public turnSaddr;
    address public sharesTokenAddr;

    IERC20 WrapperToken;
    ITurnstile CSR;

    error CSRvault__NotSelfRegistered();
    error CSRvault__NotContract();
    error CSRvault__NonReentrant();

    /// @param sharesToken_ token that acts as fungible redeamable shares for available Canto CSR revenue
    /// @param turnstileAddress_ canto CSR turnstile address
    constructor(address sharesToken_, address turnstileAddress_) {
        WrapperToken = IERC20(sharesToken_);
        CSR = ITurnstile(turnstileAddress_);
        CSRtokenID = CSR.register(address(this));
        turnSaddr = turnstileAddress_;
        sharesTokenAddr = sharesToken_;
    }

    function withdrawBurn(uint256 amountToBurn) public returns (bool s) {
        s = WrapperToken.transferFrom(msg.sender, address(this), amountToBurn);
        CSR.distributeFees(CSRtokenID);
        CSR.withdraw(CSRtokenID, payable(address(this)), CSR.balances(CSRtokenID));

        amountToBurn = (amountToBurn * 1_000_000_000 * address(this).balance)
            / (WrapperToken.totalSupply() - WrapperToken.balanceOf(address(this))) / 1_000_000_000;
        s = s && payable(msg.sender).send(amountToBurn);
        require(s, "transfer or qty issue");
    }
}
