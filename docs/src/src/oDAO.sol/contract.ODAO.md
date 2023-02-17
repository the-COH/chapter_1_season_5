# ODAO
[Git Source](https://github.com/parseb/WalllaW/blob/9e3aa1f94078a6f713d193fa93b20149519f722a/src/oDAO.sol)


## State Variables
### daoOfId

```solidity
mapping(uint256 => address) daoOfId;
```


### daosOfToken

```solidity
mapping(address => address[]) daosOfToken;
```


### childParentDAO

```solidity
mapping(address => address) childParentDAO;
```


### topLevelPath

```solidity
mapping(address => address[]) topLevelPath;
```


### MR

```solidity
IMemberRegistry MR;
```


### MB

```solidity
address public MB;
```


### MAX_160

```solidity
uint256 constant MAX_160 = type(uint160).max;
```


## Functions
### constructor


```solidity
constructor();
```

### createDAO

creates a new DAO gien an ERC20


```solidity
function createDAO(address BaseTokenAddress_) public returns (address newDAO);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`BaseTokenAddress_`|`address`|ERC20 token contract address|


### createSubDAO

--------------- create sub-endpoints for endpoint? @todo

creates child entity subDAO provided a valid membrane ID is given. To create an enpoint use sender address as integer. uint160(0xyourAddress)

@security the creator of the subdao custodies assets


```solidity
function createSubDAO(uint256 membraneID_, address parentDAO_) external returns (address subDAOaddr);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`membraneID_`|`uint256`||
|`parentDAO_`|`address`||


### isDAO

checks if address is a registered DAOS

*used to authenticate membership minting*


```solidity
function isDAO(address toCheck_) public view returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`toCheck_`|`address`||


### getMemberRegistryAddr

get address of member registru address


```solidity
function getMemberRegistryAddr() external view returns (address);
```

### getParentDAO

given a valid subDAO address, returns the address of the parent. If root DAO, returns address(0x0)


```solidity
function getParentDAO(address child_) public view returns (address);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`child_`|`address`|sub-DAO address. If root or non-existent, returns adddress(0x0)|


### getTrickleDownPath

returns the top-down path, or all the parents in a hierarchical, distance-based order, from closest parent to root.


```solidity
function getTrickleDownPath(address floor_) external view returns (address[] memory path);
```

### getDAOsOfToken

an ERC20 token can have an unlimited number of DAOs. This returns all root DAOs in existence for provided ERC20.


```solidity
function getDAOsOfToken(address parentToken) external view returns (address[] memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`parentToken`|`address`|ERC20 contract address|


## Events
### newDAOCreated

```solidity
event newDAOCreated(address indexed DAO, address indexed token);
```

### subDAOCreated

```solidity
event subDAOCreated(address indexed parentDAO, address indexed subDAO, address indexed creator);
```

## Errors
### nullTopLayer

```solidity
error nullTopLayer();
```

### NotCoreMember

```solidity
error NotCoreMember(address who_);
```

### aDAOnot

```solidity
error aDAOnot();
```

### membraneNotFound

```solidity
error membraneNotFound();
```

### SubDAOLimitReached

```solidity
error SubDAOLimitReached();
```

### NonR

```solidity
error NonR();
```

### FailedToSetMembrane

```solidity
error FailedToSetMembrane();
```

