# iInstanceDAO
[Git Source](https://github.com/parseb/WalllaW/blob/9e3aa1f94078a6f713d193fa93b20149519f722a/src/interfaces/iInstanceDAO.sol)


## Functions
### signalInflation


```solidity
function signalInflation(uint256 percentagePerYear_) external returns (uint256 inflationRate);
```

### mintMembershipToken


```solidity
function mintMembershipToken(address to_) external returns (bool);
```

### changeMembrane


```solidity
function changeMembrane(uint256 membraneId_) external returns (uint256 membraneID);
```

### executeCall


```solidity
function executeCall(uint256 externalCallId) external returns (uint256);
```

### distributiveSignal


```solidity
function distributiveSignal(uint256[] memory cronoOrderedDistributionAmts) external returns (uint256);
```

### multicall


```solidity
function multicall(bytes[] memory) external returns (bytes[] memory results);
```

### executeExternalLogic


```solidity
function executeExternalLogic(uint256 callId_) external returns (bool);
```

### feedMe


```solidity
function feedMe() external returns (uint256);
```

### redistributeSubDAO


```solidity
function redistributeSubDAO(address subDAO_) external returns (uint256);
```

### mintInflation


```solidity
function mintInflation() external returns (uint256);
```

### feedStart


```solidity
function feedStart() external returns (uint256 minted);
```

### withdrawBurn


```solidity
function withdrawBurn(uint256 amt_) external returns (uint256 amtWithdrawn);
```

### gCheckPurge


```solidity
function gCheckPurge(address who_) external;
```

### getActiveIndecisions

only MR
view


```solidity
function getActiveIndecisions() external view returns (uint256[] memory);
```

### stateOfExpressed


```solidity
function stateOfExpressed(address user_, uint256 prefID_) external view returns (uint256[3] memory pref);
```

### internalTokenAddress


```solidity
function internalTokenAddress() external view returns (address);
```

### endpoint


```solidity
function endpoint() external view returns (address);
```

### baseTokenAddress


```solidity
function baseTokenAddress() external view returns (address);
```

### baseID


```solidity
function baseID() external view returns (uint256);
```

### instantiatedAt


```solidity
function instantiatedAt() external view returns (uint256);
```

### getUserReDistribution


```solidity
function getUserReDistribution(address ofWhom) external view returns (uint256[] memory);
```

### baseInflationRate


```solidity
function baseInflationRate() external view returns (uint256);
```

### baseInflationPerSec


```solidity
function baseInflationPerSec() external view returns (uint256);
```

### isMember


```solidity
function isMember(address who_) external view returns (bool);
```

### parentDAO


```solidity
function parentDAO() external view returns (address);
```

### getILongDistanceAddress


```solidity
function getILongDistanceAddress() external view returns (address);
```

### uri


```solidity
function uri() external view returns (string memory);
```

