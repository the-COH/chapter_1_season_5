//SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "./interfaces/IERC20.sol";
import "./utils/BitMaps.sol";
import "./utils/MerkleProof.sol";

contract WlWDrop {
    using BitMaps for BitMaps.BitMap;

    BitMaps.BitMap private claimed;

    bytes32 public merkleRoot;
    uint256 public claimPeriodEnds;

    IERC20 public immutable WlW;
    address owner;

    event MerkleRootChanged(bytes32 _merkleRoot);
    event Claim(address indexed _claimant, uint256 _amount);

    error Address0Error();
    error InvalidProof();
    error AlreadyClaimed();
    error ClaimEnded();
    error ClaimNotEnded();
    error InitError();
    error NotBoss();

    constructor(uint256 _claimPeriodEnds, address _walllawToken) {
        if (_walllawToken == address(0)) revert Address0Error();
        claimPeriodEnds = _claimPeriodEnds;
        WlW = IERC20(_walllawToken);
        owner = msg.sender;
    }

    function verify(bytes32[] calldata _proof, bytes32 _leaf) public view returns (bool, uint256) {
        return MerkleProof.verify(_proof, merkleRoot, _leaf);
    }

    function claimTokens(uint256 _amount, bytes32[] calldata _merkleProof) external {
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender, _amount));
        (bool valid, uint256 index) = verify(_merkleProof, leaf);
        if (!valid) revert InvalidProof();
        if (isClaimed(index)) revert AlreadyClaimed();
        if (block.timestamp > claimPeriodEnds) revert ClaimEnded();

        claimed.set(index);
        emit Claim(msg.sender, _amount);

        WlW.transfer(msg.sender, _amount);
    }

    function isClaimed(uint256 _index) public view returns (bool) {
        return claimed.get(_index);
    }

    function setMerkleRoot(bytes32 _merkleRoot) external {
        if (msg.sender != owner) revert NotBoss();
        if (merkleRoot != bytes32(0)) revert InitError();
        merkleRoot = _merkleRoot;
        delete owner;
        emit MerkleRootChanged(_merkleRoot);
    }
}
