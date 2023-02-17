// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/interfaces/IERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract ICantoLegends {

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

    function getFighterHp(uint256 _id) external view returns (uint256) {
    }

    function getFighterEnergy(uint256 _id) external view returns (uint256) {
    }

    function getFighterWeakness(uint256 _id) external view returns (string memory) {
    }

    function getAttack1Name(uint256 _id) external view returns (string memory) {
    }

    function getAttack1Dmg(uint256 _id) external view returns (uint256) {
    }

    function getAttack1NrgCost(uint256 _id) external view returns (uint256) {
    }

    function getAttack1Type(uint256 _id) external view returns (string memory) {
    }

    function getAttack2Name(uint256 _id) external view returns (string memory) {
    }

    function getAttack2Dmg(uint256 _id) external view returns (uint256) {
    }

    function getAttack2NrgCost(uint256 _id) external view returns (uint256) {
    }

    function getAttack2Type(uint256 _id) external view returns (string memory) {
    }

    function getAttack3Name(uint256 _id) external view returns (string memory) {
    }

    function getAttack3HpGain(uint256 _id) external view returns (uint256) {
    }

    function getAttack3NrgCost(uint256 _id) external view returns (uint256) {
    }

    function getAttack3Type(uint256 _id) external view returns (string memory) {
    }

    function getAttack4Name(uint256 _id) external view returns (string memory) {
    }

    function getAttack4NrgGain(uint256 _id) external view returns (uint256) {
    }

    function getAttack4Type(uint256 _id) external view returns (string memory) {
    }
}

contract GameController is Ownable, ICantoLegends, ReentrancyGuard{

    address internal CantoLegendsNFTAddress;
    uint256 public collectedTax = 0 * 10 ** 18;
    uint256[] public deleted;
    uint256 public sessions;

    constructor(address _nftAddress) {
        CantoLegendsNFTAddress = _nftAddress;
    }


    event NewSession(uint256 sessionId);
    event SessionJoined(uint256 sessionId);
    event TurnAEnded(uint256 sessionId);
    event TurnBEnded(uint256 sessionId);


    struct Session {
        address playerA;
        address playerB;

        uint256 nftIdA;
        uint256 nftIdB;
        uint256 nftHpA;
        uint256 nftHpB;
        uint256 nftNrgA;
        uint256 nftNrgB;

        uint256 amountAtStakeA;
        uint256 amountAtStakeB;
        uint8 TurnOfPlayer;//<----------- 0 == PlayerA, 1 == PlayerB
        uint8 SessionState;//<----------- 0 == Open, 1 == Closed
    }

    struct AdrToID {
        uint256 ID;
    }

    mapping(uint256 => Session) public SessionIDMapping;
    mapping(address => AdrToID) public adrCheck;

    function createSession(uint256 _amountAtStakeA, uint256 _nftId) public payable {
        require(SessionIDMapping[adrCheck[msg.sender].ID].playerA != msg.sender, "Already hosting a session!");
        require(msg.value > 0, "Amount too low!");
        require(msg.value == _amountAtStakeA, "Not enough funds!");//<----- msg.sender has to have at least the specified amount of funds he wants to put at stake 
        require(walletHoldsNft(msg.sender, _nftId), "Not the right NFT!");//<--------------- check if msg.sender holds the nft in order to battle
        if(deleted.length > 0) {
            Session memory newSession = Session(
                msg.sender,
                address(0),
                _nftId,
                0,
                ICantoLegends(CantoLegendsNFTAddress).getFighterHp(_nftId),
                0,
                ICantoLegends(CantoLegendsNFTAddress).getFighterEnergy(_nftId),
                0,
                _amountAtStakeA,
                0,
                0,
                0
            );
            SessionIDMapping[deleted.length] = newSession;
            adrCheck[msg.sender].ID = deleted.length;
            deleted.pop();
            emit NewSession(adrCheck[msg.sender].ID);
        }
        else{
            Session memory newSession = Session(
                msg.sender,
                address(0),
                _nftId,
                0,
                ICantoLegends(CantoLegendsNFTAddress).getFighterHp(_nftId),
                0,
                ICantoLegends(CantoLegendsNFTAddress).getFighterEnergy(_nftId),
                0,
                _amountAtStakeA,
                0,
                0,
                0
            );
            sessions += 1;
            SessionIDMapping[sessions] = newSession;
            adrCheck[msg.sender].ID = sessions;
            emit NewSession(sessions);
        }
    }

    function joinSession(uint256 _sessionId, uint256 _nftId) external payable {
        require(SessionIDMapping[_sessionId].playerA != address(0), "Session doesn't exist!");
        require(SessionIDMapping[_sessionId].SessionState == 0, "Session is closed!");
        require(SessionIDMapping[_sessionId].playerA != msg.sender, "You're already hosting this session!");
        require(msg.value == SessionIDMapping[_sessionId].amountAtStakeA, "Stake doesn't match!");
        require(walletHoldsNft(msg.sender, _nftId), "Not the right NFT!");

        SessionIDMapping[_sessionId].playerB = msg.sender;
        SessionIDMapping[_sessionId].nftIdB = _nftId;
        SessionIDMapping[_sessionId].nftHpB = ICantoLegends(CantoLegendsNFTAddress).getFighterHp(_nftId);
        SessionIDMapping[_sessionId].nftNrgB = ICantoLegends(CantoLegendsNFTAddress).getFighterEnergy(_nftId);
        SessionIDMapping[_sessionId].amountAtStakeB = SessionIDMapping[_sessionId].amountAtStakeA;
        SessionIDMapping[_sessionId].SessionState = 1;
    }





    function turnA(uint256 _sessionId, uint8 _atkNr) external payable {
        require(SessionIDMapping[_sessionId].SessionState == 1, "Game is not available!");
        require(SessionIDMapping[_sessionId].playerA == msg.sender, "Caller is not allowed to participate!");
        require(SessionIDMapping[_sessionId].TurnOfPlayer == 0, "Not your turn!");
        require(SessionIDMapping[_sessionId].nftHpB > 0, "You already won!");

        //get all the important values
        uint256 IdA = SessionIDMapping[_sessionId].nftIdA;

        if((_atkNr ==  1) || (_atkNr == 2)) {
            //get all the important values
            uint256 IdB = SessionIDMapping[_sessionId].nftIdB;
            uint256 NrgA = SessionIDMapping[_sessionId].nftNrgA;
            uint256 NrgAc = ICantoLegends(CantoLegendsNFTAddress).getAttack1NrgCost(IdA);
            uint256 HpB = SessionIDMapping[_sessionId].nftHpB;
            uint256 dmgA = ICantoLegends(CantoLegendsNFTAddress).getAttack1Dmg(IdA);

            if(_atkNr == 2) {
                NrgAc = ICantoLegends(CantoLegendsNFTAddress).getAttack2NrgCost(IdA);
                dmgA = ICantoLegends(CantoLegendsNFTAddress).getAttack2Dmg(IdA);
            }

            //PlayerB has a weakness against PlayerA's attack type
            if(attackTypeIsWeakness(IdA, IdB)) {

                //check if PlayerA's energy will be above 0
                require(NrgA > NrgAc, "Energy too low!");
                SessionIDMapping[_sessionId].nftNrgA -= NrgAc;

                //get the damage bonus
                uint256 bonusDmg = dmgA * 2;
                        
                //check if PlayerB's HP will be above 0
                if(HpB > bonusDmg) {
                        SessionIDMapping[_sessionId].nftHpB -= bonusDmg;
                        SessionIDMapping[_sessionId].TurnOfPlayer = 1;
                        emit TurnAEnded(_sessionId);
                        return;
                        //emit event
                }
                else {
                        SessionIDMapping[_sessionId].nftHpB = 0;
                        emit TurnAEnded(_sessionId);
                        return;
                        //emit event
                }
            }

            //PlayerB has no weakness against PlayerA's attack type
            else {

                //check if PlayerA's energy will be above 0
                require(NrgA > NrgAc, "Energy too low!");
                SessionIDMapping[_sessionId].nftNrgA -= NrgAc;
                        
                //check if PlayerB's HP will be above 0
                if(HpB > dmgA) {
                        SessionIDMapping[_sessionId].nftHpB -= dmgA;
                        SessionIDMapping[_sessionId].TurnOfPlayer = 1;
                        emit TurnAEnded(_sessionId);
                        return;
                        //emit event
                }
                else {
                        SessionIDMapping[_sessionId].nftHpB = 0;
                        emit TurnAEnded(_sessionId);
                        return;
                        //emit event
                }
            }
        }

        if(_atkNr == 3) {
            uint256 NrgAc = ICantoLegends(CantoLegendsNFTAddress).getAttack3NrgCost(IdA);
            uint256 HpAg = ICantoLegends(CantoLegendsNFTAddress).getAttack3HpGain(IdA);
            SessionIDMapping[_sessionId].nftNrgA -= NrgAc;
            SessionIDMapping[_sessionId].nftHpA += HpAg;
            SessionIDMapping[_sessionId].TurnOfPlayer = 1;
            emit TurnAEnded(_sessionId);
            return;
        }

        if(_atkNr == 4) {
            uint256 NrgAg = ICantoLegends(CantoLegendsNFTAddress).getAttack4NrgGain(IdA);
            SessionIDMapping[_sessionId].nftNrgA += NrgAg;
            SessionIDMapping[_sessionId].TurnOfPlayer = 1;
            emit TurnAEnded(_sessionId);
            return;
        }
    }


    function turnB(uint256 _sessionId, uint8 _atkNr) external payable {
        require(SessionIDMapping[_sessionId].SessionState == 1, "Game is not available!");
        require(SessionIDMapping[_sessionId].playerB == msg.sender, "Caller is not allowed to participate!");
        require(SessionIDMapping[_sessionId].TurnOfPlayer == 1, "Not your turn!");
        require(SessionIDMapping[_sessionId].nftHpA > 0, "You already won!");

        //get all the important values
        uint256 IdB = SessionIDMapping[_sessionId].nftIdB;

        if((_atkNr ==  1) || (_atkNr == 2)) {
            //get all the important values
            uint256 IdA = SessionIDMapping[_sessionId].nftIdA;
            uint256 NrgB = SessionIDMapping[_sessionId].nftNrgB;
            uint256 NrgBc = ICantoLegends(CantoLegendsNFTAddress).getAttack1NrgCost(IdB);
            uint256 HpA = SessionIDMapping[_sessionId].nftHpA;
            uint256 dmgB = ICantoLegends(CantoLegendsNFTAddress).getAttack1Dmg(IdB);

            if(_atkNr == 2) {
                NrgBc = ICantoLegends(CantoLegendsNFTAddress).getAttack2NrgCost(IdB);
                dmgB = ICantoLegends(CantoLegendsNFTAddress).getAttack2Dmg(IdB);
            }

            //PlayerB has a weakness against PlayerA's attack type
            if(attackTypeIsWeakness(IdB, IdA)) {

                //check if PlayerA's energy will be above 0
                require(NrgB > NrgBc, "Energy too low!");
                SessionIDMapping[_sessionId].nftNrgB -= NrgBc;

                //get the damage bonus
                uint256 bonusDmg = dmgB * 2;
                        
                //check if PlayerB's HP will be above 0
                if(HpA > bonusDmg) {
                        SessionIDMapping[_sessionId].nftHpA -= bonusDmg;
                        SessionIDMapping[_sessionId].TurnOfPlayer = 0;
                        emit TurnBEnded(_sessionId);
                        return;
                        //emit event
                }
                else {
                        SessionIDMapping[_sessionId].nftHpA = 0;
                        emit TurnBEnded(_sessionId);
                        return;
                        //emit event
                }
            }

            //PlayerB has no weakness against PlayerA's attack type
            else {

                //check if PlayerA's energy will be above 0
                require(NrgB > NrgBc, "Energy too low!");
                SessionIDMapping[_sessionId].nftNrgB -= NrgBc;
                        
                //check if PlayerB's HP will be above 0
                if(HpA > dmgB) {
                        SessionIDMapping[_sessionId].nftHpA -= dmgB;
                        SessionIDMapping[_sessionId].TurnOfPlayer = 0;
                        emit TurnBEnded(_sessionId);
                        return;
                        //emit event
                }
                else {
                        SessionIDMapping[_sessionId].nftHpA = 0;
                        emit TurnBEnded(_sessionId);
                        return;
                        //emit event
                }
            }
        }

        if(_atkNr == 3) {
            uint256 NrgBc = ICantoLegends(CantoLegendsNFTAddress).getAttack3NrgCost(IdB);
            uint256 HpBg = ICantoLegends(CantoLegendsNFTAddress).getAttack3HpGain(IdB);
            SessionIDMapping[_sessionId].nftNrgB -= NrgBc;
            SessionIDMapping[_sessionId].nftHpB += HpBg;
            SessionIDMapping[_sessionId].TurnOfPlayer = 0;
            emit TurnBEnded(_sessionId);
            return;
        }

        if(_atkNr == 4) {
            uint256 NrgBg = ICantoLegends(CantoLegendsNFTAddress).getAttack4NrgGain(IdB);
            SessionIDMapping[_sessionId].nftNrgB += NrgBg;
            SessionIDMapping[_sessionId].TurnOfPlayer = 0;
            emit TurnBEnded(_sessionId);
            return;
        }
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////





    function claimWin(uint256 _sessionId) public payable nonReentrant {
        require(SessionIDMapping[_sessionId].playerA == msg.sender || SessionIDMapping[_sessionId].playerB == msg.sender, "Caller is not allowed to claim!");
        bool timeout = false;
        uint256 HpA = SessionIDMapping[_sessionId].nftHpA;
        uint256 HpB = SessionIDMapping[_sessionId].nftHpB;
        uint8 turn = SessionIDMapping[_sessionId].TurnOfPlayer;

        if(SessionIDMapping[_sessionId].playerA == msg.sender) {
            require((turn == 0 && HpB == 0) || timeout, "Caller is not allowed to claim!");
            uint256 tax = (SessionIDMapping[_sessionId].amountAtStakeA + SessionIDMapping[_sessionId].amountAtStakeB) / 100 * 5;
            collectedTax += tax;
            uint256 winnerAmount = SessionIDMapping[_sessionId].amountAtStakeA + SessionIDMapping[_sessionId].amountAtStakeB;
            payable(address(msg.sender)).transfer(winnerAmount - tax);
            deleted.push(_sessionId);
            delete adrCheck[msg.sender];
            delete SessionIDMapping[_sessionId];
            return;
        }

        if(SessionIDMapping[_sessionId].playerB == msg.sender) {
            require((turn == 1 && HpA == 0) || timeout, "Caller is not allowed to claim!");
            uint256 tax = (SessionIDMapping[_sessionId].amountAtStakeA + SessionIDMapping[_sessionId].amountAtStakeB) / 100 * 5;
            collectedTax += tax;
            uint256 winnerAmount = SessionIDMapping[_sessionId].amountAtStakeA + SessionIDMapping[_sessionId].amountAtStakeB;
            payable(address(msg.sender)).transfer(winnerAmount - tax);
            deleted.push(_sessionId);
            delete adrCheck[SessionIDMapping[_sessionId].playerA];
            delete SessionIDMapping[_sessionId];
            return;
        }
        // emit event
    }


    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function walletHoldsNft(address _wallet, uint256 _nftId) internal view returns (bool) {
        return IERC721(CantoLegendsNFTAddress).ownerOf(_nftId) == _wallet;
    }

    function changeNftAddress(address _newNftAddress) external onlyOwner {
        CantoLegendsNFTAddress = _newNftAddress;
    }

    function attackTypeIsWeakness(uint256 _nftIdAttacker, uint256 _nftIdDefender) internal view returns (bool) {
        return keccak256(abi.encodePacked(ICantoLegends(CantoLegendsNFTAddress).getAttack1Type(_nftIdAttacker))) == 
               keccak256(abi.encodePacked(ICantoLegends(CantoLegendsNFTAddress).getFighterWeakness(_nftIdDefender)));
    }





    function collectTax() public payable onlyOwner {
        uint256 taxSnapshot = collectedTax;
        payable(address(msg.sender)).transfer(collectedTax);
        collectedTax -= taxSnapshot;
    }

}
