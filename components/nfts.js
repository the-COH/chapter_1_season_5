import collections from '../collections';
const ethers = require("ethers");

const nfts = {
	getTokens: async address => {
		let tokenIds;
		const provider = new ethers.providers.JsonRpcProvider(
			process.env.NEXT_PUBLIC_CHAIN_URL
		);
		const activeCollection = collections.find(wl => !!wl.active);
		try {
			const contract = new ethers.Contract(
				activeCollection.address,
				activeCollection.abi,
				provider
			);
			const tokenIdsHeld = activeCollection.fns.find(fn => fn.name === "tokenIdsHeld").fn;
			tokenIds = await tokenIdsHeld(contract, address);
			if(tokenIds.length === 0) tokenIds = null;
			return {
				tokenIds: [1001], // tokenIds,
				collection: activeCollection
			}
		} catch (e) {
			return null;
		}
	},

	getMetadata: async (tokenId, collection) => {
		const provider = new ethers.providers.JsonRpcProvider(
			process.env.NEXT_PUBLIC_CHAIN_URL
		);
		try {
			const contract = new ethers.Contract(
				collection.address,
				collection.abi,
				provider
			);
			const getTokenURI = collection.fns.find(fn => fn.name === "tokenURI").fn;
			const tokenURI = await getTokenURI(contract, tokenId);
			return tokenURI;
		} catch (e) {
			return null;
		}
	}
};
export default nfts;