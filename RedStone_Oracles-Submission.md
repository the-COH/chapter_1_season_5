# Problem

Canto builders have been restricted by the lack of Oracles & diversified data feeds for months.
But now RedStone comes with a unique value proposition:

⚒️ Over 1100 data feeds, updated each 10 sec by a robust Oracle ⚒️

Explore long-tail, LP, staked, canto-native tokens; indexes; commodities; Forex; custom data feeds, i.e. NFT related.
All of them pulled from 50+ sources, browse them yourself: <https://app.redstone.finance/>
Best example? We integrated Canto token too! <https://app.redstone.finance/#/app/token/CANTO>

---

## How does it work?

We utilise signature verification & call-data costs efficiency 👌
1. In RedStone flow, Data Providers push signed data packages (with timestamps) to a proprietary Data Delivery Network (DDN).
DDN is built with Arweave, Streamr Network, RedStone nodes and other reliability services.
2. dApp on Canto integrates RedStone and fetches data off-chain only when it's needed. 
3. For example, Mr Anon wants to take a loan from Canto Lending. 
Mr Anon sends transaction, Canto Lending fetches the signed package off-chain from DDN, attaches it to Anon's transaction call-data.
Smart Contract receives transaction, extracts data from call-data, verifies signatures and executes the order.
Simple visualisation scheme for Arbitrum & GMX: <https://docs.google.com/presentation/d/1HLxpLI4wWB-jrH65_IBG9_17P4NGWkkjjdgpNU9lvNg/edit?usp=sharing>

Demo of fetching sample prices on Canto: <https://canto-showroom.redstone.finance/>
Demo contract from above: <https://evm.explorer.canto.io/address/0xf16dA7ABcac966B3ba9c1DFa17D8A9626237bcf8>

---

## What if I prefer traditional Oracle model?

RedStone offer Canto builders three models:
- Costs optimised RedStone model: described above
- RedStone Oracle legacy model: we push data on Canto chain with a heartbeat and diviation update.
Traditional approach, the more frequent data updates & the more data feeds, the more expensive it gets.
- RedStoneX model: Tailor made model for each user, most expensive but most secure. 
a) User sends trasaction on Canto via a dApp in block N, i.e. short position creation.
b) Resolver (anyone running a script) connects price from DDN to transaction call-data.
c) dApp places & executes transaction in block N+1 with the price feed attached.

---

## The Team

- Jakub Wojciechowski (Founder): ex-Open Zeppelin SC auditor; winner of ETHNYC, ETHLondon; Engineer with 12 y. of experience
- Lukasz Kalbarczyk (Engineer): over 20 y. of developer experience, integrations & code expert, Canto showroom creator
- Marcin Kazmierczak (COO): ex-Google Could PM, in blockchain space since 2017, ETHWarsaw co-founder, winner of ETHBogota

The whole RedStone team consists of developers in 80% and is dedicated to work shouldr to shoulder with Canto projects.

---

## What next?

We plan to work hands-on with projects building on Canto and integrate data feeds that they need and want to use. 
Tight cooperation with the ecosystem builders is crucial for us 🤝

---

## Links

A. Available data feeds: <https://app.redstone.finance/>
B. RedStone Docs: <https://docs.redstone.finance/>
C. Demo integration on Canto: <https://canto-showroom.redstone.finance/>
D. Website: <https://redstone.finance/>
E. Twitter: <https://twitter.com/redstone_defi/>
F. Discord: <https://discord.com/invite/PVxBZKFr46>
