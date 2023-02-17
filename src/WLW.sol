// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

import "openzeppelin-contracts/token/ERC20/ERC20.sol";
import "./interfaces/ICantoTurnstile.sol";
import "./interfaces/ICSRvault.sol";

contract WlW is ERC20("WalllaW", "WF") {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    event onlyOnceInLifetime(address indexed caller_, uint256 amountMinted_, address currentOwner_);

    error WlWmint__GotAddr0();

    //// @notice given addresses and balances iterates and mints, for each address, the corresponding balance
    /// @notice beneficiaries must equal corrsponding ammounts
    /// @param beneficiaries_ addresses to mint amounts to
    /// @param amounts_ how much for each beneficiaries_
    /// @param CSRVault_ address of CSR vault that injects value in token
    function onlyOnce(address[] memory beneficiaries_, uint256[] memory amounts_, address CSRVault_) external {
        require(beneficiaries_.length == amounts_.length, "lenMismatch");
        require(msg.sender == owner, "no");
        delete owner;

        uint256 a;
        for (a; a < beneficiaries_.length;) {
            _mint(beneficiaries_[a], amounts_[a]);
            unchecked {
                ++a;
            }
        }
        require(a >= 2, "at least 2 beneficiaries");
        a = totalSupply();

        ITurnstile(ICSRvault(CSRVault_).turnSaddr()).assign(ICSRvault(CSRVault_).CSRtokenID());

        emit onlyOnceInLifetime(msg.sender, a, owner);
    }
}
