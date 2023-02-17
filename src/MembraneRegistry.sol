// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./interfaces/IoDAO.sol";
import "./interfaces/iInstanceDAO.sol";
import "./interfaces/IMembrane.sol";
import "./interfaces/IMember1155.sol";

import "openzeppelin-contracts/token/ERC20/IERC20.sol";
import "./errors.sol";

contract MembraneRegistry {
    address MRaddress;
    IoDAO ODAO;
    IMemberRegistry iMR;

    mapping(uint256 => Membrane) getMembraneById;
    mapping(address => uint256) usesMembrane;

    constructor(address ODAO_) {
        iMR = IMemberRegistry(msg.sender);
        ODAO = IoDAO(ODAO_);
    }

    error Membrane__membraneNotFound();
    error Membrane__aDAOnot();
    error Membrane__ExpectedODorD();
    error Membrane__MembraneChangeLimited();
    error Membrane__EmptyFieldOnMembraneCreation();
    error Membrane__onlyODAOToSetEndpoint();
    error Membrane__SomethingWentWrong();

    event CreatedMembrane(uint256 id, string metadata);
    event ChangedMembrane(address they, uint256 membrane);
    event gCheckKick(address indexed who);

    /// @notice creates membrane. Used to control and define.
    /// @notice To be read and understood as: Givent this membrane, of each of the tokens_[x], the user needs at least balances_[x].
    /// @param tokens_ ERC20 or ERC721 token addresses array. Each is used as a constituent item of the membrane and condition for
    /// @param tokens_ belonging or not. Membership is established by a chain of binary claims whereby
    /// @param tokens_ the balance of address checked needs to satisfy all balances_ of all tokens_ stated as benchmark for belonging
    /// @param balances_ amounts required of each of tokens_. The order of required balances needs to map to token addresses.
    /// @param meta_ anything you want. Preferably stable CID for reaching aditional metadata such as an IPFS hash of type string.
    function createMembrane(address[] memory tokens_, uint256[] memory balances_, string memory meta_)
        public
        returns (uint256 id)
    {
        /// @dev consider negative as feature . [] <- isZero. sybil f
        /// @dev @security erc165 check
        if (!((tokens_.length / balances_.length) * bytes(meta_).length >= 1)) {
            revert Membrane__EmptyFieldOnMembraneCreation();
        }
        Membrane memory M;
        M.tokens = tokens_;
        M.balances = balances_;
        M.meta = meta_;
        id = uint256(keccak256(abi.encode(M))) % 1 ether;
        getMembraneById[id] = M;

        emit CreatedMembrane(id, meta_);
    }

    function setMembrane(uint256 membraneID_, address dao_) external returns (bool) {
        if ((msg.sender != dao_) && (msg.sender != address(ODAO))) revert Membrane__MembraneChangeLimited();
        if (getMembraneById[membraneID_].tokens.length == 0) revert Membrane__membraneNotFound();

        usesMembrane[dao_] = membraneID_;
        emit ChangedMembrane(dao_, membraneID_);
        return true;
    }

    function setMembraneEndpoint(uint256 membraneID_, address dao_, address owner_) external returns (bool) {
        if (msg.sender != address(ODAO)) revert Membrane__onlyODAOToSetEndpoint();
        if (address(uint160(membraneID_)) == owner_) {
            if (bytes(getMembraneById[membraneID_].meta).length == 0) {
                Membrane memory M;
                M.meta = "endpoint";
                getMembraneById[membraneID_] = M;
            }
            usesMembrane[dao_] = membraneID_;
            return true;
        } else {
            revert Membrane__SomethingWentWrong();
        }
    }

    /// @notice checks if a given address is member in a given DAO.
    /// @notice answers: Does who_ belong to DAO_?
    /// @param who_ what address to check
    /// @param DAO_ in what DAO or subDAO do you want to check if who_ b
    function checkG(address who_, address DAO_) public view returns (bool s) {
        Membrane memory M = getInUseMembraneOfDAO(DAO_);
        uint256 i;
        s = true;
        for (i; i < M.tokens.length;) {
            s = s && (IERC20(M.tokens[i]).balanceOf(who_) >= M.balances[i]);
            unchecked {
                ++i;
            }
        }
    }

    //// @notice checks if a given address (who_) is a member in the given (dao_). Same as checkG()
    ///  @notice if any of the balances checks specified in the membrane fails, the membership token of checked address is burned
    /// @notice this is a defensive, think auto-imune mechanism.
    /// @param who_ checked address
    /// @dev @todo retrace once again gCheck. Consider spam vectors.
    function gCheck(address who_, address DAO_) external returns (bool s) {
        if (iMR.balanceOf(who_, uint160(bytes20(DAO_))) == 0) return false;
        s = checkG(who_, DAO_);
        if (s) return true;
        if (!s) iMR.gCheckBurn(who_, DAO_);

        //// removed liquidate on kick . this burns membership token but lets user own internaltoken. @security consider

        emit gCheckKick(who_);
    }

    /// @notice returns the meta field of a membrane given its id
    /// @param id_ membrane id_
    function entityData(uint256 id_) external view returns (string memory) {
        return getMembraneById[id_].meta;
    }

    /// @notice returns the membrane given its id_
    /// @param id_ id of membrane you want fetched
    /// @return Membrane struct
    function getMembrane(uint256 id_) external view returns (Membrane memory) {
        return getMembraneById[id_];
    }

    /// @notice checks if a given id_ belongs to an instantiated membrane
    function isMembrane(uint256 id_) external view returns (bool) {
        return (getMembraneById[id_].tokens.length > 0);
    }

    /// @notice fetches the id of the active membrane for given provided DAO adress. Returns 0x0 if none.
    /// @param DAOaddress_ address of DAO (or subDAO) to retrieve mebrane id of
    function inUseMembraneId(address DAOaddress_) public view returns (uint256 ID) {
        return usesMembrane[DAOaddress_];
    }

    /// @notice fetches the in use membrane of DAO
    /// @param DAOAddress_ address of DAO (or subDAO) to retrieve in use Membrane of given DAO or subDAO address
    /// @return Membrane struct
    function getInUseMembraneOfDAO(address DAOAddress_) public view returns (Membrane memory) {
        return getMembraneById[usesMembrane[DAOAddress_]];
    }

    /// @notice returns the uri or CID metadata of given DAO address
    /// @param DAOaddress_ address of DAO to fetch `.meta` of used membrane
    /// @return string
    function inUseUriOf(address DAOaddress_) external view returns (string memory) {
        return getInUseMembraneOfDAO(DAOaddress_).meta;
    }
}
