<script>
  import {
    defaultEvmStores,
    connected,
    provider,
    chainId,
    chainData,
    signer,
    signerAddress,
    contracts,
  } from "svelte-ethers-store";
  import { ethers } from "ethers";
  import { element, onMount } from "svelte/internal";

  import {
    AddrX,
    WLWdropABI,
    WALLtokenABI,
    ERC20ABI,
    ICSRvaultABI,
    IDAO20ABI,
    IODAOABI,
    IinstanceDAOABI,
    IMember1155ABI,
    IMembraneABI,
    MiniVestABI
  } from "./chainData/abi/ABIS";



  let loading;

  export const logIn = async () => {
    const p = new ethers.providers.Web3Provider(window.ethereum);
    const accounts = await p.send("eth_requestAccounts", []);
    const signer = p.getSigner();
    defaultEvmStores.setProvider(p);
    sessionStorage.setItem("loggedIn", "true");
    console.log(signerAddress);
  };

  export const logOut = async () => {
    sessionStorage.setItem("loggedIn", "false");
    defaultEvmStores.disconnect();
    // defaultEvmStores.setProvider(null);
    location.reload();
  };

  onMount(async () => {
    // add a test to return in SSR context
    let isLoggedIn = sessionStorage.getItem("loggedIn");
    if (isLoggedIn == "true") {
      await defaultEvmStores.setProvider();
      let chainAddr = AddrX[$chainId];

      await defaultEvmStores.attachContract("Wdrop", chainAddr.airdrop, WLWdropABI);

      await defaultEvmStores.attachContract(
        "WALLtoken",
        chainAddr.WALLtoken,
        WALLtokenABI
      );

      await defaultEvmStores.attachContract(
        "CSRvault",
        chainAddr.CSRvault,
        ICSRvaultABI
      );

      await defaultEvmStores.attachContract(
        "MiniVest",
        chainAddr.vest,
        MiniVestABI
      );

      await defaultEvmStores.attachContract("ODAO", chainAddr.ODAO, IODAOABI);

      await defaultEvmStores.attachContract(
        "MEMBERregistry",
        chainAddr.MEMBERregistry,
        IMember1155ABI
      );

      await defaultEvmStores.attachContract("WFDAO", chainAddr.DAOinstanceWLW , IinstanceDAOABI )
    }
  });


  let prevElement;
</script>

<div class="container">
  <div class="row">
    <div class="col-6">
      <div class="main-title">
        <div class="chain-name">
          {#if $chainId}
          {#if AddrX[$chainId] } 
        <p class="chainName">
          <span class="text { $chainId == 7700 ? 'isActiveChain' : 'inactive' }"> canto mainnet </span> |
          <span class="text { $chainId == 5 ? 'isActiveChain' : 'inactive' }"> goerli testnet </span> 
  
        </p>
          {:else}
          <p class="unsupportedChainName">
          -- <b> Unsupported </b> Chain: {$chainData.name} | {$chainData.chainId} --- 
          </p>
            {/if}
      {/if}
        </div>
        <p class="main-titlew">
          W<span class="title-a">a</span><span class="lll-title"
            >l<span class="middle-l">l</span>l</span
          ><span class="title-a">a</span>W <br />
        </p>
        <p class="signerAddress">
          {#if $signerAddress}
            {$signerAddress}
          {:else}
            {ethers.constants.AddressZero}
          {/if}
        </p>
      </div>
    </div>
    <div class="col-6">
      <div class="row"> 
        <div class="col-6">
        </div>
        <div class="col-6">
          <div class="inOurbtn">
            {#if $signerAddress}
              <button class="btn logOutbtn" on:click={logOut}> logOUT </button>
            {:else}
              <button class="btn logIntbtn" on:click={logIn}> logIN </button>
            {/if}
          </div>
        </div>
      </div>

    </div>
  </div>
  <slot />
</div>

<style>
  :root {
    --main-blue: #1e51da;
    --main-green: #2cc0a6;
    --main-light: #c8ccc2;
    --main-peach: #dec5a0;
    --main-red: #cc403a;
  }

  .chain-name {
    top:38px;
    position: absolute;
  }

  .isActiveChain {
    color:#2cc0a6;
  }

  .logOutbtn {
    font-size: 22px;
    color: var(--main-red);
    opacity: 50%;
  }

  .logOutbtn:hover {
    opacity: 100%;
  }

  .logIntbtn {
    font-size: 22px;
    color: var(--main-green);
    opacity: 50%;
  }

  .logIntbtn:hover {
    opacity: 100%;
  }

  .main-titlew {
    font-size: 120px;
    color: var(--main-blue);
    font-family: "Courier New", Courier, monospace;
    opacity: 10%;
    z-index: -1;
    position: absolute;
    top: 20px;
    background-color: #0e1823;
  }

  .signerAddress {
    top: 142px;
    position: absolute;
  }
  .middle-l {
    font-size: 54px;
  }

  span.title-a {
    font-size: 88px;
  }

  .lll-title {
    font-size: 60px;
  }
</style>
