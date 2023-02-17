// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

import "openzeppelin-contracts/token/ERC20/ERC20.sol";
import "./interfaces/iInstanceDAO.sol";
import "./interfaces/IMember1155.sol";
import "./interfaces/IDAO20.sol";

contract DAO20 is ERC20 {
    address public owner;
    address public base;
    address public burnInProgress;
    IERC20 baseToken;

    constructor(address baseToken_, string memory name_, string memory symbol_, uint8 decimals_)
        ERC20(name_, symbol_)
    {
        owner = msg.sender;
        base = baseToken_;
        baseToken = IERC20(baseToken_);
    }

    error NotOwner();

    modifier OnlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }

    function wrapMint(uint256 amt) external returns (bool s) {
        s = baseToken.transferFrom(msg.sender, owner, amt);
        if (s) {
            //iInstanceDAO(owner).mintInflation(); /// @dev this breaks mint on anvil. also maybe bad idea. @todo
            _mint(msg.sender, amt);
        }
        require(s, "ngmi");
    }

    function unwrapBurn(uint256 amtToBurn_) external returns (bool s) {
        require(balanceOf(msg.sender) >= amtToBurn_, "Insufficient balance");
        require(burnInProgress == address(0), "burnInProgress");
        burnInProgress = msg.sender;
        uint256 amtToRefund = baseToken.balanceOf(owner) * amtToBurn_ / totalSupply();
        _burn(msg.sender, amtToBurn_);
        s = baseToken.transferFrom(owner, msg.sender, amtToRefund);

        if (s) {
            iInstanceDAO(owner).distributiveSignal(new uint256[](0));
            burnInProgress = address(0);
        }
        require(s, "ngmi");
    }

    function unwrapBurn(address from_, uint256 amtToBurn_) external OnlyOwner {
        require(balanceOf(from_) >= amtToBurn_, "Insufficient balance");
        _burn(from_, amtToBurn_);
    }

    function inflationaryMint(uint256 amt) public OnlyOwner returns (bool) {
        _mint(owner, amt);
        return true;
    }

    function mintInitOne(address to_) external returns (bool) {
        require(msg.sender == owner, "ngmi");
        _mint(to_, 1);
        return balanceOf(to_) == 1;
    }

    /// ////////////////////

    /// Override //////////////

    //// @dev @security DAO token should be transferable only to DAO instances or owner (resource basket multisig)
    /// there's some potential attack vectors on inflation and redistributive signals (re-enterange like)
    /// two options: embrace the messiness |OR| allow transfers only to owner and sub-entities

    function transfer(address to, uint256 amount) public override returns (bool) {
        /// limit transfers
        bool o = msg.sender == owner;
        address parent = iInstanceDAO(owner).parentDAO();
        o = !o ? parent == msg.sender : o;
        o = !o ? to == iInstanceDAO(msg.sender).endpoint() : o;

        // o = !o ? iInstanceDAO(iInstanceDAO(owner).parentDAO()).isMember(msg.sender) : o;
        // o = !o ? (parent == address(0)) && (msg.sig == this.wrapMint.selector) : o;
        // o = !o ? (iInstanceDAO(owner).baseTokenAddress() == msg.sender ) : o;

        require(o, "unauthorized - transfer");
        return super.transfer(to, amount);
    }

    function transferFrom(address from, address to, uint256 amount) public override returns (bool) {
        /// limit transfers
        bool o = msg.sender == owner;
        o = !o ? iInstanceDAO(owner).parentDAO() == msg.sender : o;
        o = !o ? (IDAO20(msg.sender).base() == address(this)) : o;
        require(o, "unauthorized - transferFrom");

        if (from == owner) _mint(owner, amount);
        require(super.transferFrom(from, to, amount));
        return true;
    }

    // function _balanceOf(address who_) external returns (uint) {
    //     return balanceOf[who_];
    // }

    // function _totalSupply() external returns (uint) {
    //     return this.totalSupply;
    // }
}
