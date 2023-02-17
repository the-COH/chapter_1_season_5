import {
  Address,
  BigInt,
} from "@graphprotocol/graph-ts"

// Initialize a Token Definition with the attributes
export class TokenDefinition {
  address : Address
  symbol: string
  name: string
  decimals: BigInt

  // Initialize a Token Definition with its attributes
  constructor(address: Address, symbol: string, name: string, decimals: BigInt) {
    this.address = address
    this.symbol = symbol
    this.name = name
    this.decimals = decimals
  }

  // todo: update token definitions
  // Get all tokens with a static defintion
  static getStaticDefinitions(): Array<TokenDefinition> {
    let staticDefinitions = new Array<TokenDefinition>(6)

    // Add NOTE
    let tokenNOTE = new TokenDefinition(
      Address.fromString('0x5D91eFb1385896d73CA32DC013A3b2616C824acB'),
      'NOTE',
      'Note Token',
      BigInt.fromI32(9)
    )
    staticDefinitions.push(tokenNOTE)

    // Add USDC
    let tokenUSDC = new TokenDefinition(
      Address.fromString('0xDFB00E0AAaA9613bC6C12200AbA4a5A83923E6f8'),
      'USDC',
      'USDC Token',
      BigInt.fromI32(18)
    )
    staticDefinitions.push(tokenUSDC)

    // Add USDT
    let tokenUSDT = new TokenDefinition(
      Address.fromString('0x35e917c952dc2dB9b83B5E33217C7B8A6317dB76'),
      'USDT',
      'USDT Token',
      BigInt.fromI32(18)
    )
    staticDefinitions.push(tokenUSDT)

    // Add ATOM
    let tokenATOM = new TokenDefinition(
      Address.fromString('0x637Ec11725AB2f759e120c829F0Ff49837a6257a'),
      'ATOM',
      'ATOM Token',
      BigInt.fromI32(18)
    )
    staticDefinitions.push(tokenATOM)

    // Add ETH
    let tokenETH = new TokenDefinition(
      Address.fromString('0x81140F55DC0aA3c6c620a860Dc11bD54955e386f'),
      'ETH',
      'ETH Token',
      BigInt.fromI32(16)
    )
    staticDefinitions.push(tokenETH)

    // Add WETH
    let tokenWETH = new TokenDefinition(
      Address.fromString('0xdB11bD00ca99067A4FC78d652CC56138ff4041D1'),
      'WETH',
      'WETH Token',
      BigInt.fromI32(18)
    )
    staticDefinitions.push(tokenWETH)

    return staticDefinitions
  }

  // Helper for hardcoded tokens
  static fromAddress(tokenAddress: Address) : TokenDefinition | null {
    let staticDefinitions = this.getStaticDefinitions()
    let tokenAddressHex = tokenAddress.toHexString()

    // Search the definition using the address
    for (let i = 0; i < staticDefinitions.length; i++) {
      let staticDefinition = staticDefinitions[i]
      if(staticDefinition.address.toHexString() == tokenAddressHex) {
        return staticDefinition
      }
    }

    // If not found, return null
    return null
  }

}
