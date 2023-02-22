# Vision

Simplifying crypto options trading for retail as well as institutions with efficient pricing and undercollateralized credit to improve on-chain liquidity, effectively manage risk, and reduce costs.

# Description

DeFi Options DAO (DOD), an options DEX protocol, solves the common problems with on-chain options by bringing together the best of AMM and orderbook designs.

Crypto options have great potential, but have not found mass adoption.

Cryptocurrencies are worth an aggregate US$1.2 trillion today, with over US$60 billion traded daily in the crypto-coins and the futures contracts based on these coins. The derivatives market on cryptocurrencies and digital assets is just starting to take shape. While crypto futures contracts on centralized exchanges are well-established, the crypto community has yet to settle on a good options product and trading venue owing to several problems.

# Problems with AMMs:

- Liquidity fragmentation

- LP directional risk

- Inefficient prices

# Problems with orderbook:

- Latency

- Costs of updating orders

# Problems with centralized exchanges:

- Obscured counterparty risk

- Divided communities

# DOD is designed to allow the crypto options market to truly take off.

DOD allows market makers (MMs) to spin up their own on-chain peer-to-pool options trading liquidity pool (LP) where they control the rules (i.e set traded underlying assets, select price oracles, define pricing models, determine trading spreads, define hedging strategy, adjust permissions for traders and LPs, etc).

Besides being able to control the rules, and earning trading fees from users, MMs also earn performance fees from other pool LPs if they decide to make the pool available.

Options are cash-settable European. LPs are stablecoin-based, so one pool is able to support an infinite number of underlying assets as long as we have feed and LPs are willing to take the risk. The pools are already able to auto-hedge pool exposure using perp protocols.

# New innovation with DOD v2

    Ability to have unique collateral management per underlying

    Creating governance governable liquidity pools/operations

    Multi-stablecoin withdrawal swap for multiple stablecoins out of exchange balance in a proper ERC20 that users can transfer to others via cold wallet

    Spread collateral requirements through all writers (rebates and increases)

    Pools can write options against borrowed liquidity

    New credit token redemption process

    Incentivization for all exchange operations (eg: liquidations, feed updates, etc)

    Able to have DEX TWAP oracle (as well as oracles from any DAO-approved source)

    Pools are able to hedge option writing on DAO-approved external protocol

    Portfolio margin for collateral requirements


# DOD’s unique value proposition paves way for the following competitive advantages:

    Our infrastructure enables for a flexible model where MMs can price options as they deem fit.

    We're making counterparty risks more transparent using blockchain infrastructure for MMs.

    We allow traders to gain exposure efficiently across many different AMMs and/or MMs.

    We allow MMs and traders to originate credit on-chain that doesn’t have to be strictly dependent on off-chain credit supply. By having a way to keep track of who is owed what, we don’t have to be strictly reliant upon both sides of the trade being fully collateralized (especially with pools that hedge).

    By using our unique undercollateralized trading solution, we help increase liquidity in on-chain derivatives as well as in the spot market on DEXs that trade against the exchange credit.

    We're creating a community of different actors in DeFi who are interested in pricing out risk and enabling price discovery with derivatives in DeFi.


# Revenue model

Our revenue model is centered around our exchange and its offerings. We aim to generate revenue from option settlement and liquidation fees, as well as from the liquidity pools. The traders using our platform are responsible for managing their own profit and loss and risk, which aligns with our commitment to providing a robust and transparent trading experience. On Canto, CSR will also provide a considerable amount of revenue for the DAO.

# Roadmap for growth & sustainability

    Onboard MMs & external partners (AMMs, risk management protocols)

    v2 testnet trading contest & v2 audit

    v2 mainnet deployment

    Expand available hedging managers with external protocols

    Expand frontend to simplify protocol interactions

    Research better margin/collateral framework (i.e. ISDA SIMM, etc)

    Research better fee framework to dynamically maximize trading volume, swap volume, DAO yield, and minimize collateral outflows

    Implementation of research with v3


# User acquisition plan & GTM strategy

Our user base includes all kinds of actors in the derivatives market - traders, market makers, liquidity providers on DEXs against stablecoins. Our GTM strategy involves organizing trading contests, market making contests and incentives for providing liquidity on DEXs against our exchange balance token.

Our user acquisition strategy focuses on incentivizing traders and market makers through governance tokens in both live and testnet environments through trading contests. This approach not only rewards users for their engagement with our platform, but also helps to build a strong community of active traders and liquidity providers.

In addition, we aim to provide unique advantages to our users through our innovative credit system, which enables market makers to borrow collateral from the exchange and pool it into their liquidity pools when using on-chain hedging contracts. This system also allows for option settlement and liquidation fees to be paid out to general depositors, further increasing the benefits of using our platform.

# Anticipated growth metrics and traction

We expect to see significant growth when we launch v2 on mainnet, starting with a TVL of $1 million and reaching $2 million in the first month. Within the first six months, we look to scale to a TVL of $10 million, demonstrating the strong demand for our platform and the value it provides to users.

Currently, we are in talks with over 30 market makers who are eager to participate in the on-chain options market and take advantage of the new opportunities our platform offers. Our mainnet launch is expected to bring even more growth, as we anticipate increased control over pricing and key risk parameters by market makers (which was previously possible only through an orderbook model), further strengthening our position in the DeFi space.

# Core team & technical experience:

The DeFi Options core team consists of three members:

Cinque is our community contributing lead developer with 11 years of experience in software development, including 3 years in the fintech and proprietary trading firms.

King Kunta is our community contributing business development lead with extensive experience in financial services and a passion for fostering growth and innovation in the industry.

0xRock is our community contributing business development professional with a proven track record in start-up environments and experience in raising funds from venture capital firms. He has a passion for driving success through strategic partnerships and collaborations.

# Key resources

Docs: https://docs.defioptions.org/

Contracts: https://github.com/cinquemb/DeFiOptions-core/tree/canto

Frontend: https://github.com/cinquemb/DeFiOptions-frontend

Deployed frontend (on testnet): https://cinquemb.github.io/DeFiOptions-frontend/

LP management docs: https://docs.google.com/document/d/1e7aaDGH-r8EUbVyuqUnxiS_xFOR46ROMyP_GTgpUVas/edit#


# Additional resources

V1 audit results: https://github.com/DeFiOptions/DeFiOptions-core/blob/master/audits/PeckShield-Audit-Report-DeFiOptions-v1.0.pdf

Linear interpolation for LP-defined pricing surfaces: https://thomasvilhena.com/2021/03/a-linear-interpolation-based-liquidity-pool
