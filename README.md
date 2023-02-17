ArtLink token-gating app
========================

## Run app
> npm run dev

## Deploy app
The app is hosted on Vercel and is rebuilt and redeployed in the normal CI manner on pushing to the _master_ branch.
Manage it on [Vercel.com](https://vercel.com/artlink-canto-store/alto-token-gated-store).
<br/><br/>

# Blockchain
## Collections whitelist
A database of collections is at _'/collections.js'_. Only one collection should be marked as active, and this is the one the app concerns itself with.

## Environment variables
You can change the chains in the .env file by setting the three variables. By default, it will be set to CANTO:

```
NEXT_PUBLIC_CHAIN_ID=7700
NEXT_PUBLIC_CHAIN_NAME=CANTO
NEXT_PUBLIC_CHAIN_URL=https://canto.slingshot.finance
```

Here is how to set the app to Polygon:

```
NEXT_PUBLIC_CHAIN_ID=137
NEXT_PUBLIC_CHAIN_NAME=POLYGON
NEXT_PUBLIC_CHAIN_URL=https://polygon-rpc.com/
```

## User session
When the user connects their wallet, a sessionStorage value is created:
```
user: {
	address: 0x1234...,
	cart: []
}
```  
On adding an item to their cart, the product's id is added to the cart array. Likewise, the user can remove that item from their cart.
<br/><br/>

# Shopify integration
## API
The app uses the [**Storefront API**](https://shopify.dev/api/storefront). Note that we are not using Hydrogen to consume the API, but rather simple RESTful calls, as shown in this video: [Building a Headless Ecommerce Store with Tailwind CSS, Shopify, and Next.js](https://www.youtube.com/watch?v=xNMYz74zNHM).

## Icon library
Uses [Font Awesome](https://fontawesome.com/)