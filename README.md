# St3mz

## A platform for music NFT's in the Canto blockchain

**Live app**: https://st3mz-dapp.web.app

**Video demo**: https://youtu.be/qZPVEmK6dTE

This project consists of two **repositories**:

- [st3mz-core](https://github.com/St3mz/st3mz-core): Smart contracts, tests and deployment script.
- [st3mz-ui](https://github.com/St3mz/st3mz-ui): UI for interaction with the smart contracts.

# Overview 👀

St3mz is a platform that allows artists to publish their music in the form of NFTs in the Canto blockchain, so that other users can buy them acquiring also the rights to use the music with different levels of freedom.

Each **NFT** is composed of:

- A main audio track
- Multitrack files (stems) that form the main audio track
- An image artwork
- The metadata related with the audio track

These files are stored in the **Filecoin decentralized storage network** to ensure permanent persistence of the data. This, together with the proof of creation that the multitrack files offer, ensures that an artist can demonstrate that is the rightful creator of the material.

The metadata of the NFT includes a **licenses** property. Here the creator can specify up to three different kinds of licenses and the minimum amount of units a user will require owning to exercise the rights granted by that license. These are the three types of licenses available:

- **Basic**: Does NOT allow commercial use.
- **Commercial**: Allows commercial use. The rights over the material are shared
  with other people.
- **Exclusive**: Exclusive rights over the material with no limitations.

We can see how this works with an example. Let's assume that we have an NFT with a total supply of 10 units and these values in its metadata file:

```json
  "licenses": [
    {
      "type": "Basic",
      "tokensRequired": 1
    },
    {
      "type": "Commercial",
      "tokensRequired": 3
    },
    {
      "type": "Exclusive",
      "tokensRequired": 10
    }
  ]
```

This means that a user that just want to own the audio NFT as a collectible can do so buying just one unit. However, if that user wanted to use the track to create a remix and publish it in their new album, they would require buying three units of the NFT. Finally, if the purpose is to have exclusive rights over the piece so that nobody else can use it with commercial purposes they would require to buy the whole supply.

# Technologies used 🔧

## Front end

The front end application has been created with JavaScript's [React](https://reactjs.org/) framework, using the scaffolding project [Create React App](https://create-react-app.dev/).

The application also makes use of [Tailwind CSS](https://tailwindcss.com/) framework.

## Smart contracts

The smart contracts have been written in [Solidity 0.8.17](https://docs.soliditylang.org/en/v0.8.17/) and [Foundry](https://book.getfoundry.sh/) development toolchain has been used for testing and deployment.

## Storage

The NFT files (audios, image and metadata) are stored in [Filecoin](https://filecoin.io/) and made available over [IPFS](https://ipfs.tech/) with the [NFT.Storage](https://nft.storage/) service.

NFT.Storage IPFS's gateway is used to access the stored files.

# Smart contracts 📃

## St3mz

NFT contract based on the ERC1155 standard, but adapted to be transferable just once (when it is bought). This ensures that the buyer cannot resale the NFT after they have exercised the licensing rights associated with its purchase.

The creator sets the supply and unit price for the token at the moment of minting.

## St3mzUtil

This is a utility contract to perform read-only operations over the St3mz contract.

## Testnet contracts

**St3mz.sol**: [0x83B533033AfAad8dDda4D17a3BbEAae3A37911E1](https://testnet-explorer.canto.neobase.one/address/0x83B533033AfAad8dDda4D17a3BbEAae3A37911E1/contracts#address-tabs)

**St3mzUtil.sol**: [0xa6E1761c9f8d100364425b6EDfc89c1Ea82FDd33](https://testnet-explorer.canto.neobase.one/address/0xa6E1761c9f8d100364425b6EDfc89c1Ea82FDd33/contracts#address-tabs)
