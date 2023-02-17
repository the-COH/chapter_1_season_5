<script  lang="ts">
    import { onMount } from 'svelte';
    import { browser } from '$app/environment';
    import { defaultEvmStores as evm, web3, selectedAccount, connected, chainId, chainData } from 'svelte-web3';


    onMount(async () => {
		if(browser) {
			await evm.setProvider()
			// if ($chainId != 7700) {
			// 	alert("Please connect to the Polygon or BSC network.")
			// }
		}
	});

    function logout() {
        evm.disconnect()
    }

    export async function loginWithEth() {
        if(browser) {
            // Web3 provider
            // defaultEvmStores.setProvider('https://eth-mainnet.nodereal.io/v1/1659dfb40aa24bbb8153a677b98064d7')
            await evm.setProvider()
            // if ($chainId != 7700) {
            // 	alert("Please connect to the Canto network.")
            // }
        }
    }
    
</script>

    <nav>
        <div class="link-container">
            <a href="/">Marketplace</a>
            <a href="/">Tokenomics</a>
            <a href="/battle">About Us</a>
        </div>
        {#if !$connected}
        <div class="login-button-container">
            <button on:click="{loginWithEth}">Connect</button>
        </div>
        {/if}
        {#if $selectedAccount}
        <div class="login-button-container">
            <button id="logout-button" on:click="{logout}">{$selectedAccount.slice(0, 4)}..{$selectedAccount.slice(38, 42)}</button>
        </div>
        {/if}
    </nav>

<style>

    nav {
        display: flex;
        justify-content: space-between;
        align-items: center;
        width: 80%;
        margin: 0;
        padding: 1em;
        /* background-color: rgba(58, 75, 64, 0.1); */
        border-radius: 10px;
        z-index: 3;
    }

    nav > .link-container > a {
        text-decoration: none;
        padding: 1em;
        font-size: 1.8em;
        font-weight: 700;
        color: #ffffff;
        /* -webkit-text-stroke: 0.7px rgb(255, 255, 255);
        text-stroke: 0.7px rgb(255, 255, 255); */
    }

    .login-button-container > button {
        max-width: 100px;
        max-height: 50px;
        justify-items: center;
        align-items: center;
        border: 1px solid black;
        color: #250abb;
        font-size: 1.8em;
        font-weight: 700;
        background: #f7d621;
        /* -webkit-text-stroke: 1px #250abb;
        text-stroke: 1px #250abb; */
    }

    #logout-button {
        max-width: 100px;
        max-height: 50px;
        justify-items: center;
        align-items: center;
        border: 1px solid black;
        color: #250abb;
        font-size: 1.4em;
        font-weight: 700;
    }

    button:hover {
      /* transform: translateY(-5px); */
      background: #ffffff;
      cursor: pointer;
      color: #1c050f;
      transition: all 0.3s;
    }

    #logout-button:hover {
      /* transform: translateY(-5px); */
      background: #ffffff;
      cursor: pointer;
      color: #1c050f;
      transition: all 0.3s;
    }

    @media (min-width: 0px) and (max-width: 530px) {
        nav {
            display: grid;
        }

     }
</style>