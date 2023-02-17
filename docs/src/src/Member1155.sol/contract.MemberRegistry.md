# MemberRegistry
[Git Source](https://github.com/parseb/WalllaW/blob/9e3aa1f94078a6f713d193fa93b20149519f722a/src/Member1155.sol)

**Inherits:**
ERC1155


## State Variables
### ODAOaddress

```solidity
address public ODAOaddress;
```


### MembraneRegistryAddress

```solidity
address public MembraneRegistryAddress;
```


### ExternalCallAddress

```solidity
address public ExternalCallAddress;
```


### oDAO

```solidity
IoDAO oDAO;
```


### IMB

```solidity
IMembrane IMB;
```


### endpointsOf

```solidity
mapping(address => address[]) endpointsOf;
```


### tokenUri

```solidity
mapping(uint256 => string) tokenUri;
```


### uidTotalSupply

```solidity
mapping(uint256 => uint256) uidTotalSupply;
```


### idsOf

```solidity
mapping(address => uint256[]) idsOf;
```


## Functions
### constructor


```solidity
constructor();
```

### onlyDAO


```solidity
modifier onlyDAO();
```

### onlyMembraneR


```solidity
modifier onlyMembraneR();
```

### makeMember

mints membership token to provided address


```solidity
function makeMember(address who_, uint256 id_) external onlyDAO returns (bool);
```

### setUri

the id_ of any subunit  is a multiple of DAO address

*
does not yet have member token
if first member to join, fetch cell metadata*


```solidity
function setUri(string memory uri_) external onlyDAO;
```

### uri


```solidity
function uri(uint256 id) public view override returns (string memory);
```

### getUriOf


```solidity
function getUriOf(address who_) external view returns (string memory);
```

### getActiveMembershipsOf

retrieves base DAOs


```solidity
function getActiveMembershipsOf(address who_) external view returns (address[] memory entities);
```

### pushIsEndpointOf


```solidity
function pushIsEndpointOf(address dao_, address endpointOwner_) external;
```

### safeTransferFrom


```solidity
function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) public override;
```

### gCheckBurn

custom burn for gCheck functionality


```solidity
function gCheckBurn(address who_, address DAO_) external onlyMembraneR returns (bool);
```

### howManyTotal

how many tokens does the given id_ has. Useful for checking how many members a DAO has.

id_ is always the uint(address of DAO)


```solidity
function howManyTotal(uint256 id_) public view returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`id_`|`uint256`|id to check how many minted tokens it has associated|


### _mint


```solidity
function _mint(address to, uint256 id, uint256 amount, bytes memory data) internal override;
```

### _burn


```solidity
function _burn(address from, uint256 id, uint256 amount) internal override;
```

### _batchBurn


```solidity
function _batchBurn(address from, uint256[] memory ids, uint256[] memory amounts) internal override;
```

### _batchMint


```solidity
function _batchMint(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) internal override;
```

### getEndpointsOf


```solidity
function getEndpointsOf(address ofWhom_) external view returns (address[] memory);
```

### safeBatchTransferFrom


```solidity
function safeBatchTransferFrom(
    address from,
    address to,
    uint256[] calldata ids,
    uint256[] calldata amounts,
    bytes calldata data
) public override;
```

## Events
### isNowMember

```solidity
event isNowMember(address who, uint256 id, address dao);
```

## Errors
### MR1155_Untransferable

```solidity
error MR1155_Untransferable();
```

### MR1155_onlyOdao

```solidity
error MR1155_onlyOdao();
```

### MR1155_UnregisteredDAO

```solidity
error MR1155_UnregisteredDAO();
```

### MR1155_UnauthorizedID

```solidity
error MR1155_UnauthorizedID();
```

### MR1155_InvalidMintID

```solidity
error MR1155_InvalidMintID();
```

### MR1155_AlreadyIn

```solidity
error MR1155_AlreadyIn();
```

### MR1155_OnlyMembraneRegistry

```solidity
error MR1155_OnlyMembraneRegistry();
```

### MR1155_OnlyODAO

```solidity
error MR1155_OnlyODAO();
```

