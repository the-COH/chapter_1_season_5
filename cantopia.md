# Cantopia

Cantopia is the decentralized homepage for Canto. 

Users can find and use all apps for Canto in a single place: core apps, DeFi, NFT mints, etc

Devs can view the source code of apps (frontends for Canto protocols), fork them, and deploy their own version. All of the app code (HTML/CSS/JS)  is stored on the NEAR blockchain, creating a trust-minimized experience for users and devs. 

If we win the hackathon (and even if we don't) we will use all of the funds to launch a bounty program to get high quality, trustless frontends built for the top Canto protocols!


## How it Works

Cantopia is made up of three parts:

### Gateway ([cantopia.pages.dev](https://cantopia.pages.dev))
The gateway is a web app with a specially designed virtual machine that loads and runs frontends for Canto protocols. The code for these frontends is stored on the NEAR blockchain.

### Apps
In Cantopia, "apps" are frontends for Canto protocols that are stored entirely on-chain. The code for these apps can be viewed in a gateway, similar to viewing a smart contract in Etherscan. Developers can fork these apps and deploy their own versions, or even compose apps together ([see this as an example](https://cantopia.pages.dev/#/mattlock.near/widget/canto-landing-page))

### Blockchains
All apps on Cantopia point to the Canto blockchain (naturally). Cantopia apps are interfaces for smart contracts on Canto. The source code for the apps (frontends) is on NEAR, due to it's ability to very cheaply store HTML/CSS/JS (a few cents).
