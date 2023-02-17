import Cors from 'cors';
import axios from 'axios';

// Initializing the cors middleware
const cors = Cors({
	methods: ['POST', 'GET', 'HEAD'],
});

// Helper method to wait for a middleware to execute before continuing
// And to throw an error when an error happens in a middleware
function runMiddleware(req, res, fn) {
	return new Promise((resolve, reject) => {
		fn(req, res, (result) => {
			if (result instanceof Error) {
				return reject(result);
			}
			return resolve(result);
		});
	})
}

export default async function shopify(req, res) {
	await runMiddleware(req, res, cors)

	const token = process.env.NEXT_PUBLIC_SHOPIFY_ACCESS_TOKEN;
	const shopName = process.env.NEXT_PUBLIC_SHOPIFY_SHOPNAME;
	const endpoint = `https://${shopName}.myshopify.com/admin/api/2023-01/products.json`;

	const instance = axios.create({
		headers: {
			'Content-Type': 'application/json',
			'X-Shopify-Access-Token': token
		}
	});
	let products = await instance.get(endpoint);
	res.status(200).json(products.data);
}