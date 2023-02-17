# IExternalCall
[Git Source](https://github.com/parseb/WalllaW/blob/9e3aa1f94078a6f713d193fa93b20149519f722a/src/interfaces/IExternalCall.sol)


## Functions
### createExternalCall


```solidity
function createExternalCall(address[] memory contracts_, bytes[] memory callDatas_, string memory description_)
    external
    returns (uint256);
```

### getExternalCallbyID


```solidity
function getExternalCallbyID(uint256 id) external view returns (ExtCall memory);
```

### incrementSelfNonce


```solidity
function incrementSelfNonce() external;
```

### updateLastExecuted


```solidity
function updateLastExecuted(uint256 whatExtCallId_) external returns (bool);
```

### isValidCall


```solidity
function isValidCall(uint256 id_) external view returns (bool);
```

### getNonceOf


```solidity
function getNonceOf(address whom_) external view returns (uint256);
```

