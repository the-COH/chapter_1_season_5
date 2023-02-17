# DAO20
[Git Source](https://github.com/parseb/WalllaW/blob/9e3aa1f94078a6f713d193fa93b20149519f722a/src/DAO20.sol)

**Inherits:**
ERC20

**Author:**
Solmate (https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC1155.sol)

Minimalist and gas efficient standard ERC1155 implementation.


## State Variables
### owner

```solidity
address public owner;
```


### base

```solidity
address public base;
```


### burnInProgress

```solidity
address public burnInProgress;
```


### baseToken

```solidity
IERC20 baseToken;
```


## Functions
### constructor


```solidity
constructor(address baseToken_, string memory name_, string memory symbol_, uint8 decimals_) ERC20(name_, symbol_);
```

### OnlyOwner


```solidity
modifier OnlyOwner();
```

### wrapMint


```solidity
function wrapMint(uint256 amt) external returns (bool s);
```

### unwrapBurn


```solidity
function unwrapBurn(uint256 amtToBurn_) external returns (bool s);
```

### unwrapBurn


```solidity
function unwrapBurn(address from_, uint256 amtToBurn_) external OnlyOwner;
```

### inflationaryMint


```solidity
function inflationaryMint(uint256 amt) public OnlyOwner returns (bool);
```

### mintInitOne


```solidity
function mintInitOne(address to_) external returns (bool);
```

### transfer

////////////////////
Override //////////////
there's some potential attack vectors on inflation and redistributive signals (re-enterange like)
two options: embrace the messiness |OR| allow transfers only to owner and sub-entities


```solidity
function transfer(address to, uint256 amount) public override returns (bool);
```

### transferFrom

limit transfers


```solidity
function transferFrom(address from, address to, uint256 amount) public override returns (bool);
```

## Errors
### NotOwner

```solidity
error NotOwner();
```

