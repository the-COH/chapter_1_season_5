const ethers = require('ethers');

const metamask = {

    refresh: () => {
        sessionStorage.clear('user');
        window.location.reload();
    },

    createEventHandlers: () => {
        window.ethereum.on("accountsChanged", async _ => {
            metamask.refresh();
        });
    },

    createChainChangedEventHandler: () => {
        window.ethereum.on("chainChanged", async _ => {
            metamask.refresh();
        });
    },

    connect: async (accountChangedHandler, setNoMetamask, setIsConnected, setIsRightBlockchain) => {
        if (window.ethereum) {
            let provider = new ethers.providers.Web3Provider(window.ethereum);

            await provider.send("eth_requestAccounts", []);
            const signer = await metamask.parseSigner(provider.getSigner());
            await accountChangedHandler(signer, setIsConnected, setIsRightBlockchain);

            metamask.createEventHandlers();
        } else {
            setNoMetamask(true);
        }
    },

    switch: async () => {
        // first of all, disable the chainChanged event handler
        window.ethereum.removeListener('chainChanged', metamask.refresh);

        console.log(`4. Changing to CANTO...`);
        let result = {
            success: false
        };
        if (window.ethereum) {
            try {
                await window.ethereum.request({
                    method: 'wallet_switchEthereumChain',
                    params: [{ chainId: `0x${Number(process.env.NEXT_PUBLIC_CHAIN_ID).toString(16)}` }]
                });
                result.success = true;
            } catch (switchError) {
                // This error code indicates that the chain has not been added to MetaMask.
                if (switchError.code === 4902) {
                    result.message = "CANTO is not available in your metamask; please add it.";
                } else {
                    result.message = "Unknown error: couldn't switch to CANTO";
                }
            }
        } else {
            result.message = "No etherum provider found";
        }
        return result;
    },

    handler: async (signer, setIsConnected, setIsRightBlockchain) => {
        console.log(`2. Metamask event handler...`);
        setIsConnected(true);

        // right network?
        if (window.ethereum.networkVersion !== process.env.NEXT_PUBLIC_CHAIN_ID) {
            setIsRightBlockchain(false);
            sessionStorage.clear('user');
        } else {
            setIsRightBlockchain(true);
            const abbrAddress = metamask.abbreviateAddress(signer.address);
            sessionStorage.setItem('user', JSON.stringify({
                address: signer.address,
                abbrAddress,
                cart: []
            }));
        }
        return true;
    },

    abbreviateAddress: address => {
        return address.substring(0, 4) + "..." + address.substring(address.length - 4, address.length);
    },

    parseSigner: async signer => {
        const address = await signer.getAddress();
        const balance = await signer.getBalance();
        return { address, balance };
    }
};
export default metamask;