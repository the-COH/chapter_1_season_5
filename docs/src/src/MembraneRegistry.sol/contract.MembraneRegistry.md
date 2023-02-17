# MembraneRegistry
[Git Source](https://github.com/parseb/WalllaW/blob/9e3aa1f94078a6f713d193fa93b20149519f722a/src/MembraneRegistry.sol)


## State Variables
### MRaddress

```solidity
address MRaddress;
```


### ODAO

```solidity
IoDAO ODAO;
```


### iMR

```solidity
IMemberRegistry iMR;
```


### getMembraneById

```solidity
mapping(uint256 => Membrane) getMembraneById;
```


### usesMembrane

```solidity
mapping(address => uint256) usesMembrane;
```


## Functions
### constructor


```solidity
constructor(address ODAO_);
```

### createMembrane

creates membrane. Used to control and define.

To be read and understood as: Givent this membrane, of each of the tokens_[x], the user needs at least balances_[x].


```solidity
function createMembrane(address[] memory tokens_, uint256[] memory balances_, string memory meta_)
    public
    returns (uint256 id);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`tokens_`|`address[]`|ERC20 or ERC721 token addresses array. Each is used as a constituent item of the membrane and condition for|
|`balances_`|`uint256[]`|amounts required of each of tokens_. The order of required balances needs to map to token addresses.|
|`meta_`|`string`|anything you want. Preferably stable CID for reaching aditional metadata such as an IPFS hash of type string.|


### setMembrane

*consider negative as feature . [] <- isZero. sybil f*

*@security erc165 check*


```solidity
function setMembrane(uint256 membraneID_, address dao_) external returns (bool);
```

### setMembraneEndpoint


```solidity
function setMembraneEndpoint(uint256 membraneID_, address dao_, address owner_) external returns (bool);
```

### checkG

checks if a given address is member in a given DAO.

answers: Does who_ belong to DAO_?


```solidity
function checkG(address who_, address DAO_) public view returns (bool s);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`who_`|`address`|what address to check|
|`DAO_`|`address`|in what DAO or subDAO do you want to check if who_ b|


### gCheck

if any of the balances checks specified in the membrane fails, the membership token of checked address is burned

this is a defensive, think auto-imune mechanism.

*@todo retrace once again gCheck. Consider spam vectors.*


```solidity
function gCheck(address who_, address DAO_) external returns (bool s);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`who_`|`address`|checked address|
|`DAO_`|`address`||


### entityData

returns the meta field of a membrane given its id


```solidity
function entityData(uint256 id_) external view returns (string memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`id_`|`uint256`|membrane id_|


### getMembrane

returns the membrane given its id_


```solidity
function getMembrane(uint256 id_) external view returns (Membrane memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`id_`|`uint256`|id of membrane you want fetched|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`Membrane`|Membrane struct|


### isMembrane

checks if a given id_ belongs to an instantiated membrane


```solidity
function isMembrane(uint256 id_) external view returns (bool);
```

### inUseMembraneId

fetches the id of the active membrane for given provided DAO adress. Returns 0x0 if none.


```solidity
function inUseMembraneId(address DAOaddress_) public view returns (uint256 ID);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`DAOaddress_`|`address`|address of DAO (or subDAO) to retrieve mebrane id of|


### getInUseMembraneOfDAO

fetches the in use membrane of DAO


```solidity
function getInUseMembraneOfDAO(address DAOAddress_) public view returns (Membrane memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`DAOAddress_`|`address`|address of DAO (or subDAO) to retrieve in use Membrane of given DAO or subDAO address|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`Membrane`|Membrane struct|


### inUseUriOf

returns the uri or CID metadata of given DAO address


```solidity
function inUseUriOf(address DAOaddress_) external view returns (string memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`DAOaddress_`|`address`|address of DAO to fetch `.meta` of used membrane|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`string`|string|


## Events
### CreatedMembrane

```solidity
event CreatedMembrane(uint256 id, string metadata);
```

### ChangedMembrane

```solidity
event ChangedMembrane(address they, uint256 membrane);
```

### gCheckKick

```solidity
event gCheckKick(address indexed who);
```

## Errors
### Membrane__membraneNotFound

```solidity
error Membrane__membraneNotFound();
```

### Membrane__aDAOnot

```solidity
error Membrane__aDAOnot();
```

### Membrane__ExpectedODorD

```solidity
error Membrane__ExpectedODorD();
```

### Membrane__MembraneChangeLimited

```solidity
error Membrane__MembraneChangeLimited();
```

### Membrane__EmptyFieldOnMembraneCreation

```solidity
error Membrane__EmptyFieldOnMembraneCreation();
```

### Membrane__onlyODAOToSetEndpoint

```solidity
error Membrane__onlyODAOToSetEndpoint();
```

### Membrane__SomethingWentWrong

```solidity
error Membrane__SomethingWentWrong();
```

