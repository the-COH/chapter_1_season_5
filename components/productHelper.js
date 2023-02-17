const products = {
	addToOrRemoveFromCart: (user, product, prods) => {

		// update the user's shopping cart
		let existingCart = user.cart;
		let updatedCart;
		const isAlreadyInCart = existingCart.find(p => {
			return p.id == product.id;
		});
		if (isAlreadyInCart) {
			updatedCart = existingCart.filter(p => {
				return p.id !== product.id;
			});
		} else {
			updatedCart = existingCart;
			updatedCart.push(product);
		}

		// update the products
		const updatedProducts = prods.map(p => {
			if (p.id === product.id) {
				p.isInCart = !isAlreadyInCart;
			}
			return p;
		});

		let updatedUser = {
			...user,
			cart: updatedCart
		};
		return { updatedUser, updatedProducts };
	},

	setCartStatus: (products, cart) => {
		return products.map(p => {
			const isInCart = cart.find(c => {
				return c.id === p.id;
			});
			p.isInCart = isInCart ? true : false;
			return p;
		});
	},

	getCartTotal: cart => {
		return cart.reduce((acc, curr) => acc + +curr.price.amount, 0);
	},

	map: node => {
		return {
			id: node.id,
			description: node.descriptionHtml,
			image: {
				src: node.images.edges[0].node.transformedSrc,
            	alt: node.images.edges[0].node.altText,
            	width: node.images.edges[0].node.width,
            	height: node.images.edges[0].node.height
			},
			options: node.options,
			price: {
				amount: node.priceRange.minVariantPrice.amount,
				currencyCode: "NOTE" // node.priceRange.minVariantPrice.currencyCode
			},
			sku: node.variants.edges[0].node.sku,
			tags: node.tags,
			title: node.title
		};
	}
};
export default products;