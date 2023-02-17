# DAOinstance
[Git Source](https://github.com/parseb/WalllaW/blob/9e3aa1f94078a6f713d193fa93b20149519f722a/src/DAOinstance.sol)


## State Variables
### baseID

```solidity
uint256 public baseID;
```


### baseInflationRate

```solidity
uint256 public baseInflationRate;
```


### baseInflationPerSec

```solidity
uint256 public baseInflationPerSec;
```


### instantiatedAt

```solidity
uint256 public instantiatedAt;
```


### parentDAO

```solidity
address public parentDAO;
```


### endpoint

```solidity
address public endpoint;
```


### ODAO

```solidity
address ODAO;
```


### purgeorExternalCall

```solidity
address purgeorExternalCall;
```


### BaseToken

```solidity
IERC20 public BaseToken;
```


### internalToken

```solidity
DAO20 public internalToken;
```


### iMR

```solidity
IMemberRegistry iMR;
```


### iMB

```solidity
IMembrane iMB;
```


### iEXT

```solidity
IExternalCall iEXT;
```


### userSignal
# EOA => subunit => [percentage, amt]

stores broadcasted signal of user about preffered distribution [example: 5% of inflation to subDAO x]

formed as address of affirming agent => address of subDAO (or endpoint) => 1-100% percentage amount.


```solidity
mapping(address => mapping(address => uint256[2])) userSignal;
```


### subunitPerSec
#subunit id => [perSecond, timestamp]

stores the nominal amount a subunit is entitled to

formed as address_of_subunit => [amount_of_entitlement_gained_each_second, time_since_last_withdrawal @dev ?]


```solidity
mapping(address => uint256[2]) subunitPerSec;
```


### redistributiveSignal
last user distributive signal

stored array of preffered user redistribution percentages. formatted as `address of agent => [array of preferences]

minimum value 1, maximum vaule 100. Sum of percentages needs to add up to 100.


```solidity
mapping(address => uint256[]) redistributiveSignal;
```


### expressed
expressed: membrane / inflation rate / * | msgSender()/address(0) | value/0

expressed quantifiable support for specified change of membrane, inflation or *


```solidity
mapping(uint256 => mapping(address => uint256)) expressed;
```


### expressors
list of expressors for id/percent/uri

stores array of agent addresses that are expressing a change


```solidity
mapping(uint256 => address[]) expressors;
```


## Functions
### constructor


```solidity
constructor(address BaseToken_, address initiator_, address MemberRegistry_);
```

### onlyMember


```solidity
modifier onlyMember();
```

### signalInflation

percentage anualized 1-100 as relative to the totalSupply of base token

signal preferred annual inflation rate. Multiple preferences possible.

materialized amounts are sensitive to totalSupply. Majoritarian execution.


```solidity
function signalInflation(uint256 percentagePerYear_) external onlyMember returns (uint256 inflationRate);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`percentagePerYear_`|`uint256`|prefered option in range 0 - 100|


### changeMembrane

initiate or support change of membrane in favor of designated by id


```solidity
function changeMembrane(uint256 membraneId_) external onlyMember returns (uint256 membraneID);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`membraneId_`|`uint256`|id of membrane to support change of|


### executeCall

expresses preference for and executes pre-configured extenrall call with provided id on majoritarian threshold


```solidity
function executeCall(uint256 externalCallId_) external onlyMember returns (uint256 callID);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`externalCallId_`|`uint256`|id of preconfigured externall call|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`callID`|`uint256`|0 - if threshold not reached, id input if call is executed.|


### distributiveSignal

signal prefferred redistribution percentages out of inflation

beneficiaries are ordered chonologically and expects a value for each item retruend by `getDAOsOfToken`


```solidity
function distributiveSignal(uint256[] memory cronoOrderedDistributionAmts) external onlyMember returns (uint256 i);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`cronoOrderedDistributionAmts`|`uint256[]`|complete array of preffered sub-entity distributions with sum 100|


### feedMe

checks and trickles down eligible amounts of inflation balance on path from root to this

*senderForce < 1%*

*fuzz  (subunitPerSec[entity][0] > userSignal[_msgSender()][entity][1])*


```solidity
function feedMe() external returns (uint256 fed);
```

### _postMajorityCleanup


```solidity
function _postMajorityCleanup(address[] memory agents, uint256 target_) public returns (uint256 outcome);
```

### mintInflation


```solidity
function mintInflation() public returns (uint256 amountToMint);
```

### redistributeSubDAO


```solidity
function redistributeSubDAO(address subDAO_) public returns (uint256 gotAmt);
```

### multicall


```solidity
function multicall(bytes[] calldata data) external returns (bytes[] memory results);
```

### mintMembershipToken

mints membership token to specified address if it fulfills the acceptance criteria of the membrane


```solidity
function mintMembershipToken(address to_) external returns (bool s);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`to_`|`address`|address to mint membership token to|


### withdrawBurn

burns internal token and returnes to msg.sender the eligible underlying amount of parent tokens


```solidity
function withdrawBurn(uint256 amt_) external returns (bool s);
```

### gCheckPurge

immune mechanism to check basis of membership and revoke if invalid


```solidity
function gCheckPurge(address who_) external returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`who_`|`address`|address to check|


### _majoritarianUpdate

executes the outcome of any given successful majoritarian tipping point


```solidity
function _majoritarianUpdate(uint256 newVal_) private returns (uint256);
```

### _expressPreference

*instantiates in memory a given expressed preference for change*


```solidity
function _expressPreference(uint256 preference_) private;
```

### _postMajorityCleanup

*once a change materializes, this is called to clean state and reset its latent potential*


```solidity
function _postMajorityCleanup(uint256 target_) private returns (uint256);
```

### _msgSender

is sum validatation superfluous and prone to error? -&/ gas concerns
#extra

@dev @todo should be part of normal execution chain


```solidity
function _msgSender() private view returns (address);
```

### internalTokenAddress


```solidity
function internalTokenAddress() external view returns (address);
```

### baseTokenAddress


```solidity
function baseTokenAddress() external view returns (address);
```

### getUserReDistribution


```solidity
function getUserReDistribution(address user_) external view returns (uint256[] memory);
```

### isMember


```solidity
function isMember(address who_) public view returns (bool);
```

### getUserSignal


```solidity
function getUserSignal(address who_, address subUnit_) external view returns (uint256[2] memory);
```

### stateOfExpressed


```solidity
function stateOfExpressed(address user_, uint256 prefID_) external view returns (uint256[3] memory pref);
```

### uri


```solidity
function uri() external view returns (string memory);
```

## Events
### StateAdjusted

```solidity
event StateAdjusted();
```

### AdjustedRate

```solidity
event AdjustedRate();
```

### UserPreferedGuidance

```solidity
event UserPreferedGuidance();
```

### FallbackCalled

```solidity
event FallbackCalled(address caller, uint256 amount, string message);
```

### GlobalInflationUpdated

```solidity
event GlobalInflationUpdated(uint256 RatePerYear, uint256 perSecInflation);
```

### inflationaryMint

```solidity
event inflationaryMint(uint256 amount);
```

### NewInstance

```solidity
event NewInstance(address indexed at, address indexed baseToken, address owner);
```

