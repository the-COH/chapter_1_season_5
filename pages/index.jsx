import Link from 'next/link';
import styles from '../components/layout.module.scss';
import Layout from '../components/layout';
import Image from 'next/image';
import { useEffect, useState } from 'react';

function HomePage() {

    const merch = [
        {
            image: "CantoLogoHoodie50.png",
            name: "Canto Logo Hoodie",
            price: 50,
            sku: "MN10000005"
        },
        {
            image: "AltoBackpack50.png",
            name: "Alto Backpack",
            price: 25,
            sku: "MN10000050"
        },
        {
            image: "AltoPartyShirt.jpg",
            name: "Alto Party Shirt",
            price: 25,
            sku: "CARTO10000003"
        },
        {
            image: "CantoLogoMonogramSocks20.png",
            name: "Canto Monogram Socks",
            price: 20,
            sku: "MN10000049"
        }
    ];
    const [merchandise, setMerchandise] = useState(merch);

    const search = () => {
        alert('searching');
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
                    </ul>
                </nav>
            </header>
            <div className={styles.index}>
                <div className={styles.firstRow}>
                    <div className={styles.text}>
                        <h1>The home of Canto NFT merch</h1>
                        <h3>Buy, sell and create merch, fully on-chain featuring Canto NFTs with all royalties going to IP owners.</h3>
                    </div>
                    <div>
                        <Link href={`/products/MN10000042`}>
                            <Image src={`/images/products/CantoWaifusWomensLogoTee25.png`} height={360} width={360} alt="Merch" />
                        </Link>
                    </div>
                </div>
                <div className={styles.secondRow}>
                    {merchandise.map((item, index) => (
                        <div className={styles.card} key={index}>
                            <Link href={`/products/${encodeURIComponent(item.sku)}`}>
                                <Image src={`/images/products/${item.image}`} height={200} width={200} alt={item.name} />
                                <div className={styles.text}>
                                    <span>{item.name}</span>
                                    <span>{item.price} NOTE</span>
                                </div>
                            </Link>
                        </div>
                    ))}
                </div>
            </div>
        </Layout>
    );
}

export default HomePage;