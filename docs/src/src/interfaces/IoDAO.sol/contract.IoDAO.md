# IoDAO
[Git Source](https://github.com/parseb/WalllaW/blob/9e3aa1f94078a6f713d193fa93b20149519f722a/src/interfaces/IoDAO.sol)


## Functions
### isDAO


```solidity
function isDAO(address toCheck) external view returns (bool);
```

### createDAO


```solidity
function createDAO(address BaseTokenAddress_) external returns (address newDAO);
```

### createSubDAO


```solidity
function createSubDAO(uint256 membraneID_, address parentDAO_) external returns (address subDAOaddr);
```

### getParentDAO


```solidity
function getParentDAO(address child_) external view returns (address);
```

### getDAOsOfToken


```solidity
function getDAOsOfToken(address parentToken) external view returns (address[] memory);
```

### getDAOfromID


```solidity
function getDAOfromID(uint256 id_) external view returns (address);
```

### getTrickleDownPath


```solidity
function getTrickleDownPath(address floor_) external view returns (address[] memory);
```

