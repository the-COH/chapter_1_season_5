// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IMembrane {
    struct Membrane {
        address[] tokens;
        uint256[] balances;
        bytes meta;
    }

    function getMembrane(uint256 id) external view returns (Membrane memory);

    function setMembrane(uint256 membraneID_, address DAO_) external returns (bool);

    function setMembraneEndpoint(uint256 membraneID_, address subDAOaddr, address owner) external returns (bool);

    function inUseMembraneId(address DAOaddress_) external view returns (uint256 Id);

    function inUseUriOf(address DAOaddress_) external view returns (string memory);

    function getInUseMembraneOfDAO(address DAOAddress_) external view returns (Membrane memory);

    function createMembrane(address[] memory tokens_, uint256[] memory balances_, string memory meta_)
        external
        returns (uint256);
    function isMembrane(uint256 id_) external view returns (bool);

    function checkG(address who, address DAO_) external view returns (bool s);

    function gCheck(address who_, address DAO_) external returns (bool);

    function entityData(uint256 id_) external view returns (string memory);
}
