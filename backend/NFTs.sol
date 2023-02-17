// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "@openzeppelin/contracts@4.7.3/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.7.3/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts@4.7.3/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts@4.7.3/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract CantoLegends is ERC721, ERC721Enumerable, ERC721Burnable, Ownable, ReentrancyGuard {

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////// For Canto Mainnet //////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    using Strings for uint256;
    string public _name = "Canto Legends";
    string public _symbol = "CLG";
    uint256 public supply;
    // address public teamAddress = payable();
    uint256 public cost = 1 * 10 ** 18;
    uint256 public maxSupply = 50; 
    bool public paused = false;
    string public baseURI = "https://storage.fleek.zone/e2fdad04-83fb-4c64-8a56-a7490cd84eb2-bucket/stats/";
    string public baseExtension = ".json";
    // bool public revealed = true;
    // string public notRevealedUri;

    constructor() ERC721(_name, _symbol) {
        // setBaseURI(_initBaseURI);
        // setNotRevealedURI(_initNotRevealedUri);
    }

    struct Fighter {
        uint256 ID;
        uint256 HP;
        uint256 Energy;
        string Weakness;
    }

    struct Attack1 {
        uint256 ID;
        string Name;
        uint256 Dmg;
        uint256 NrgCost;
        string Type;
    }

    struct Attack2 {
        uint256 ID;
        string Name;
        uint256 Dmg;
        uint256 NrgCost;
        string Type;
    }

    struct Attack3 {
        uint256 ID;
        string Name;
        uint256 HpGain;
        uint256 NrgCost;
        string Type;
    }

    struct Attack4 {
        uint256 ID;
        string Name;
        uint256 NrgGain;
        string Type;
    }

    mapping(uint256 => Fighter) public FighterMapping;
    mapping(uint256 => Attack1) public Attack1Mapping;
    mapping(uint256 => Attack2) public Attack2Mapping;
    mapping(uint256 => Attack3) public Attack3Mapping;
    mapping(uint256 => Attack4) public Attack4Mapping;

    mapping(address => bool) public whitelisted;










////////////// Character Stat Geters //////////////////////////////////////////////////////////////////

    function getFighterHp(uint256 _id) external view returns (uint256) {
        return FighterMapping[_id].HP;
    }

    function getFighterEnergy(uint256 _id) external view returns (uint256) {
        return FighterMapping[_id].Energy;
    }

    function getFighterWeakness(uint256 _id) external view returns (string memory) {
        return FighterMapping[_id].Weakness;
    }

/////////////////////////////////////////////////////////////////////////////////////////////////////





////////////// Attack1 Stat Geters //////////////////////////////////////////////////////////////////

    function getAttack1Name(uint256 _id) external view returns (string memory) {
        return Attack1Mapping[_id].Name;
    }

    function getAttack1Dmg(uint256 _id) external view returns (uint256) {
        return Attack1Mapping[_id].Dmg;
    }

    function getAttack1NrgCost(uint256 _id) external view returns (uint256) {
        return Attack1Mapping[_id].NrgCost;
    }

    function getAttack1Type(uint256 _id) external view returns (string memory) {
        return Attack1Mapping[_id].Type;
    }
    
/////////////////////////////////////////////////////////////////////////////////////////////////////

////////////// Attack2 Stat Geters //////////////////////////////////////////////////////////////////

    function getAttack2Name(uint256 _id) external view returns (string memory) {
        return Attack2Mapping[_id].Name;
    }

    function getAttack2Dmg(uint256 _id) external view returns (uint256) {
        return Attack2Mapping[_id].Dmg;
    }

    function getAttack2NrgCost(uint256 _id) external view returns (uint256) {
        return Attack2Mapping[_id].NrgCost;
    }

    function getAttack2Type(uint256 _id) external view returns (string memory) {
        return Attack2Mapping[_id].Type;
    }
    
/////////////////////////////////////////////////////////////////////////////////////////////////////

////////////// Attack3 Stat Geters //////////////////////////////////////////////////////////////////

    function getAttack3Name(uint256 _id) external view returns (string memory) {
        return Attack3Mapping[_id].Name;
    }

    function getAttack3HpGain(uint256 _id) external view returns (uint256) {
        return Attack3Mapping[_id].HpGain;
    }

    function getAttack3NrgCost(uint256 _id) external view returns (uint256) {
        return Attack3Mapping[_id].NrgCost;
    }

    function getAttack3Type(uint256 _id) external view returns (string memory) {
        return Attack3Mapping[_id].Type;
    }

/////////////////////////////////////////////////////////////////////////////////////////////////////

////////////// Attack4 Stat Geters //////////////////////////////////////////////////////////////////

    function getAttack4Name(uint256 _id) external view returns (string memory) {
        return Attack4Mapping[_id].Name;
    }

    function getAttack4NrgGain(uint256 _id) external view returns (uint256) {
        return Attack4Mapping[_id].NrgGain;
    }

    function getAttack4Type(uint256 _id) external view returns (string memory) {
        return Attack4Mapping[_id].Type;
    }

/////////////////////////////////////////////////////////////////////////////////////////////////////





    function walletOfOwner(address _owner) public view returns (uint256[] memory) {
        uint256 ownerTokenCount = balanceOf(_owner);
        uint256[] memory tokenIds = new uint256[](ownerTokenCount);
        for (uint256 i; i < ownerTokenCount; i++) {
            tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
        }
        return tokenIds;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        // if(revealed == false) {
        //     return notRevealedUri;
        // }
        string memory currentBaseURI = _baseURI();
        return bytes(currentBaseURI).length > 0
            ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
            : "";
    }





    ///// The following functions are overrides required by Solidity. ////////////////////////////////////////////////////////
    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////










    // function mint() external payable nonReentrant {
    //     require(!paused, "Contract is currently halted!");
    //     require(supply <= maxSupply, "No more NFTs to mint!");
    //     supply += 1;
    //     supply = totalSupply();
    //     _safeMint(msg.sender, supply + 1);
    // }





    //////////// Modify Functions /////////////////////////////////////////////////////////////////////////////////

    // function setCost(uint256 _newCost) public onlyOwner {
    //     cost = _newCost;
    // }

    // function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
    //     maxMintAmount = _newmaxMintAmount;
    // }

    function pause(bool _state) public onlyOwner {
        paused = _state;
    }
    
    // function whitelistUser(address _user) public onlyOwner {
    //     whitelisted[_user] = true;
    // }
    
    // function removeWhitelistUser(address _user) public onlyOwner {
    //     whitelisted[_user] = false;
    // }

    // function reveal() public onlyOwner {
    //     revealed = true;
    // }
    
    // function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
    //     notRevealedUri = _notRevealedURI;
    // }

    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }

    function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
        baseExtension = _newBaseExtension;
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////





    // function withdraw() public payable onlyOwner {
    //     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
    //     require(os);
    // }



/////////////////// Testing Arrea //////////////////////////////////////////////////////////////////////////////////    
    function setAtk1(uint256 _id, string memory _atk1Name, uint256 atk1Dmg, uint256 atk1NrgC, string memory _atk1Type) external payable nonReentrant onlyOwner {

        Attack1 memory newAttack1 = Attack1(
            _id,
            _atk1Name,
            atk1Dmg,
            atk1NrgC,
            _atk1Type
        );
        Attack1Mapping[_id] = newAttack1;
    }

    function setAtk2(uint256 _id, string memory _atk2Name, uint256 atk2Dmg, uint256 atk2NrgC, string memory _atk2Type) external payable nonReentrant onlyOwner {

        Attack2 memory newAttack2 = Attack2(
            _id,
            _atk2Name,
            atk2Dmg,
            atk2NrgC,
            _atk2Type
        );
        Attack2Mapping[_id] = newAttack2;
    }

    function setAtk3(uint256 _id, string memory _atk3Name, uint256 atk3HpG, uint256 atk3NrgC, string memory _atk3Type) external payable nonReentrant onlyOwner {
        
        Attack3 memory newAttack3 = Attack3(
            _id,
            _atk3Name,
            atk3HpG,
            atk3NrgC,
            _atk3Type
        );
        Attack3Mapping[_id] = newAttack3;
    }

    function setAtk4(uint256 _id, string memory _atk4Name, uint256 atk4NrgG, string memory _atk4Type) external payable nonReentrant onlyOwner {
        
        Attack4 memory newAttack4 = Attack4(
            _id,
            _atk4Name,
            atk4NrgG,
            _atk4Type
        );
        Attack4Mapping[_id] = newAttack4;
    }

    function customMint(uint256 _hp, uint256 _nrg, string memory _weakness,
                        string memory _atk1Name, uint256 atk1Dmg, uint256 atk1NrgC, string memory _atk1Type,
                        string memory _atk2Name, uint256 atk2Dmg, uint256 atk2NrgC, string memory _atk2Type) external payable nonReentrant {
        supply += 1;
        supply = totalSupply();
        _safeMint(msg.sender, supply + 1);

        Fighter memory newFighter = Fighter(
            totalSupply(),
            _hp,
            _nrg,
            _weakness
        );
        FighterMapping[totalSupply()] = newFighter;

        Attack1 memory newAttack1 = Attack1(
            totalSupply(),
            _atk1Name,
            atk1Dmg,
            atk1NrgC,
            _atk1Type
        );
        Attack1Mapping[totalSupply()] = newAttack1;

        Attack2 memory newAttack2 = Attack2(
            totalSupply(),
            _atk2Name,
            atk2Dmg,
            atk2NrgC,
            _atk2Type
        );
        Attack2Mapping[totalSupply()] = newAttack2;

    }

}

    

    