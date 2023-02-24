

### Pre-Requisites

**1. Install Flow CLI**
:warning: Requires installation of [Flow CLI](https://github.com/onflow/flow-cli/releases/tag/v0.45.1-cadence-attachments-3) (Attachments/AuthAccount Capability pre-release version).

```sh
sh -ci "$(curl -fsSL https://raw.githubusercontent.com/onflow/flow-cli/master/install.sh)" -- v0.45.1-cadence-attachments-3
```

**2. Clone Flow dev-wallet**
It's required to clone and run [Flow dev-wallet](https://github.com/onflow/fcl-dev-wallet) from source rather than CLI until release of Emulator alpha features. Before using the dev wallet, you'll need to start the Flow emulator.

```sh
git clone https://github.com/onflow/fcl-dev-wallet.git
```

:bookmark: The variables defined in your this repo's flow.json file and .env files should match the addresses and keys of your emulator-account. For details about flow.json visit the [flow-cli configuration reference](https://docs.onflow.org/flow-cli/configuration/).

**3. Copy `emulator.private.json.example` and `testnet.private.json.example`**

```sh
cp emulator.private.json.example emulator.private.json
cp testnet.private.json.example testnet.private.json
```

:bookmark: Update with your own key data.

**4. Copy the .env-example file to .env and update the required values.**

```sh
cp .env-example .env
```

:warning: App requires several `env` vars for development and deployment. Credentials and API keys can be acquired through their respective providers. See `.env-example` for details

#### Service Providers

- Stripe (Used for NFT Purchase): [https://stripe.com/docs/development](https://stripe.com/docs/development)
- Google (Used as Next Auth Provider): [https://developers.google.com/identity/protocols/oauth2/openid-connect](https://developers.google.com/identity/protocols/oauth2/openid-connect)

### Run Demo Locally

- Start the emulator

```sh
flow emulator start
```

- Start the Dev Wallet (From a new terminal window)

```sh
cd fcl-dev-wallet
PORT=8701 npm run dev
```


- Start dev server to deploy the contracts and configure the service account (From a new terminal window)

```sh
npm run dev:local:deploy
```

This command will start the dev server and deploy the contracts to the emulator. It will also configure the service account with the required capabilities.

### Deployment

Refer to `testnet-account` deployment from `flow.json` to deploy required contracts to your own game admin account.
This account will need a Flow balance for use in account creation and transaction fees.

Once contracts are deployed to your admin accounts, update the `NEXT_PUBLIC_ADMIN_ADDRESS` and `NEXT_PUBLIC_ADMIN_KEY_INDEX` env vars in your on your deployment platform.

Run the following transaction to configure the admin account with the required capabilities:

```shell
flow transactions send --network=testnet --signer testnet-account cadence/transactions/child_account/setup_child_account_creator.cdc
```

#### Environment variables and Configuration
The following env vars are required for deployment:
**Public**
- `NEXT_PUBLIC_VERCEL_URL`: Your Vercel URL (ex: https://walletless-arcade-game.vercel.app)
- `NEXT_PUBLIC_ADMIN_ADDRESS`: The address of the admin account where game and prize contracts are deployed
- `NEXT_PUBLIC_ADMIN_KEY_INDEX`: The key index of the admin account where game and prize contracts are deployed
- `NEXTAUTH_URL`: Your Vercel URL (ex: https://walletless-arcade-game.vercel.app)
- `NEXTAUTH_SECRET`: A random string is used to hash tokens, sign/encrypt cookies and generate cryptographic keys. You can generate the secret via `openssl rand -base64 32` on Linux
- `NEXT_PUBLIC_FLOW_NETWORK`: The network you are deploying to (ex: testnet)
- `NEXT_PUBLIC_MARKETPLACE_URL`: The URL of the prize marketplace (ex: https://walletless-arcade-prize-market.vercel.app)

**Private**
- `ADMIN_PRIVATE_KEY_HEX`: The private key of the admin account where game and prize contracts are deployed
- `GOOGLE_CLIENT_SECRET`: The Google Client Secret. Used as Provider for NextAuth
- `GOOGLE_CLIENT_ID`: The Google Client ID. Used as Provider for NextAuth
- `STRIPE_SK`: The Stripe Secret Key. Used for NFT Purchase
