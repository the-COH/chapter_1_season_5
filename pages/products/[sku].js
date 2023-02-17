import Link from 'next/link';
import styles from '../../components/layout.module.scss';
import Layout from '../../components/layout';
import { useEffect, useState } from 'react';
import metamask from '../../components/metamask';
import Image from 'next/image';
import nfts from '../../components/nfts';
import productHelper from '../../components/productHelper';
import { storefront } from '../../components/storefront';

function Products({ products }) {
    const [noMetamask, setNoMetamask] = useState(false);
    const [isConnected, setIsConnected] = useState(false);
    const [isRightBlockchain, setIsRightBlockchain] = useState(false);
    const [message, setMessage] = useState(null);
    const [authMessage, setAuthMessage] = useState(null);
    const [prods, setProds] = useState([]);
    const [selectedProduct, setSelectedProduct] = useState(null);
    const [abbrAddress, setAbbrAddress] = useState(null);
    const [showCart, setShowCart] = useState(false);
    const [cartProducts, setCartProducts] = useState([]);
    const [cartTotal, setCartTotal] = useState(0);

    useEffect(() => {
        metamask.createEventHandlers();
        checkAuth();
    }, [])

    const accountChangedHandler = async signer => await metamask.handler(signer, setIsConnected, setIsRightBlockchain);

    const connect = async () => {
        console.log(`1. Connecting...`);
        await metamask.connect(accountChangedHandler, setNoMetamask, setIsConnected, setIsRightBlockchain);
        if (noMetamask) {
            setMessage("<p>Please Install Metamask!</p>");
        }
        if (!isRightBlockchain) {
            setMessage(`<p>Please switch to the ${process.env.NEXT_PUBLIC_CHAIN_NAME} network</p>`);
        }
        checkAuth();
    };

    const checkAuth = async () => {
        console.log(`3. Checking auth...`);
        let user = getUser();
        if (user) {
            console.log(`3a. User found in sessionStorage...`);
            setIsConnected(true);
            setAbbrAddress(user.abbrAddress);
            setIsRightBlockchain(true);
            setMessage("<p>Checking tokens...</p>");
            const { tokenIds, collection } = await nfts.getTokens(user.address);
            if (!tokenIds) {
                setAuthMessage(`<p>No dice! You don't seem to have any NFTs from the ${collection.name} collection :(</p><p>Head to the <a href="https://alto.build"> Alto Marketplace</a> to buy yourself a Waifu NFT.</p>`);
                setMessage(null);
                setProds(null);
            } else {
                setAuthMessage(`<p>Congratulations! You own the following Alto-listed NFTs - ${tokenIds} - from the ${collection.name} collection: start shopping for products!</p>`);
                setTimeout(() => {
                    setAuthMessage(null);
                }, 5000);

                // const tokenURI = await nfts.getMetadata(tokenIds[0].toNumber(), collection);
                const tokenURI = await nfts.getMetadata(tokenIds[0], collection);
                //console.log(`tokenURI: ${tokenURI}`);

                try {
                    setMessage("<p>Getting Shopify products...</p>");
                    if (products) {
                        let cart = [];
                        let user = sessionStorage.getItem("user");
                        if (user) {
                            user = JSON.parse(user);
                            cart = user.cart;
                        }
                        products = productHelper.setCartStatus(products, cart);
                        setProds(products);
                        setMessage(null);
                    } else {
                        setMessage(`<p>No activeProducts</p>`);
                    }
                } catch (e) {
                    setMessage(`<p>Error getting products: ${e}</p>`);
                }

                // finally, set the chain changed handler again
                metamask.createChainChangedEventHandler();
            }
        } else {
            console.log(`3b. NO user found in sessionStorage...`);
            setProds(null);
            setMessage(`Please connect your wallet.`);
        }
    }

    const changeToCanto = async () => {
        const switchResult = await metamask.switch();
        if (!switchResult.success) {
            setMessage(switchResult.message);
        } else {
            console.log(`3. Successfully changed to CANTO.`);
            connect();
        }
    }

    const getUser = () => {
        let savedUser = sessionStorage.getItem("user");
        if (savedUser) {
            return JSON.parse(savedUser);
        } else {
            return null;
        }
    }

    const display = p => {
        setSelectedProduct(p);
    }

    const unsetSelectedProduct = () => {
        setSelectedProduct(null);
    }

    const getCart = () => {
        if (showCart) setShowCart(false);
        else {
            setShowCart(true);
            let user = sessionStorage.getItem("user");
            if (user) {
                user = JSON.parse(user);
                const cart = user.cart;
                setCartProducts(cart);
                setCartTotal(productHelper.getCartTotal(cart));
            }
        }
    }

    const search = () => {
        alert('searching');
    }

    const addToOrRemoveFromCart = p => {
        let user = getUser();
        const { updatedUser, updatedProducts } = productHelper.addToOrRemoveFromCart(user, p, prods);
        sessionStorage.setItem("user", JSON.stringify(updatedUser));
        setCartProducts(updatedUser.cart);
        setProds(updatedProducts);
        setCartTotal(productHelper.getCartTotal(updatedUser.cart));
        return false;
    }

    return (
        <Layout>
            <header className={styles.header}>
                <nav>
                    <ul>
                        <li className={styles.logoCell}>
                            <Link href={{ pathname: "/" }}>
                                <Image
                                    src="/images/logo.png"
                                    height={32}
                                    width={32}
                                    alt="Carto"
                                />
                                <h1>CARTO</h1>
                            </Link>
                        </li>
                        <li>
                            <form>
                                <i className="fa-solid fa-magnifying-glass"></i>
                                <input type="text" placeholder="Search NFT Projects or Products" onChange={search}></input>
                            </form>
                        </li>
                        <li><Link href={{ pathname: "/products/hoodies" }}>Hoodies</Link></li>
                        <li><Link href={{ pathname: "/products/tees" }}>Tees</Link></li>
                        <li><Link href={{ pathname: "/products/hats" }}>Hats</Link></li>
                        <li><Link href={{ pathname: "/products/sweats" }}>Sweats</Link></li>
                        <li><Link className={styles.create} href={{ pathname: "/products/create" }}>Create</Link></li>
                        <li><i className="fa-solid fa-user"></i></li>
                        <li>
                            <button className={isRightBlockchain ? styles.success : styles.error} onClick={connect}><i className="fa-solid fa-wallet"></i></button>
                        </li>
                        <li>
                            <button onClick={getCart}><i className="fa-solid fa-cart-shopping"></i></button>
                        </li>
                    </ul>
                </nav>
            </header>
            <div className={styles.buy}>
                {!showCart ?
                    <div className={styles.products}>
                        <div className={styles.content}>
                            {message ? <p dangerouslySetInnerHTML={{ __html: message }}></p> : null}
                            {authMessage ? <p dangerouslySetInnerHTML={{ __html: authMessage }}></p> : null}
                            {!isConnected ? <button onClick={connect}>Connect</button> : null}
                            {isConnected && !isRightBlockchain ? <button onClick={changeToCanto}>Change to the CANTO network</button> : null}
                        </div>
                    </div> : null}
                {!showCart ?
                    <>
                        {!selectedProduct && prods ? <h2>Featured products</h2> : null}
                        <div className={styles.productList}>
                            {selectedProduct ?
                                <div className={styles.selectedProduct}>
                                    <div className={styles.image}>
                                        <Image
                                            src={selectedProduct.image.src}
                                            alt={selectedProduct.title}
                                            width={selectedProduct.image.width / 2}
                                            height={selectedProduct.image.height / 2}
                                        />
                                        <button className={styles.success} onClick={unsetSelectedProduct}>Back</button>
                                    </div>
                                    <div className={styles.details}>
                                        <h3>{selectedProduct.title}</h3>
                                        <div className={styles.price}>
                                            {selectedProduct.price.amount} {selectedProduct.price.currencyCode}
                                        </div>
                                        <div className={styles.options}>
                                            {selectedProduct.options.map(o => {
                                                return <div key={o.name}>
                                                    <span>{o.name}: </span>
                                                    {o.values.map(v => {
                                                        return <button key={v}>{v}</button>
                                                    })}
                                                </div>
                                            })}
                                        </div>
                                        <button className={!selectedProduct.isInCart ? styles.success : styles.error} onClick={() => addToOrRemoveFromCart(selectedProduct)}>
                                            {!selectedProduct.isInCart ? "ADD TO CART" : "REMOVE FROM CART"}
                                        </button>
                                        <h3>Description</h3>
                                        <div dangerouslySetInnerHTML={{ __html: selectedProduct.description }}></div>
                                    </div>
                                </div>
                                : null}
                            {!selectedProduct && prods && prods.map(p => {
                                return <div className={styles.product} key={p.id}>
                                    <Image onClick={() => display(p)}
                                        className={styles.image}
                                        src={p.image.src}
                                        height={p.image.height / 4}
                                        width={p.image.width / 4}
                                        alt={p.title}
                                    />
                                    <div className={styles.details} key={p.id}>
                                        <h3>{p.title}</h3>
                                        <div className={styles.price}>
                                            {p.price.amount} {p.price.currencyCode}
                                        </div>
                                    </div></div>
                            })}
                        </div></> : null}
                {showCart ?
                    <div className={styles.cart}>
                        <div className={styles.header}>
                            <h2>Shopping cart</h2>
                            <button className={styles.secondary} onClick={() => { setShowCart(false) }}>X</button>
                        </div>
                        <div className={styles.cartProducts}>
                            {cartProducts.map(cp => {
                                return <div className={styles.cartProduct} key={cp.id}>
                                    <h3>{cp.title}</h3>
                                    <div class={styles.totalAndRemove}>
                                        <span>{cp.price.amount} {cp.price.currencyCode}</span>
                                        <button onClick={() => addToOrRemoveFromCart(cp)}>🗑</button>
                                    </div>
                                </div>
                            })}
                        </div>
                        <div className={styles.total}>
                            Total
                            <div class={styles.totalAndRemove}>
                                <span>{cartTotal} NOTE</span>
                            </div>
                        </div>
                        <div className={styles.lastRow}>
                            {cartProducts.length === 0 ? <p>Your cart is empty</p> : <button onClick={() => alert('Coming soon')}>Checkout</button>}
                        </div>
                    </div> : null
                }
            </div>
        </Layout>
    );
}

export const getStaticPaths = async () => {
    return {
        paths: [], //indicates that no page needs be created at build time
        fallback: 'blocking' //indicates the type of fallback
    }
}

export async function getStaticProps(context) {
    const gql = String.raw;
    const { sku } = context.params;
    let query = "first:10";
    if (sku) {
        query = `${query}, query:"sku:${sku}"`;
    }
    console.log(`query: ${query}`);
    const productsQuery = gql`
        query Products {
            products(${query}) {
                edges {
                    node {
                        id
                        descriptionHtml
                        images(first: 1) {
                            edges {
                                node {
                                    transformedSrc
                                    altText,
                                    width,
                                    height
                                }
                            }
                        }
                        options {
                            id
                            name
                            values
                        }
                        priceRange {
                            minVariantPrice {
                                amount
                                currencyCode
                            }
                        }
                        variants(first: 10) {
                            edges {
                                node {
                                    id
                                    sku
                                    title
                                }
                            }
                        }
                        tags
                        title
                    }
                }
            }
        }
    `;
    console.log(`productsQuery: ${productsQuery}`);
    const { status, body } = await storefront(productsQuery);
    // console.log(`body: ${JSON.stringify(body)}`);

    const mappedProducts = body.data.products.edges.map(p => {
        return productHelper.map(p.node);
    });
    return {
        props: {
            products: mappedProducts
        }
    };
}

export default Products;