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

    import { ethers, utils } from "ethers";
    import { onMount } from "svelte";
    import { constants } from "buffer";

    import {
    generateMerkleTree,
    verify,
    getMerkleTreeValues,
  } from "./utils/merkletree";

  import airdropData from "./chainData/airdrop";
    import { listen } from "svelte/internal";
    import { formatEther, parseUnits } from "ethers/lib/utils";

  let contractMerklRoot;
  let currentAddr;
  let currentDropAddr;
  let isDropDisabled = "";
  let isDropClaimed;
  let claimInProgress;
  let isDAOMember;
  let isOnMountLoading;
  let amtToBurn = 1;
  let WlWbalanceOfDAO;
  let burnAllowance;
  let currentBaseInflation;
  let currentBaseInflationperSec;
  let currentInternalTokenBalance;


  let WFDAO;

  let WLWbalance;

  onMount( async () => {

let isLoggedIn = sessionStorage.getItem("loggedIn");
if (isLoggedIn == "true") {
    isOnMountLoading = true;

  
    await defaultEvmStores.setProvider();

  await defaultEvmStores.attachContract(
    "WALLtoken",
    AddrX[$chainId].WALLtoken,
    WALLtokenABI
  );

  await defaultEvmStores.attachContract(
    "WFDAO",
    AddrX[$chainId].DAOinstanceWLW,
    IinstanceDAOABI
  );
    WFDAO = $contracts.WFDAO;

  await defaultEvmStores.attachContract(
    "CSRvault",
    AddrX[$chainId].CSRvault,
    ICSRvaultABI
  );

  

  await wlwBalanceOfSigner();
  await getWlWofDAO();
//   await fetchInternalTokenBalance();

    // const chainAddr = AddrX[$chainId];
    // await defaultEvmStores.attachContract("Wdrop",  AddrX[$chainId].airdrop, WLWdropABI);
    await verifyAddrDrop($signerAddress);
    await fetchBaseDAOInflation();
    WLWbalance = await wlwBalanceOfSigner();
    isDAOMember = await WFDAO.isMember($signerAddress);
    burnAllowance = await $contracts.WALLtoken.allowance($signerAddress, AddrX[$chainId].CSRvault);
    isOnMountLoading= false;
}

    // currentDropAddr = $signerAddress ? $signerAddress : ethers.constants.AddressZero;

})

  const fetchBaseDAOInflation = async ( ) => {
    currentBaseInflation = await $contracts.WFDAO.baseInflationRate();
  }

  const fetchBaseDAOPerSecInflation = async ( ) => {
    currentBaseInflationperSec = await $contracts.WFDAO.baseInflationPerSec();
  }

//   const fetchInternalTokenBalance = async () => { 
//     let iAddr = await $contracts.WFDAO.internalTokenAddress();
//     let internalToken =  new ethers.Contract(iAddr, IDAO20ABI, $signer);
//     currentInternalTokenBalance = await internalToken.balanceOf(AddrX[$chainId].DAOinstanceWLW);
//     currentInternalTokenBalance = ethers.utils.formatEther(currentInternalTokenBalance);
//     console.log("internal balnace", currentInternalTokenBalance);

//   }


  const MrkRoot =  async () => {
    await defaultEvmStores.attachContract("Wdrop",  AddrX[$chainId].airdrop, WLWdropABI);
    contractMerklRoot = await $contracts.Wdrop.merkleRoot();
    console.log(`Contract Merkl Root --chaiID:${$chainId}-- --root:${contractMerklRoot}--- `);
    return contractMerklRoot;
  }

   const verifyAddrDrop = async (givenAdr) => {
    const root = await MrkRoot();
        const merkleTree = generateMerkleTree(airdropData.airdrop);
        console.log(givenAdr)

        const { leaf, proof } = getMerkleTreeValues(
            merkleTree,
            givenAdr,
            100,
          );

          const [isVerified, index] = verify(
            proof,
            merkleTree.getHexRoot(),
            "0x" + leaf.toString("hex"),
          );
    
          if (!isVerified) console.error("Couldn't verify proof!");
          isDropDisabled = isVerified ? "" : "text-muted";
          isDropClaimed = await $contracts.Wdrop.isClaimed(index);
          console.log("is Claimed: ", isDropClaimed , " is Verified : ", isVerified, " addr ", givenAdr);
          
          return proof;
  }


  const wlwBalanceOfSigner = async () => { 

    let balance = await $contracts.WALLtoken.balanceOf($signerAddress);
    balance = ethers.utils.formatEther(balance);
    console.log("wlw balance", balance);
    return balance;
}


    const claimAirD = async () => {
        const merkleTree =  generateMerkleTree(airdropData.airdrop);
        const { leaf, proof } =  getMerkleTreeValues(
            merkleTree,
            $signerAddress,
            100,
          );
        console.log("Claiming airdrip with address : ", $signerAddress, "and proof : ", proof );
        let WdropContract = new ethers.Contract(AddrX[$chainId].airdrop, WLWdropABI, $signer);
        await WdropContract.claimTokens("100000000000000000000", proof);
        
        isDropClaimed = true;
        claimInProgress = false;
    }

    const mintMembership = async () => {
        let tx = await $contracts.WFDAO.mintMembershipToken($signerAddress);
        tx.wait(1);
        console.log(tx);
        isDAOMember = true;
    }



    const trickleVestToDAO = async () => {
        await $contracts.MiniVest.withdrawToWallaW();
    }


    const burnWFtokens = async () => {
        
        let toB = String(amtToBurn);
        // toB = ethers.utils.parseEther(toB);
        console.log("amt", toB)
        await $contracts.CSRvault.withdrawBurn(toB);

    }

    const approveWFforBurn = async () => {

        let toB = String(amtToBurn);
        // toB = ethers.utils.parseEther(toB);

        console.log(toB)

        await $contracts.WALLtoken.approve( AddrX[$chainId].CSRvault, toB);
        burnAllowance = await $contracts.WALLtoken.allowance($signerAddress,AddrX[$chainId].CSRvault)
    }

    const getWlWofDAO = async () => {
        WlWbalanceOfDAO= await $contracts.WALLtoken.balanceOf(AddrX[$chainId].DAOinstanceWLW);
        WlWbalanceOfDAO = ethers.utils.formatEther(WlWbalanceOfDAO);

    }

    const mintInflation = async () => {
        await $contracts.WFDAO.mintInflation();
    }




</script>

<div class="container {isOnMountLoading ? " d-none" : " "}">
    <br>
    <br>
    <br>
    <br>
    <div class="row">
        <span class="section-title {isDropClaimed ? "already-claimed-throughline" : "" }">
            <b><i class="claimA-btn" on:click={claimAirD}><a href="" class="a-claim {isDropDisabled} {isDropClaimed ? "d-none" : ""}">Claim</a></i>/</b>airdrop/<input on:change={verifyAddrDrop($signerAddress)} class="section-input-address" type="text" placeholder="{$signerAddress ? $signerAddress : ethers.constants.AddressZero}" bind:value={$signerAddress}>    
        </span>
    </div>
    <div class="row">
        <span class="{WLWbalance ? "hasBalance" : "d-none" }">
            <!-- Current balance: <i>{ethers.utils.parseEther(WLWbalance)} $WF</i> -->
        </span>
    </div>
    <div class="row">
        <span class="isorMintMember">
            you are <span class="notamember">{isDAOMember ? "" : " not "} </span> a fellow member
        </span>
        <br>
        <span class="qualify {(!isDAOMember) ? "" : "d-none"}">
            { WLWbalance >= 80 ? "Congratulations! You qualify! 🎉" : "You need to maintain a minimum WL$ balance to claim and hold a membership token"}
            
        </span>
        <button class="mintMembershipToken btn btn-outline-info {(!isDAOMember) && (WLWbalance >= 80)  ?  "" : "d-none" }"
            on:click={mintMembership}
            >Click Here Now To Mint Your Brand New Membership Token<span class="text-muted">*</span></button>
        <span class="text tandc text-muted {(!isDAOMember) && (WLWbalance >= 80)  ?  "" : "d-none" }">*Terms and conditions apply. Failure to maintain the standard minimum balance may result in membership revocation.</span>
        <br>
    </div>
    <br>

    <div class="row {$signerAddress ? "" : "d-none" }">
        <div class="row public ">
            <h5 class="pub-btns">permissionless actions</h5>
            <hr class="hrseparator">
            <hr class="hrseparator">
            <div class="row">
                <div class="col-4"> 
                    <p class="balanceOfContract text text-center">
    
    
                        WF DAO balance: {parseInt(WlWbalanceOfDAO)} WF$
                    </p>                
                </div>
                <div class="col-4"> 
                    <button class="public-button btn btn-outline-info btn-block" on:click={trickleVestToDAO}>trickle to DAO </button>
                        
                </div>
                <div class="col-4">
                    <p class="expl-text">
                        This action transports to WalllaW core DAO any outstanding available balance from its initial linear vesting.
                    </p>
                </div>
            </div>
            <hr class="hrseparator">
            <div class="row">
                <div class="col-4"> 
                    <p class="balanceOfContract text text-center">
    
                        redeem CSR share
                        <input type="number" class="form-control burnAmt" bind:value={amtToBurn} min=1 placeholder="1">
    
    
                    </p>                
                </div>
                <div class="col-4"> 
                    <button class="public-button btn btn-outline-info btn-block" on:click={approveWFforBurn}> Approve Amount </button>
                    <button class="public-button btn btn-outline-info btn-block { burnAllowance >= amtToBurn ? "" : "disabled" }" on:click={burnWFtokens}> burn WF$ </button>
                        
                </div>
                <div class="col-4">
                    <p class="expl-text">
                        This action burns WF$ tokens as redeeamable shares of accrued CSR revenue of WalllaW ecosystem. Credits eligible CANTO amount. 
                    </p>
                </div>
            </div>
            <hr class="hrseparator">
            <div class="row">
                <div class="col-4"> 
                    <div class="balanceOfContract text text-center">
                        current base inflation: <b> { currentBaseInflation }</b>% per year <br> 
                        <hr />
                        current base inflation: <b> { currentBaseInflationperSec ? currentBaseInflationperSec : 0  }</b>% per second <br>
                        <hr />
                        current internal token balance: <b> { parseInt(currentInternalTokenBalance)} </b>  
                    </div>                
                </div>
                <div class="col-4"> 
                    <button class="private-button mininflationbtn brn-block btn btn-outline-info" on:click={mintInflation}> mint inflation</button>
                        
                </div>
                <div class="col-4">
                    <p class="expl-text">
                        This action mints time dependent underlying value shares of the base WalllaW DAO. This occurs on any value related transaction and is used, among other things, as a mechanism to secure fairness across stakeholers.<br>
                        This internal accout of shares or as referenced elsewhere, internal token(s) is the lifeblood of any WalllaW DAO. It equitably secures recognition and redistribtuion in a fully decentralized environment. 
                    </p>
                    <p>By the way...</p>
                    <p> There are no admin rights to any of this. It was born, it yet has to move. It survives, or it does not. </p>
                </div>

            </div>
        </div>
        <div class="row memberArea">
            <hr class="hrseparator">
            <hr class="hrseparator">
            <br>
            <p class='desc-text'>
                WalllaWs are ultra new, arguably, type of organisations that are internet native and pursuing 'decentralization maxi' logic. 
                They don't use the default 'proposal' vehicle or anything like it. The assumption that it makes is that everything is connected to everything else. Which is typically true of things that are alive. <br> <br>
                They currate trhough permissionless allocations of resources and need specific areas of autonomy. It also assumes that governance costs, and if you think you can govern you should 'stake' on it. That is, pay to govern or pay for the likelyhood of wasting everyone else's time. 
            </p>

            <h5>Interfaces</h5>
            <hr>
            <div class='desc-text'>
                <ul>
                    <li>
                        <a href="https://xyz.walllaw.xyz/"> <b>  xyz.walllaw.xyz </b>- user-centric view. Has all buttons for all DAOs a user is member in. (requires protocol working knowledge to navigate)</a>
                    </li>

                </ul>
            </div>
            <h5>Code</h5>
            <hr>
            <div class='desc-text'>
                <ul>
                    <li>
                        <a href="https://github.com/parseb/WalllaW-COH"> <b>WalllaW-COH contracts</b> Working foundry repository for COH (canto) context</a>  
                    </li>
                    <li>
                        <a href="https://github.com/parseb/WALL-claim-site"> Code used on this page </a>  
                    </li>
                </ul>


            </div>

            <h5>Texts</h5>
            <hr>


            <div class='desc-text'>
                About WalllaW and related topics written at different time in its current becoming: <br> 
                <ul>
                    <li>
                        <a href="https://dino.skin/"> <b>dino.skin</b> - explanation website (Decentralized Internet Native Organizations) </a>  
                    </li>
                    <li>
                        <a href="https://mirror.xyz/parseb.eth/1FOgaw_OLmJOXrlvIdfkMBVRCGQx5_v7EhhZFBIXnYk"> <b>towards police free governance</b> (blog)</a>  
                    </li>
                    <li>
                        <a href="https://mirror.xyz/parseb.eth/tG6klr6f4oBo2q8A6vK6PQuxkUv7bLoLSJP5BxMrgkk"> <b>What are DAOs for?</b> (blog)</a>  
                    </li>
                    <li>
                        <a href="https://mirror.xyz/parseb.eth/za_Jc_AETmGt5pbmqqxxQGVzGHU_qH0bnUsbsLGnF78">WalllaW (readme) (blog)</a>  
                    </li>
                    
                </ul>
            </div>
            
            <div class="social-links">
                <div class="row">
                    <div class="col-4"></div>
                    <div class="col-2 block d-inline">
                            <a class='inline-block' href="https://twitter.com/w_wallla"> <i class="bi bi-twitter"> w_walla</i></a>
                    </div>
                    <div class="col-2">
                                <a class='inline-block' href="https://guild.xyz/walllaw"><i class="bi bi-telegram">guild.xyz/walllaw</i></a>
                    </div>
                    </div>
                    <div class="col-4"></div>
                </div>
            </div>
        <br>
        <br>
        <br>
        <br>
    </div>
    <br>
    <br>
    <br>
    <br>
    

    <span class="WWdo">WWdo</span>

    
</div>

<style>
    
    :root {
        --main-blue: #1e51da;
        --main-green: #2cc0a6;
        --main-light: #c8ccc2;
        --main-peach: #dec5a0;
        --main-red: #cc403a;
    }


    .desc-text {
        color: var(--main-peach)
    }

    .mininflationbtn {
        width: 100%
    }
    .memberArea{
        padding-bottom: 50px;
        margin-bottom: 50px;
    }

    .WWdo {
        z-index:-2;
        font-size: 150px;
        bottom: -360px;
        position: absolute;
        right: 180px;
        opacity: 15%;
    }


    .burnAmt {
        background-color: transparent;
        border-top: none;
        border-left: none;
        border-right: none;
        border-radius: 0px;
        border-color: var(--main-light);
    }

    .expl-text {
        color: var(--main-peach)
    }

    .balanceOfContract {
        color: var(--main-peach);

    }
    .hrseparator {
        color: #1e51da;
        opacity: 40%;
    }

    .balanceOfContract {
        align-items: center;
    }

    .public-button {
        border-color: var(--main-red);
        color: var(--main-red);
        background-color: transparent;
        opacity:80%
    }
    .public-button:hover {
        opacity: 40%;
        background-color: var(--main-peach);
    }

    .private-button {
        border-color: var(--main-blue);
        color: var(--main-blue);
        opacity: 80%;
    }
    .private-button:hover {
        opacity: 40%;
        background-color: var(--main-peach);
    }

    .qualify {
        color: var(--main-light)
    }

    .tandc {
        font-size: 10px;
    }

    .pub-btns {
        color: var(--main-blue);
    }

    .memberArea {
        color: var(--main-blue);
    }


    .mintMembershipToken {
        border-top: none;
        border-left: none;
        border-right: none;
        border-radius: 40px;
        color:var(--main-peach);
        border-color:#1e51da;
    }

    .mintMembershipToken:hover {
        background-color: var(--main-peach);
        color: black;
        font-weight: 600;
    }

    .isorMintMember {
        color: var(--main-blue);
        font-size: 20px;
    }

    .notamember {
        color: var(--main-red)
    }

    .section-title{
        font-size: 30px;
        color: var(--main-blue);
        font-weight: 180;
        font-family: 'Arial Narrow';
        text-decoration: underline;
    }

    .hasBalance {
        color:#2cc0a6;
        font-size: 20px;
        font-family: 'Franklin Gothic Medium', 'Arial Narrow', Arial, sans-serif;
    }   

    .already-claimed-throughline {
        text-decoration: line-through;
        opacity: 50%;
    }

    .a-claim:hover {
        color: var(--main-red)
    }

    .claimA-btn {

    }

    .a-claim {
        text-decoration: none;
    }

    .section-input-address {
        background-color: inherit;
        color:inherit;
        width: 60%;
        border:none;
        display: inline;
        opacity: 80%;
    }

    .section-input-address:hover{
        color: #cc403a;
    }
    .section-input-address::placeholder { 
        color: var(--main-blue);
        opacity: 60%;
    }
    
    .disabled {
        color: gray;
    }
</style>
