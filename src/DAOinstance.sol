// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./interfaces/IMember1155.sol";
import "./interfaces/IoDAO.sol";
import "./interfaces/iInstanceDAO.sol";
import "./interfaces/IMembrane.sol";
import "./interfaces/IExternalCall.sol";
import "./utils/Address.sol";
import "./DAO20.sol";
import "./errors.sol";
import "./interfaces/ICantoTurnstile.sol";
import "./interfaces/ICSRvault.sol";

contract DAOinstance {
    uint256 public baseID;
    uint256 public baseInflationRate;
    uint256 public baseInflationPerSec;
    uint256 public instantiatedAt;
    address public parentDAO;
    address public endpoint;
    address ODAO;
    address purgeorExternalCall;
    IERC20 public BaseToken;
    DAO20 public internalToken;
    IMemberRegistry iMR;
    IMembrane iMB;
    IExternalCall iEXT;

    /// # EOA => subunit => [percentage, amt]
    /// @notice stores broadcasted signal of user about preffered distribution [example: 5% of inflation to subDAO x]
    /// @notice formed as address of affirming agent => address of subDAO (or endpoint) => 1-100% percentage amount.
    mapping(address => mapping(address => uint256[2])) userSignal;

    /// #subunit id => [perSecond, timestamp]
    /// @notice stores the nominal amount a subunit is entitled to
    /// @notice formed as address_of_subunit => [amount_of_entitlement_gained_each_second, time_since_last_withdrawal @dev ?]
    mapping(address => uint256[2]) subunitPerSec;

    /// last user distributive signal
    /// @notice stored array of preffered user redistribution percentages. formatted as `address of agent => [array of preferences]
    /// @notice minimum value 1, maximum vaule 100. Sum of percentages needs to add up to 100.
    mapping(address => uint256[]) redistributiveSignal;

    /// expressed: membrane / inflation rate / * | msgSender()/address(0) | value/0
    /// @notice expressed quantifiable support for specified change of membrane, inflation or *
    mapping(uint256 => mapping(address => uint256)) expressed;

    /// list of expressors for id/percent/uri
    /// @notice stores array of agent addresses that are expressing a change
    mapping(uint256 => address[]) expressors;

    // uint256[] private activeIndecisions; ///// @todo

    // ITurnstile TurnS = ITurnstile(0xEcf044C5B4b867CFda001101c617eCd347095B44);
    // ICSRvault CSRvault = ICSRvault(0xEcf044C5B4b867CFda001101c617eCd347095B44); /// ICSR VAULT ADDRESS

    constructor(address BaseToken_, address initiator_, address MemberRegistry_) {
        ODAO = msg.sender;
        instantiatedAt = block.timestamp;
        BaseToken = IERC20(BaseToken_);
        baseID = uint160(bytes20(address(this)));
        baseInflationRate = baseID % 100 > 0 ? baseID % 100 : 1;
        iMR = IMemberRegistry(MemberRegistry_);
        iMB = IMembrane(iMR.MembraneRegistryAddress());
        iEXT = IExternalCall(iMR.ExternalCallAddress());
        internalToken = new DAO20(BaseToken_, "WalllaW$_$Internal", "WdoW",18);
        BaseToken.approve(address(internalToken), type(uint256).max - 1);

        subunitPerSec[address(this)][1] = block.timestamp;
        address CSRvault = IoDAO(ODAO).CSRvault();
        ITurnstile(ICSRvault(CSRvault).turnSaddr()).assign(ICSRvault(CSRvault).CSRtokenID());

        emit NewInstance(address(this), BaseToken_, initiator_);
    }

    /*//////////////////////////////////////////////////////////////
                                 events
    //////////////////////////////////////////////////////////////*/

    event StateAdjusted();
    event AdjustedRate();
    event UserPreferedGuidance();
    event FallbackCalled(address caller, uint256 amount, string message);
    event GlobalInflationUpdated(uint256 RatePerYear, uint256 perSecInflation);
    event inflationaryMint(uint256 amount);
    event NewInstance(address indexed at, address indexed baseToken, address owner);

    /*//////////////////////////////////////////////////////////////
                                 modifiers
    //////////////////////////////////////////////////////////////*/

    modifier onlyMember() {
        if (msg.sender == address(internalToken) || msg.sender == address(this)) {
            _;
        } else {
            if (!isMember(_msgSender())) revert DAOinstance__NotMember();
            _;
        }
    }

    /// percentage anualized 1-100 as relative to the totalSupply of base token
    /// @notice signal preferred annual inflation rate. Multiple preferences possible.
    /// @notice materialized amounts are sensitive to totalSupply. Majoritarian execution.
    /// @param percentagePerYear_ prefered option in range 0 - 100
    function signalInflation(uint256 percentagePerYear_) external onlyMember returns (uint256 inflationRate) {
        require(percentagePerYear_ <= 100, ">100!");
        _expressPreference(percentagePerYear_);

        inflationRate = (internalToken.totalSupply() / ((expressed[percentagePerYear_][address(0)] + 1)) < 2)
            ? _majoritarianUpdate(percentagePerYear_)
            : baseInflationRate;
    }

    /// @notice initiate or support change of membrane in favor of designated by id
    /// @param membraneId_ id of membrane to support change of
    function changeMembrane(uint256 membraneId_) external onlyMember returns (uint256 membraneID) {
        _expressPreference(membraneId_);
        if (!iMB.isMembrane(membraneId_)) revert DAOinstance__invalidMembrane();

        membraneID = ((internalToken.totalSupply() / (expressed[membraneId_][address(0)] + 1) < 2))
            ? _majoritarianUpdate(membraneId_)
            : iMB.inUseMembraneId(address(this));
    }

    /// @notice expresses preference for and executes pre-configured extenrall call with provided id on majoritarian threshold
    /// @param externalCallId_ id of preconfigured externall call
    /// @return callID 0 - if threshold not reached, id input if call is executed.
    function executeCall(uint256 externalCallId_) external onlyMember returns (uint256 callID) {
        if (!iEXT.isValidCall(externalCallId_)) revert DAOinstance__invalidMembrane();
        _expressPreference(externalCallId_);

        callID = ((internalToken.totalSupply() / (expressed[externalCallId_][address(0)] + 1) < 2))
            && (iEXT.exeUpdate(externalCallId_)) ? _majoritarianUpdate(externalCallId_) : 0;
    }

    /// @notice signal prefferred redistribution percentages out of inflation
    /// @notice beneficiaries are ordered chonologically and expects a value for each item retruend by `getDAOsOfToken`
    /// @param cronoOrderedDistributionAmts complete array of preffered sub-entity distributions with sum 100

    function distributiveSignal(uint256[] memory cronoOrderedDistributionAmts)
        external
        onlyMember
        returns (uint256 i)
    {
        address sender = _msgSender();
        uint256 senderForce = internalToken.balanceOf(sender);
        if ((senderForce == 0 && (!(cronoOrderedDistributionAmts.length == 0)))) revert DAOinstance__HasNoSay();
        if (cronoOrderedDistributionAmts.length == 0) cronoOrderedDistributionAmts = redistributiveSignal[sender];
        redistributiveSignal[sender] = cronoOrderedDistributionAmts;

        address[] memory subDAOs = IoDAO(ODAO).getDAOsOfToken(address(internalToken));
        if (subDAOs.length != cronoOrderedDistributionAmts.length) revert DAOinstance__LenMismatch();

        uint256 centum;
        uint256 perSec;
        for (i; i < subDAOs.length;) {
            redistributeSubDAO(subDAOs[i]);

            uint256 submittedValue = cronoOrderedDistributionAmts[i];
            if (subunitPerSec[subDAOs[i]][1] == 0) {
                subunitPerSec[subDAOs[i]][1] = iInstanceDAO(subDAOs[i]).instantiatedAt();
            }
            if (submittedValue == subunitPerSec[subDAOs[i]][0]) continue;

            address entity = subDAOs[i];

            unchecked {
                centum += cronoOrderedDistributionAmts[i];
            }
            if (centum > 100_00) revert DAOinstance__Over100();

            perSec = submittedValue * baseInflationPerSec / 100_00;
            perSec = (senderForce * 1 ether / internalToken.totalSupply()) * perSec / 1 ether;
            /// @dev senderForce < 1%

            subunitPerSec[entity][0] = (subunitPerSec[entity][0] - userSignal[sender][entity][1]) + perSec;
            /// @dev fuzz  (subunitPerSec[entity][0] > userSignal[_msgSender()][entity][1])

            userSignal[sender][entity][1] = perSec;
            userSignal[sender][entity][0] = submittedValue;

            unchecked {
                ++i;
            }
        }
    }

    /// @notice checks and trickles down eligible amounts of inflation balance on path from root to this
    function feedMe() external returns (uint256 fed) {
        address[] memory feedPath = IoDAO(ODAO).getTrickleDownPath(address(this));
        if (feedPath[0] == address(0)) {
            return fed = iInstanceDAO(parentDAO).redistributeSubDAO(address(this));
        }

        uint256 i = 1;
        for (i; i < feedPath.length;) {
            if (feedPath[i] == address(0)) break;
            iInstanceDAO(feedPath[i]).redistributeSubDAO(feedPath[i - 1]);

            unchecked {
                ++i;
            }
        }
        fed = iInstanceDAO(feedPath[0]).redistributeSubDAO(address(this));
    }

    function _postMajorityCleanup(address[] memory agents, uint256 target_) public returns (uint256 outcome) {
        if (expressed[target_][address(0)] < (internalToken.totalSupply() / 2)) revert DAOinstance__notmajority();

        uint256 sum;
        address a;
        for (outcome; outcome < agents.length;) {
            a = agents[outcome];
            unchecked {
                sum += expressed[target_][a];
            }
            delete expressed[target_][a];
            unchecked {
                ++outcome;
            }
        }
        outcome = sum;
    }

    function mintInflation() public returns (uint256 amountToMint) {
        amountToMint = (block.timestamp - subunitPerSec[address(this)][1]);
        if (amountToMint == 0) return amountToMint;

        amountToMint = (amountToMint * baseInflationPerSec);
        require(internalToken.inflationaryMint(amountToMint));
        subunitPerSec[address(this)][1] = block.timestamp;

        _majoritarianUpdate(0);

        emit inflationaryMint(amountToMint);
    }

    function redistributeSubDAO(address subDAO_) public returns (uint256 gotAmt) {
        mintInflation();
        gotAmt = subunitPerSec[subDAO_][0] * (block.timestamp - subunitPerSec[subDAO_][1]);
        subunitPerSec[subDAO_][1] = block.timestamp;
        if (!internalToken.transfer(subDAO_, gotAmt)) revert DAOinstance__itTransferFailed();
    }

    /// @notice mints membership token to specified address if it fulfills the acceptance criteria of the membrane
    /// @param to_ address to mint membership token to
    function mintMembershipToken(address to_) external returns (bool s) {
        if (endpoint != address(0)) revert DAOinstance__isEndpoint();

        if (msg.sender == ODAO) {
            parentDAO = IoDAO(ODAO).getParentDAO(address(this));
            if (to_ == address(uint160(iMB.inUseMembraneId(address(this))))) {
                endpoint = to_;
                return true;
            }
            if (internalToken.mintInitOne(to_)) return iMR.makeMember(to_, baseID);
        }

        s = iMB.checkG(to_, address(this));
        if (!s) revert DAOinstance__Unqualified();
        s = iMR.makeMember(to_, baseID) && s;
    }

    /// @notice burns internal token and returnes to msg.sender the eligible underlying amount of parent tokens
    function withdrawBurn(uint256 amt_) external returns (bool s) {
        if (endpoint != _msgSender()) revert DAOinstance__NotYourEnpoint();
        s = BaseToken.transfer(endpoint, amt_);
    }

    /// @notice immune mechanism to check basis of membership and revoke if invalid
    /// @param who_ address to check
    function gCheckPurge(address who_) external returns (bool) {
        if (msg.sender != address(iMR)) revert DAOinstance__onlyMR();

        delete redistributiveSignal[who_];
        address keepExtCall = purgeorExternalCall;
        purgeorExternalCall = who_;
        this.distributiveSignal(redistributiveSignal[who_]);
        delete purgeorExternalCall;
        purgeorExternalCall = keepExtCall;

        return true;
    }

    // function multicall(bytes[] calldata data) external returns (bytes[] memory results) {
    //     results = new bytes[](data.length);
    //     for (uint256 i = 0; i < data.length; i++) {
    //         results[i] = Address.functionDelegateCall(address(this), data[i]);
    //     }
    //     return results;
    // }

    /// @notice executes the outcome of any given successful majoritarian tipping point
    ///////////////////
    function _majoritarianUpdate(uint256 newVal_) private returns (uint256) {
        if (msg.sig == this.mintInflation.selector) {
            baseInflationPerSec = internalToken.totalSupply() * baseInflationRate / 365 days / 100;
        }

        if (msg.sig == this.signalInflation.selector) {
            baseInflationRate = newVal_;
            baseInflationPerSec = internalToken.totalSupply() * newVal_ / 365 days / 100;
            return _postMajorityCleanup(newVal_);
        }

        if (msg.sig == this.changeMembrane.selector) {
            require(iMB.setMembrane(newVal_, address(this)), "f O.setM.");
            iMR.setUri(iMB.inUseUriOf(address(this)));
            return _postMajorityCleanup(newVal_);
        }

        if (msg.sig == this.executeCall.selector) {
            ExtCall memory callStruct = iEXT.getExternalCallbyID(newVal_);

            uint256 i;
            for (; i < callStruct.contractAddressesToCall.length;) {
                (bool success, bytes memory data) =
                    callStruct.contractAddressesToCall[i].call(callStruct.dataToCallWith[i]);
                if (!success) revert DAOinstance_ExeCallFailed(data);
                unchecked {
                    ++i;
                }
            }
            return _postMajorityCleanup(newVal_);
        }
    }

    /// @dev instantiates in memory a given expressed preference for change
    function _expressPreference(uint256 preference_) private {
        uint256 pressure = internalToken.balanceOf(_msgSender());
        uint256 previous = expressed[preference_][_msgSender()];

        if (previous > 0) expressed[preference_][address(0)] -= previous;
        expressed[preference_][address(0)] += pressure;
        expressed[preference_][_msgSender()] = pressure;
        if (previous == 0) {
            expressors[preference_].push(_msgSender());
            // activeIndecisions.push(preference_);
        }
    }

    /// @dev once a change materializes, this is called to clean state and reset its latent potential
    function _postMajorityCleanup(uint256 target_) private returns (uint256) {
        /// is sum validatation superfluous and prone to error? -&/ gas concerns
        address[] memory agents = expressors[target_];
        uint256 sum = _postMajorityCleanup(agents, target_);

        if (!(sum >= expressed[target_][address(0)])) revert DAOinstance__CannotUpdate();

        /// #extra

        delete expressed[target_][address(0)];
        delete expressors[target_];
        return target_;
    }

    function _msgSender() private view returns (address) {
        if (msg.sender == address(internalToken)) return internalToken.burnInProgress();
        if (msg.sender == address(this) && msg.sig == this.distributiveSignal.selector) return purgeorExternalCall;

        return msg.sender;
    }

    /*//////////////////////////////////////////////////////////////
                                 VIEW
    //////////////////////////////////////////////////////////////*/

    function internalTokenAddress() external view returns (address) {
        return address(internalToken);
    }

    function baseTokenAddress() external view returns (address) {
        return address(BaseToken);
    }

    function getUserReDistribution(address user_) external view returns (uint256[] memory) {
        return redistributiveSignal[user_];
    }

    function isMember(address who_) public view returns (bool) {
        return ((who_ == address(internalToken)) || iMR.balanceOf(who_, baseID) > 0);
    }

    function getUserSignal(address who_, address subUnit_) external view returns (uint256[2] memory) {
        return userSignal[who_][subUnit_];
    }

    function stateOfExpressed(address user_, uint256 prefID_) external view returns (uint256[3] memory pref) {
        pref[0] = expressed[prefID_][user_];
        pref[1] = expressed[prefID_][address(0)];
        pref[2] = internalToken.totalSupply();
    }

    function uri() external view returns (string memory) {
        return iMB.inUseUriOf(address(this));
    }
}
