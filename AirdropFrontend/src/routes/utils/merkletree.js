import MerkleTree from "merkletreejs";
import { ethers } from "ethers";
// import keccak256 from "keccak256";
import { Buffer } from "buffer/";

const TOKEN_DECIMALS = 18;

// Helper function to generate leafs
export const  generateLeaf = (address, value) => {
  return Buffer.from(
    // Hash in appropriate Merkle format
    ethers.utils
      .solidityKeccak256(["address", "uint256"], [address, value])
      .slice(2),
    "hex",
  );
}


// Setup merkle tree
export const generateMerkleTree = (airdrop) => {
  return new MerkleTree(
    Object.entries(airdrop).map(([address, allocation]) =>
      generateLeaf(
        ethers.utils.getAddress(address),
        ethers.utils
          .parseUnits(
            (
              100
            ).toString(),
            TOKEN_DECIMALS,
          )
          .toString(),
      ),
    ),
    // keccak256,
    ethers.utils.keccak256,
    {
      sortPairs: true,
    },
  );
}

// This is a port of the verify logic in  packages\hardhat\src\MerkleProof.sol
export const  verify = (
  proof,
  root,
  leaf
) => {
  let computedHash = Buffer.from(leaf.slice(2), "hex");
  let index = 0;

  for (let i = 0; i < proof.length; i++) {
    index *= 2;
    const proofElement = Buffer.from(proof[i].slice(2), "hex");

    if (computedHash.toString("hex") <= proofElement.toString("hex")) {
      // Hash(current computed hash + current element of the proof)
      computedHash = Buffer.from(
        ethers.utils
          .solidityKeccak256(
            ["bytes32", "bytes32"],
            [
              "0x" + computedHash.toString("hex").padStart(64, "0"),
              "0x" + proofElement.toString("hex").padStart(64, "0"),
            ],
          )
          .slice(2),
        "hex",
      );
    } else {
      // Hash(current element of the proof + current computed hash)
      computedHash = Buffer.from(
        ethers.utils
          .solidityKeccak256(
            ["bytes32", "bytes32"],
            [
              "0x" + proofElement.toString("hex").padStart(64, "0"),
              "0x" + computedHash.toString("hex").padStart(64, "0"),
            ],
          )
          .slice(2),
        "hex",
      );

      index += 1;
    }
  }

  // Check if the computed hash (root) is equal to the provided root
  return ["0x" + computedHash.toString("hex") === root, index];
}

export const getMerkleTreeValues = (
  merkleTree,
  address,
  tokenAmount
) => {
  const numTokens = ethers.utils
    .parseUnits(tokenAmount.toString(), TOKEN_DECIMALS)
    .toString();

  const leaf = generateLeaf(ethers.utils.getAddress(address), numTokens);
  const proof = merkleTree.getHexProof(leaf);

  return { leaf, proof, numTokens };
}