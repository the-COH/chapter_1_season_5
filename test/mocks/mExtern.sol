// pragma solidity ^0.8.13;

// import "openzeppelin-contracts/token/ERC20/ERC20.sol";
// import "../../src/DAO20.sol";
// import "../../src/interfaces/IMembrane.sol";
// import "../../src/interfaces/ILongCall.sol";

// contract DelegStore {
//     uint256 public baseID;
//     uint256 public baseInflationRate;
//     uint256 public baseInflationPerSec;
//     uint256 public instantiatedAt;
//     address public parentDAO;
//     address public endpoint;
//     address ODAO;
//     address purgeInProgress;
//     IERC20 public BaseToken;
//     DAO20 public internalToken;
//     IMemberRegistry iMR;
//     IMembrane iMB;
//     ILongCall iLG;

//     /// # EOA => subunit => [percentage, amt]
//     mapping(address => mapping(address => uint256[2])) userSignal;

//     /// #subunit id => [perSecond, timestamp]
//     mapping(address => uint256[2]) subunitPerSec;

//     /// last user distributive signal
//     mapping(address => uint256[]) redistributiveSignal;

//     /// expressed: id/percent/uri | msgSender()/address(0) | value/0
//     mapping(uint256 => mapping(address => uint256)) expressed;

//     /// list of expressors for id/percent/uri
//     mapping(uint256 => address[]) expressors;

//     uint256[] private activeIndecisions;

//     constructor() {
//         baseID = 5;
//     }

//     function changeODAOAddress(uint256 O_O) external {
//         baseID = O_O;
//     }

//     function replaceILongDistanceCalLogic(address newLongDistanceCallLogic_) external {
//         iLG = ILongCall(newLongDistanceCallLogic_);
//     }
// }
