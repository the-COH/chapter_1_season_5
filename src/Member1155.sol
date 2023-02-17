// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./oDAO.sol";
import "./MembraneRegistry.sol";
import "./ExternalCall.sol";

import "solmate/tokens/ERC1155.sol";
import "./interfaces/IoDAO.sol";
import "./interfaces/iInstanceDAO.sol";
import "./interfaces/IMembrane.sol";

contract MemberRegistry is ERC1155 {
    address public ODAOaddress;
    address public MembraneRegistryAddress;
    address public ExternalCallAddress;

    IoDAO oDAO;
    IMembrane IMB;
    // address[] private roots;
    // address[] private endpoints;
    mapping(address => address[]) endpointsOf;
    mapping(uint256 => string) tokenUri;
    mapping(uint256 => uint256) uidTotalSupply;
    mapping(address => uint256[]) idsOf;

    constructor(address CSRV_) {
        ODAOaddress = address(new ODAO(CSRV_));
        MembraneRegistryAddress = address(new MembraneRegistry(ODAOaddress));
        ExternalCallAddress = address(new ExternalCall(ODAOaddress));
        oDAO = IoDAO(ODAOaddress);
        IMB = IMembrane(MembraneRegistryAddress);
    }

    /*//////////////////////////////////////////////////////////////
                                 errors
    //////////////////////////////////////////////////////////////*/

    error MR1155_Untransferable();
    error MR1155_onlyOdao();
    error MR1155_UnregisteredDAO();
    error MR1155_UnauthorizedID();
    error MR1155_InvalidMintID();
    error MR1155_AlreadyIn();
    error MR1155_OnlyMembraneRegistry();
    error MR1155_OnlyODAO();

    modifier onlyDAO() {
        if (!oDAO.isDAO(msg.sender)) revert MR1155_UnregisteredDAO();
        _;
    }

    modifier onlyMembraneR() {
        if (msg.sender != MembraneRegistryAddress) revert MR1155_OnlyMembraneRegistry();
        _;
    }
    /*//////////////////////////////////////////////////////////////
                                 events
    //////////////////////////////////////////////////////////////*/

    event isNowMember(address who, uint256 id, address dao);

    /*//////////////////////////////////////////////////////////////
                                 external
    //////////////////////////////////////////////////////////////*/

    /// mints membership token to provided address

    function makeMember(address who_, uint256 id_) external onlyDAO returns (bool) {
        /// the id_ of any subunit  is a multiple of DAO address
        if (!(id_ % uint160(bytes20(msg.sender)) == 0)) {
            /// @dev
            revert MR1155_InvalidMintID();
        }
        /// does not yet have member token
        if (balanceOf[who_][id_] > 0) revert MR1155_AlreadyIn();

        /// if first member to join, fetch cell metadata
        /// @todo get membrane meta or dao specific metadata
        // if (tokenUri[id_].length == 0) tokenUri[id_] = oDAO.entityData(id_);

        /// mint membership token
        _mint(who_, id_, 1, abi.encode(tokenUri[id_]));
        idsOf[who_].push(id_);

        emit isNowMember(who_, id_, msg.sender);
        return balanceOf[who_][id_] == 1;
    }

    function setUri(string memory uri_) external onlyDAO {
        tokenUri[uint160(bytes20(msg.sender))] = uri_;
    }

    /*//////////////////////////////////////////////////////////////
                                 view
    //////////////////////////////////////////////////////////////*/

    function uri(uint256 id) public view override returns (string memory) {
        return tokenUri[id];
    }

    function getUriOf(address who_) external view returns (string memory) {
        return tokenUri[uint160(bytes20(who_))];
    }

    /// retrieves base DAOs
    // function getRoots(uint256 howMany_) external view returns (address[] memory r) {
    //     if (roots.length < howMany_) howMany_ = endpoints.length;

    //     uint256 i;
    //     r = new address[](howMany_);
    //     for (i; i < howMany_;) {
    //         r[i] = roots[i];
    //         unchecked {
    //             i++;
    //         }
    //     }
    // }

    // function getEndpoints(uint256 howMany_) external view returns (address[] memory r) {
    //     if (endpoints.length < howMany_) howMany_ = endpoints.length;

    //     uint256 i;
    //     r = new address[](howMany_);
    //     for (i; i < howMany_;) {
    //         r[i] = endpoints[i];
    //         unchecked {
    //             i++;
    //         }
    //     }
    // }

    function getActiveMembershipsOf(address who_) external view returns (address[] memory entities) {
        uint256[] memory ids = idsOf[who_];
        uint256 i;
        entities = new address[](ids.length);
        for (i; i < ids.length;) {
            if (balanceOf[who_][ids[i]] > 0) entities[i] = address(uint160(ids[i]));
            unchecked {
                i++;
            }
        }
    }

    function pushIsEndpointOf(address dao_, address endpointOwner_) external {
        if (msg.sender != ODAOaddress) revert MR1155_OnlyODAO();
        // endpoints.push(dao_);
        endpointsOf[endpointOwner_].push(dao_);
    }

    // function pushAsRoot(address dao_) external {
    //     if (msg.sender != ODAOaddress) revert MR1155_OnlyODAO();
    //     // roots.push(dao_);
    // }

    /*//////////////////////////////////////////////////////////////
                                 override
    //////////////////////////////////////////////////////////////*/

    function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data)
        public
        override
    {
        if (from != address(0) || to != address(0)) revert MR1155_Untransferable();

        super.safeTransferFrom(from, to, id, amount, data);
    }

    /// @notice custom burn for gCheck functionality
    function gCheckBurn(address who_, address DAO_) external onlyMembraneR returns (bool) {
        uint256 id_ = uint160(bytes20(DAO_));
        _burn(who_, id_, balanceOf[who_][id_]);
        iInstanceDAO(DAO_).gCheckPurge(who_);
        return balanceOf[who_][id_] == 0;
    }

    /// @notice how many tokens does the given id_ has. Useful for checking how many members a DAO has.
    /// @notice id_ is always the uint(address of DAO)
    /// @param id_ id to check how many minted tokens it has associated
    function howManyTotal(uint256 id_) public view returns (uint256) {
        return uidTotalSupply[id_];
    }

    function _mint(address to, uint256 id, uint256 amount, bytes memory data) internal override {
        super._mint(to, id, amount, data);
        uidTotalSupply[id] += 1;
    }

    function _burn(address from, uint256 id, uint256 amount) internal override {
        super._burn(from, id, amount);
        uidTotalSupply[id] -= 1;
    }

    function _batchBurn(address from, uint256[] memory ids, uint256[] memory amounts) internal override {
        revert("_batchBurn");
    }

    function _batchMint(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        internal
        override
    {
        revert("_batchMint");
    }

    function getEndpointsOf(address ofWhom_) external view returns (address[] memory) {
        return endpointsOf[ofWhom_];
    }

    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] calldata ids,
        uint256[] calldata amounts,
        bytes calldata data
    ) public override {
        revert("safeBatchTransferFrom");
    }
}
