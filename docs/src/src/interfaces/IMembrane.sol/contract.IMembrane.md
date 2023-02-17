# IMembrane
[Git Source](https://github.com/parseb/WalllaW/blob/9e3aa1f94078a6f713d193fa93b20149519f722a/src/interfaces/IMembrane.sol)


## Functions
### getMembrane


```solidity
function getMembrane(uint256 id) external view returns (Membrane memory);
```

### setMembrane


```solidity
function setMembrane(uint256 membraneID_, address DAO_) external returns (bool);
```

### setMembraneEndpoint


```solidity
function setMembraneEndpoint(uint256 membraneID_, address subDAOaddr, address owner) external returns (bool);
```

### inUseMembraneId


```solidity
function inUseMembraneId(address DAOaddress_) external view returns (uint256 Id);
```

### inUseUriOf


```solidity
function inUseUriOf(address DAOaddress_) external view returns (string memory);
```

### getInUseMembraneOfDAO


```solidity
function getInUseMembraneOfDAO(address DAOAddress_) external view returns (Membrane memory);
```

### createMembrane


```solidity
function createMembrane(address[] memory tokens_, uint256[] memory balances_, string memory meta_)
    external
    returns (uint256);
```

### isMembrane


```solidity
function isMembrane(uint256 id_) external view returns (bool);
```

### checkG


```solidity
function checkG(address who, address DAO_) external view returns (bool s);
```

### gCheck


```solidity
function gCheck(address who_, address DAO_) external returns (bool);
```

### entityData


```solidity
function entityData(uint256 id_) external view returns (string memory);
```

## Structs
### Membrane

```solidity
struct Membrane {
    address[] tokens;
    uint256[] balances;
    bytes meta;
}
```

