# IMemberRegistry
[Git Source](https://github.com/parseb/WalllaW/blob/9e3aa1f94078a6f713d193fa93b20149519f722a/src/interfaces/IMember1155.sol)


## Functions
### makeMember


```solidity
function makeMember(address who_, uint256 id_) external returns (bool);
```

### gCheckBurn


```solidity
function gCheckBurn(address who_, address DAO_) external returns (bool);
```

### howManyTotal

onlyMembrane


```solidity
function howManyTotal(uint256 id_) external view returns (uint256);
```

### setUri


```solidity
function setUri(string memory uri_) external;
```

### uri


```solidity
function uri(uint256 id) external view returns (string memory);
```

### ODAOaddress


```solidity
function ODAOaddress() external view returns (address);
```

### MembraneRegistryAddress


```solidity
function MembraneRegistryAddress() external view returns (address);
```

### ExternalCallAddress


```solidity
function ExternalCallAddress() external view returns (address);
```

### getRoots


```solidity
function getRoots(uint256 startAt_) external view returns (address[] memory);
```

### getEndpointsOf


```solidity
function getEndpointsOf(address who_) external view returns (address[] memory);
```

### getActiveMembershipsOf


```solidity
function getActiveMembershipsOf(address who_) external view returns (address[] memory entities);
```

### getUriOf


```solidity
function getUriOf(address who_) external view returns (string memory);
```

### pushIsEndpoint


```solidity
function pushIsEndpoint(address) external;
```

### pushAsRoot


```solidity
function pushAsRoot(address) external;
```

### pushIsEndpointOf


```solidity
function pushIsEndpointOf(address dao_, address endpointOwner_) external;
```

### safeTransferFrom

Transfers `_value` amount of an `_id` from the `_from` address to the `_to` address specified (with safety call).

*Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
MUST revert if `_to` is the zero address.
MUST revert if balance of holder for token `_id` is lower than the `_value` sent.
MUST revert on any other error.
MUST emit the `TransferSingle` event to reflect the balance change (see "Safe Transfer Rules" section of the standard).
After the above conditions are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call `onERC1155Received` on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).*


```solidity
function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes calldata _data) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_from`|`address`|   Source address|
|`_to`|`address`|     Target address|
|`_id`|`uint256`|     ID of the token type|
|`_value`|`uint256`|  Transfer amount|
|`_data`|`bytes`|   Additional data with no specified format, MUST be sent unaltered in call to `onERC1155Received` on `_to`|


### safeBatchTransferFrom

Transfers `_values` amount(s) of `_ids` from the `_from` address to the `_to` address specified (with safety call).

*Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
MUST revert if `_to` is the zero address.
MUST revert if length of `_ids` is not the same as length of `_values`.
MUST revert if any of the balance(s) of the holder(s) for token(s) in `_ids` is lower than the respective amount(s) in `_values` sent to the recipient.
MUST revert on any other error.
MUST emit `TransferSingle` or `TransferBatch` event(s) such that all the balance changes are reflected (see "Safe Transfer Rules" section of the standard).
Balance changes and events MUST follow the ordering of the arrays (_ids[0]/_values[0] before _ids[1]/_values[1], etc).
After the above conditions for the transfer(s) in the batch are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call the relevant `ERC1155TokenReceiver` hook(s) on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).*


```solidity
function safeBatchTransferFrom(
    address _from,
    address _to,
    uint256[] calldata _ids,
    uint256[] calldata _values,
    bytes calldata _data
) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_from`|`address`|   Source address|
|`_to`|`address`|     Target address|
|`_ids`|`uint256[]`|    IDs of each token type (order and length must match _values array)|
|`_values`|`uint256[]`| Transfer amounts per token type (order and length must match _ids array)|
|`_data`|`bytes`|   Additional data with no specified format, MUST be sent unaltered in call to the `ERC1155TokenReceiver` hook(s) on `_to`|


### balanceOf

Get the balance of an account's tokens.


```solidity
function balanceOf(address _owner, uint256 _id) external view returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_owner`|`address`| The address of the token holder|
|`_id`|`uint256`|    ID of the token|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The _owner's balance of the token type requested|


### balanceOfBatch

Get the balance of multiple account/token pairs


```solidity
function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_owners`|`address[]`|The addresses of the token holders|
|`_ids`|`uint256[]`|   ID of the tokens|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256[]`|The _owner's balance of the token types requested (i.e. balance for each (owner, id) pair)|


### setApprovalForAll

Enable or disable approval for a third party ("operator") to manage all of the caller's tokens.

*MUST emit the ApprovalForAll event on success.*


```solidity
function setApprovalForAll(address _operator, bool _approved) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_operator`|`address`| Address to add to the set of authorized operators|
|`_approved`|`bool`| True if the operator is approved, false to revoke approval|


### isApprovedForAll

Queries the approval status of an operator for a given owner.


```solidity
function isApprovedForAll(address _owner, address _operator) external view returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_owner`|`address`|    The owner of the tokens|
|`_operator`|`address`| Address of authorized operator|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|True if the operator is approved, false if not|


