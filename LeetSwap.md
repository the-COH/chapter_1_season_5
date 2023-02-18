# LeetSwap
## V2 DEX, Reward System, Liquidity Manageable protocol, and LEET token

- Contracts repo: https://github.com/LeetSwap/leetswap-contracts  
- Webapp repo (v2 branch): https://github.com/LeetSwap/leetswap-interface/tree/v2
- Live demo webapp: https://v2.leetswap.finance

Up until now LeetSwap was using CantoDEX contracts under the hood. For this month's hackathon, we've been building a custom new DEX that routes through our upcoming v2 pairs, but also uses the free liquidity from CantoDEX FPI.

The LeetSwap v2 DEX contracts (Router, Factory, Pair, $LEET token) will also use CSR, whose revenue will be used to fuel a new paradigm to test the sustainability of liquidity mining (farms) to prevent (or offset) the highly-inflationary nature of the reward token.

LeetSwap contracts are forked from Solidly, and improve the DEX in many areas but most importantly we "fixed" what in our opinion has prevented its widespread adoption until now, namely lack of full compatibility with Uniswap's interface (and thus Ethereum/BSC tokens or protocols built on top of it).

Here are some other features introduced in the new LeetSwap Core DEX contracts:
- burnable fees (can be set on a per-token basis)
- dynamic trading fees (can be controlled by an on-chain trading fee oracle contract for e.g. "hold X amounts of this token to get a Y% discount on trading fees")
- optional protocol fee (like Uniswap) to additionally fuel the rewards system

Lastly, the latest addition is our brand-new and fully-optional protocol standard that tax tokens can adopt to avoid taxes on liquidity management. Because from a token contract POV there's no way to distinguish between buys/sells and removing/adding liquidity, these tokens end up taxing both scenarios.

Taxing your liquidity providers is the last thing you want, especially if you want to use services like our new CSR-enabled farms! Thus, the liquidity management token standard was created, which only requires the token to set up a before-transfer hook that can will be called by our router when managing liquidity, and letting the token know not to tax the current transfer.
