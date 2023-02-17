# Aura Safe

Aura-Safe is a multi-signature platform for Cosmos-based blockchain.

If you are familliar with [Gnosis-safe](https://gnosis-safe.io/) for Ethereum, we try to reuse as much as possible the UX of the gnosis web app as it is really clean and straightforward to use. However, the architecture design and workflow of Aura Safe is totally independent from Gnosis. Aura Safe works only with Cosmos-based blockchains.

## How to use
Aura-Safe is still in development, you can check out the latest deployed Dev version in the Deployed environment section.

#### Prerequisites
We use [yarn](https://yarnpkg.com/) in our infrastructure, so we decided to go with yarn in the README. Please install yarn globally if you haven't already.

### 1. Clone the repository
```bash
git clone https://github.com/aura-nw/safe-react
```
### 2. Enter to project folder
```bash
cd safe-react
```
### 3. Install Dependencies
```bash
yarn install
```
### 4. Run app
```bash
npm start
 ```
### 5. Add test-net to Keplr
After the app is started, open browser's dev tool by press F12 button or right click then choose Inspect, then click on Console tab and follow the instruction [here](https://github.com/aura-nw/safe-react/blob/dev/CONNECT_KEPLR.md) to add Aura test-net to Keplr

## Setup for developments
Aura-safe use Nodejs, please make sure installed it.

## Related repos

- [multisig-api](https://github.com/aura-nw/multisig-api)
- [multisig-sync](https://github.com/aura-nw/multisig-sync)

## Deployed environments

- Dev: https://safe.dev.aura.network/
- Test: https://safe.serenity.aura.network/

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
