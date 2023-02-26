# Problem

Canto builders have been restricted by the lack of Oracles & diversified data feeds for months.
But now RedStone comes with a unique value proposition:

⚒️ Over 1100 data feeds, updated each 10 sec by a robust Oracle ⚒️

Explore long-tail, LP, staked, canto-native tokens; indexes; commodities; Forex; custom data feeds, i.e. NFT related.
All of them pulled from 50+ sources, browse them yourself: <https://app.redstone.finance/>
Best example? We integrated Canto token too! <https://app.redstone.finance/#/app/token/CANTO>

---

## How does it work?

We utilise call-data costs efficiency & on-chain signature verification 👌
1. In RedStone flow, Data Providers push signed data packages (with timestamps) to the Data Delivery Network (DDN).
DDN is built with Streamr Network, Arweave, RedStone nodes and other reliability services.
2. dApp on Canto integrates RedStone and fetches data off-chain only when it's needed. 
3. Let's look on an example. Mr Anon wants to take a loan from Canto Lending. 
Mr Anon sends transaction, Canto Lending fetches the signed package off-chain from DDN, attaches it to Anon's transaction call-data.
Smart Contract on Canto receives transaction, extracts data from call-data, verifies signatures and executes the order.

Demo of fetching sample prices on Canto: <https://canto-showroom.redstone.finance/>
Demo contract from above: <https://evm.explorer.canto.io/address/0xf16dA7ABcac966B3ba9c1DFa17D8A9626237bcf8>

---

## What if I prefer traditional Oracle model?

RedStone offer Canto builders three models:
- RedStone Core model: described above, cost-efficient
- RedStone Classic Oracle model: we push data on Canto chain with a heartbeat as classic Oracles do.
Traditional approach, the more frequent data updates & the more data feeds, the more expensive it gets.
- RedStone X model: Tailor made for each user, most expensive but most performant. 
a) User sends trasaction on Canto via a dApp in block N, i.e. short position creation.
b) Resolver (anyone running a script) connects price from DDN to transaction call-data.
c) dApp places & executes transaction in block N+1 with the price feed attached.
Simple visualisation scheme for Arbitrum & GMX: <https://docs.google.com/presentation/d/1HLxpLI4wWB-jrH65_IBG9_17P4NGWkkjjdgpNU9lvNg/edit?usp=sharing>

---

## The Team

- Jakub Wojciechowski (Founder): ex-Open Zeppelin SC auditor; winner of ETHNYC, ETHLondon; Engineer with 12 y. of experience
- Lukasz Kalbarczyk (Engineer): over 20 y. of developer experience, integrations & code expert, Canto showroom creator
- Marcin Kazmierczak (COO): ex-Google Could PM, in blockchain space since 2017, ETHWarsaw co-founder, winner of ETHBogota

The whole RedStone team consists of developers in 80% and is dedicated to work shouldr to shoulder with Canto projects.

---

## What next?

We plan to work hands-on with projects building on Canto and integrate data feeds that they need and want to use.
We plan on adding more data sources for Canto token & build DeFi ecosystem, especially perps, options, derivatives, etc.
Tight cooperation with the ecosystem builders is crucial for us 🤝

---

## Links

A. Available data feeds: <https://app.redstone.finance/>
B. RedStone Docs: <https://docs.redstone.finance/>
C. Demo integration on Canto: <https://canto-showroom.redstone.finance/>
D. Website: <https://redstone.finance/>
E. Twitter: <https://twitter.com/redstone_defi/>
F. Discord: <https://discord.com/invite/PVxBZKFr46>
