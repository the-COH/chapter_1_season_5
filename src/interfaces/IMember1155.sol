// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./structs.sol";

interface IMemberRegistry {
    function makeMember(address who_, uint256 id_) external returns (bool);

    function gCheckBurn(address who_, address DAO_) external returns (bool);

    /// onlyMembrane
    function howManyTotal(uint256 id_) external view returns (uint256);
    function setUri(string memory uri_) external;
    function uri(uint256 id) external view returns (string memory);

    function ODAOaddress() external view returns (address);
    function MembraneRegistryAddress() external view returns (address);
    function ExternalCallAddress() external view returns (address);

    function getRoots(uint256 startAt_) external view returns (address[] memory);
    function getEndpointsOf(address who_) external view returns (address[] memory);

    function getActiveMembershipsOf(address who_) external view returns (address[] memory entities);
    function getUriOf(address who_) external view returns (string memory);
    //// only ODAO

    function pushIsEndpoint(address) external;
    function pushAsRoot(address) external;
    //////////////////////// ERC1155

    ///// only odao
    function pushIsEndpointOf(address dao_, address endpointOwner_) external;

    /**
     * @notice Transfers `_value` amount of an `_id` from the `_from` address to the `_to` address specified (with safety call).
     *     @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
     *     MUST revert if `_to` is the zero address.
     *     MUST revert if balance of holder for token `_id` is lower than the `_value` sent.
     *     MUST revert on any other error.
     *     MUST emit the `TransferSingle` event to reflect the balance change (see "Safe Transfer Rules" section of the standard).
     *     After the above conditions are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call `onERC1155Received` on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).
     *     @param _from    Source address
     *     @param _to      Target address
     *     @param _id      ID of the token type
     *     @param _value   Transfer amount
     *     @param _data    Additional data with no specified format, MUST be sent unaltered in call to `onERC1155Received` on `_to`
     */
    function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes calldata _data) external;

    /**
     * @notice Transfers `_values` amount(s) of `_ids` from the `_from` address to the `_to` address specified (with safety call).
     *     @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
     *     MUST revert if `_to` is the zero address.
     *     MUST revert if length of `_ids` is not the same as length of `_values`.
     *     MUST revert if any of the balance(s) of the holder(s) for token(s) in `_ids` is lower than the respective amount(s) in `_values` sent to the recipient.
     *     MUST revert on any other error.
     *     MUST emit `TransferSingle` or `TransferBatch` event(s) such that all the balance changes are reflected (see "Safe Transfer Rules" section of the standard).
     *     Balance changes and events MUST follow the ordering of the arrays (_ids[0]/_values[0] before _ids[1]/_values[1], etc).
     *     After the above conditions for the transfer(s) in the batch are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call the relevant `ERC1155TokenReceiver` hook(s) on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).
     *     @param _from    Source address
     *     @param _to      Target address
     *     @param _ids     IDs of each token type (order and length must match _values array)
     *     @param _values  Transfer amounts per token type (order and length must match _ids array)
     *     @param _data    Additional data with no specified format, MUST be sent unaltered in call to the `ERC1155TokenReceiver` hook(s) on `_to`
     */
    function safeBatchTransferFrom(
        address _from,
        address _to,
        uint256[] calldata _ids,
        uint256[] calldata _values,
        bytes calldata _data
    ) external;

    /**
     * @notice Get the balance of an account's tokens.
     *     @param _owner  The address of the token holder
     *     @param _id     ID of the token
     *     @return        The _owner's balance of the token type requested
     */
    function balanceOf(address _owner, uint256 _id) external view returns (uint256);

    /**
     * @notice Get the balance of multiple account/token pairs
     *     @param _owners The addresses of the token holders
     *     @param _ids    ID of the tokens
     *     @return        The _owner's balance of the token types requested (i.e. balance for each (owner, id) pair)
     */
    function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids)
        external
        view
        returns (uint256[] memory);

    /**
     * @notice Enable or disable approval for a third party ("operator") to manage all of the caller's tokens.
     *     @dev MUST emit the ApprovalForAll event on success.
     *     @param _operator  Address to add to the set of authorized operators
     *     @param _approved  True if the operator is approved, false to revoke approval
     */
    function setApprovalForAll(address _operator, bool _approved) external;

    /**
     * @notice Queries the approval status of an operator for a given owner.
     *     @param _owner     The owner of the tokens
     *     @param _operator  Address of authorized operator
     *     @return           True if the operator is approved, false if not
     */
    function isApprovedForAll(address _owner, address _operator) external view returns (bool);
}
