# ExternalCall
[Git Source](https://github.com/parseb/WalllaW/blob/9e3aa1f94078a6f713d193fa93b20149519f722a/src/ExternalCall.sol)

**Inherits:**
[IExternalCall](/src/interfaces/IExternalCall.sol/contract.IExternalCall.md)


## State Variables
### ODAO

```solidity
IoDAO ODAO;
```


### externalCallById

```solidity
mapping(uint256 => ExtCall) externalCallById;
```


### lastExecutedorCreatedAt
id of call => address of dao => lastExecuted


```solidity
mapping(uint256 => mapping(address => uint256)) lastExecutedorCreatedAt;
```


### nonce
dao nonce


```solidity
mapping(address => uint256) nonce;
```


## Functions
### constructor


```solidity
constructor(address odao_);
```

### onlyDAO


```solidity
modifier onlyDAO();
```

### createExternalCall


```solidity
function createExternalCall(address[] memory contracts_, bytes[] memory callDatas_, string memory description_)
    external
    returns (uint256 idOfNew);
```

### updateLastExecuted


```solidity
function updateLastExecuted(uint256 whatExtCallId_) external onlyDAO returns (bool);
```

### incrementSelfNonce


```solidity
function incrementSelfNonce() external onlyDAO;
```

### getExternalCallbyID


```solidity
function getExternalCallbyID(uint256 id_) external view returns (ExtCall memory);
```

### isValidCall


```solidity
function isValidCall(uint256 id_) external view returns (bool);
```

### getNonceOf


```solidity
function getNonceOf(address whom_) external view returns (uint256);
```

## Events
### NewExternalCall

```solidity
event NewExternalCall(address indexed CreatedBy, string description, uint256 createdAt);
```

## Errors
### ExternalCall_UnregisteredDAO

```solidity
error ExternalCall_UnregisteredDAO();
```

### ExternalCall_CallDatasContractsLenMismatch

```solidity
error ExternalCall_CallDatasContractsLenMismatch();
```

