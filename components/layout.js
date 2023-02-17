import Head from 'next/head'

export default function Layout({ children }) {
    return (
        <>
            <Head>
                <title>Carto - The home of Canto NFT merch</title>
                <link rel="shortcut icon" href="/images/favicon.png" />
                <link href="/styles/fontawesome/css/fontawesome.css" rel="stylesheet" />
                <link href="/styles/fontawesome/css/solid.css" rel="stylesheet" />
            </Head>
            {children}
        </>
    );
}