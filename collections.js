const collections = [
    {
      name: "Cantillionaires",
      active: true,
      address: "0xa31b1531489eDf96a31ea2De5eF252be89038C68",
      abi: [
        "function tokensOfOwner(address owner) public view returns (uint256[])",
        "function tokenURI(uint256 tokenId) public view returns (string memory)"
      ],
      fns: [
        { name: "tokenIdsHeld", fn: (contract, address) => { return contract.tokensOfOwner(address); }},
        { name: "tokenURI", fn: (contract, tokenId) => { return contract.tokenURI(tokenId); }}
      ]
    },
    {
      name: "Canto Longnecks",
      active: false,
      address: "0xC0C73CcFEE66eb400acCee23Fe70369186e4D3C9",
      abi: [
        "function balanceOf(address holder) public view returns (uint256 memory)",
        "function tokenURI(uint256 tokenId) public view returns (string memory)"
      ],
      fns: [
        { name: "tokenIdsHeld", fn: (contract, address) => { return contract.balanceOf(address); } },
        { name: "tokenURI", fn: (contract, tokenId) => { return contract.tokenURI(tokenId); } }
      ]
    },
    {
      name: "Canto Waifus",
      active: false,
      address: "0x1371c76e09de58d15fc15a319e71f8da2f62cf7b",
      abi: [
        "function tokenIdsHeld(address holder) public view returns (uint256[] memory)",
        "function tokenURI(uint256 tokenId) public view returns (string memory)"
      ],
      fns: [
        { name: "tokenIdsHeld", fn: (contract, address) => { return contract.tokenIdsHeld(address); }},
        { name: "tokenURI", fn: (contract, tokenId) => { return contract.tokenURI(tokenId); } }
      ]
    },
    // {
    //   name: "Ralph Lavelle NFT", // testing Polygon
    //   address: "0xaf6081617fbb268eb7b48d4e34cb1f175edf2864",
    //   abi: ["function balanceOf(address owner_) public view virtual returns (uint256)"],
    //   fn: (contract, address) => { return contract.balanceOf(address); }
    // }
];
export default collections;