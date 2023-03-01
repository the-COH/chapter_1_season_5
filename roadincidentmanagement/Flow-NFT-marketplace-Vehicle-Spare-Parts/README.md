# NFT Marketplace for NFC tags of Spare Parts using Flow

We are using FlowNS and Flow eco-system tools to develop an NFT storefront and marketplace for NFTs representing NFC tags of vehicle spare parts provided by government agencies (example GeM portal). This enables on-demand availability of spare parts and prevents counterfieting of expensive, repairable spare parts at functional locations. Further, it enables optimaly inventory management and allocation at all repair sites.

The NFT marketplace is a general-purpose Cadence contract for trading NFTs on Flow.

`NFT Marketplace` uses modern Cadence [run-time type](https://docs.onflow.org/cadence/language/run-time-types/)
facilities to implement a marketplace that can take any currency in order to vend any token in a safe and secure way. 
This means that only one instance of the contract is needed (see below for its address on Testnet and Mainnet), 
and its resources, transactions, and scripts can be used by any account to create any marketplace.


## Usage

Each account that wants to offer NFTs for sale installs a `Storefront`,
and then lists individual sales within that `Storefront` as `Listing` resources.

There is one `Storefront` per account that handles sales of all NFT types
for that account.

Each `Listing` can list one or more cut percentages.
Each cut is delivered to a predefined address. 
Cuts can be used to pay listing fees or other considerations.

Each NFT may be listed in one or more `Listing` resources.
The validity of each `Listing` can easily be checked.

Purchasers can watch for `Listing` events and check the NFT type and
ID to see if they wish to buy the offered item.

Marketplaces and other aggregators can watch for `Listing` events
and list items of interest.
