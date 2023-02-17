export async function storefront(query, variables = {}) {
	const response = await fetch(process.env.NEXT_PUBLIC_SHOPIFY_API_URL, {
		method: 'POST',
		headers: {
			'Content-Type': 'application/json',
			'X-Shopify-Storefront-Access-Token': process.env.NEXT_PUBLIC_SHOPIFY_ACCESS_TOKEN
		},
		body: JSON.stringify({query, variables})
	});
	return {
		status: response.status,
		body: await response.json()
	};
};