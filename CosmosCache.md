# Introduction

Cosmos Cache is the scaling solution to take Cosmos infrastructure to the next level. It allows programmers to use endpoints without rate limits while also lowering costs for node operators. It supports RPC and REST natively, including for both transactions and ABCI queries.
It further adds useful additions such as Coingecko prices to enhance its usefulness

---

## Project Highlights

- Stress tested on 150 million Main-net requests (52 million in 3 hours at peak with <300ms response time)
- RPC (single or batched), REST, and WebSocket
- SwaggerUI + OpenAPI
- ABCI Queries
- Transactions (with correct response codes from ABCI in order)
- Coingecko prices
- Cosmos native and Ethermint-based chains
- Use your same NGINX config
- Backup RPC support is natively built in, even if your node goes down
- Custom HTML in the RPC header

## Difficulties

The cache solution requires a thorough consideration of edge cases, particularly in the case of RPC. The request data may consist of standard JSON for a single JSON-RPC message, or a list of JSON objects for a batch RPC request. Additionally, each method has its specific cache times, and some methods require hash sets to improve performance, such as archive blocks, transactions, and hash lookups. Another challenge is to ensure that each ABCI query uses its unique int64 id. To address this, I had to spoof ABCI requests on behalf of the user, which allows it to cache the queries and still deliver the expected id in the response to the user, even through the cache.

## Future Plans

- Add Tendermint RPC WebSocket pass-through support (If 500 WebSocket requests are made to a middleware server, only a fraction of connections are made to the node itself)
- Index blocks & Transactions option (save to remote databases like MongoDB or Postgres to allow for heavy pruning)
- Add a bypass cache system for paying clients with a UUID & password system, and log the number of requests made

---

## Source Code

<https://github.com/Reecepbcups/cosmos-endpoint-cache>

## Current Endpoints

These are on a cheap 4-core VPS from Hetzner (Finland) and are not intended for production use yet. They are only for testing and development. I will upgrade to a bare metal machine shortly and add it to the Cosmos directory.

<https://canto-rpc.reece.sh/>

<https://canto-api.reece.sh/>
