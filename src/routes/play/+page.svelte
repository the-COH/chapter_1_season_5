<script lang="ts">

    import { goto } from '$app/navigation';
    import { onMount } from 'svelte';
    import { browser } from '$app/environment';
    import { defaultEvmStores as evm, web3, selectedAccount, connected, chainId, chainData } from 'svelte-web3';
    import nftABI from '../../contract/NFTabi.json';
    import gameABI from '../../contract/GameABI.json';
    import TestABI from '../../contract/TestABI.json';
    import { NFTcards } from '../../NFTs/NFTs';
    import { update }  from '../../stores/stores.js';
    
    // let SelectedSessionId :number;
    // SessionIdStore.subscribe(value => {
	// 	SelectedSessionId = value;
	// });

    let eventTesterAddress :string = "0x993cC8F4ccbe5345992122e50858DF82b2eE29d9";
    let nftAddress :string = "0x29B7e92bc53B1a881F33A0465444f96672AB4284";
    let gameAddress :string = "0x871b5812399ebeD14a1c8655CE784d2E7667d009";

    let hostingSession :boolean = false;

//////////////// Fighter Modal Handler /////////////////////////////////////////////////////////////////////////
    let ownNfts :string[] = [];
    let fighterOpen :boolean = false;
    let fighterOpen2 :boolean = false;
    let sessionIdB :number = 0;

    function closeFighterModal() {
        fighterOpen = false;
    }
    
    function confirmFighterModal(id :number) {
        fighterOpen = false;
        nftIdA = id;
        console.log(nftIdA);
    }

    async function openFighterModal() {
        fighterOpen = true;
        const contract = new $web3.eth.Contract(nftABI, nftAddress);
        let nfts = await contract.methods.walletOfOwner($selectedAccount).call({ $selectedAccount});
        ownNfts = nfts;
        // console.log(ownNfts);
    }

    async function openFighterModalForJoining(sessionId :number, amountAtStakeA :string) {
        const contract = new $web3.eth.Contract(nftABI, nftAddress);
        let nfts = await contract.methods.walletOfOwner($selectedAccount).call({ $selectedAccount});
        ownNfts = nfts;
        fighterOpen2 = true;
        sessionIdB = sessionId;
        amountAtStakeB = amountAtStakeA;
        // console.log(sessionId, amountAtStakeA);
    }

    function closeFighterModalForJoining() {
        fighterOpen2 = false;
    }
    
    function confirmFighterModalForJoining(id :number) {
        fighterOpen2 = false;
        nftIdB = id;
        joinSession()
        // console.log(nftIdB)
    }

    let normalBorder = "4px solid #041225";
    // let selectedNFTborderColor :string = "4px solid #06fc99";
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////// Stake Modal Handler /////////////////////////////////////////////////////////////////////////
    let stakeOpen :boolean = false;

    function closeStakeModal() {
        stakeOpen = false;
    }
    
    function confirmStakeModal(amount :string) {
        stakeOpen = false;
        amountAtStakeA = amount.toString();
    }

    function openStakeModal() {
        stakeOpen = true;
    }
/////////////////////////////////////////////////////////////////////////////////////////////////////////////


/////////////// Event Subscription /////////////////////////////////////////////////////////////////////////
// const contract = new $web3.eth.Contract(TestABI, eventTesterAddress)

// let event_hash = $web3.utils.sha3('SessionJoined({sessionIdB})');

// let options = {
//     address: eventTesterAddress,
//     topics: [null]
// };


// let subscription = $web3.eth.subscribe('logs', options, function(error, result){
//     if (!error) console.log('got result');
//     else console.log(error);
// }).on("data", function(log) {
//     console.log('got data', log);
// }).on("changed", function(log){
//     console.log('changed');
// });

// info.events.NewSession.returnValues[0]

// $: console.log($subscription)

// let options = {
//     filter: {
//         value: []    //Only get events where transfer value was 1000 or 1337
//     },
//     fromBlock: 0,                  //Number || "earliest" || "pending" || "latest"
//     toBlock: 'latest'
// };

// let sub = contract.getPastEvents('NewSession', options)
//     .then(results => console.log(results))
//     .catch(err => throw err);

// $: console.log(sub)

///////////////////////////////////////////////////////////////////////////////////////////////////////////



    let selected :number = 1;
    let color1 :string = "#f7d621";
    let color2 :string = "white";
    let color3 :string = "white";

    function select(i:number) {
        if(i == 1) {
            selected = 1;
            color1 = "#f7d621";
            color2 = "white";
            color3 = "white";
        }

        if(i == 2) {
            selected = 2;
            color1 = "white";
            color2 = "#f7d621";
            color3 = "white";
        }

        if(i == 3) {
            selected = 3;
            color1 = "white";
            color2 = "white";
            color3 = "#f7d621";
        }
        // console.log(i)
    }

    onMount(async () => {
		if(browser) {
			await evm.setProvider();
            getSessions();
            // testEvent();
			// if ($chainId != 7700) {
			// 	alert("Please connect to the Polygon or BSC network.")
			// }
		}
	});
    
    // $: if($selectedAccount) {
    //         getSessions();
    //     }

    type SessionsData = {
        "SessionId" :string,
        "PlayerA" :string,
        "PlayerB" :string,
        "nftIdA" :number,
        "nftIdB" :number,
        "nftHpA" :number,
        "nftHpB" :number,
        "nftNrgA" :number,
        "nftNrgB" :number,
        "amountAtStakeA" :number,
        "amountAtStakeB" :number,
        "TurnOfPlayer" :number,
        "SessionState" :number,
    };

  export let Sessions :SessionsData[] = [];
  export let SessionsOngoing :SessionsData[] = [];

  async function getOngoingSessions() {
        SessionsOngoing = [];
        const contract = new $web3.eth.Contract(gameABI, gameAddress)

        let index = await contract.methods.sessions().call({ })
        await $selectedAccount != null;
        let addr :string = await $web3.eth.getAccounts();
        const check = await contract.methods.adrCheck($selectedAccount).call({ from: $selectedAccount });
        console.log(check)
        if(check != 0) {
            hostingSession = true;
        }
        if(check == 0) {
            hostingSession = false;
        }
        // console.log(inSession);

        for (let i = 1; i <= index; i++) {
          const info = await contract.methods.SessionIDMapping(i).call({ from:  $selectedAccount });
          if ((info[0] == addr && info[11] == 1 ) || (info[1] == addr && info[11])) {
            SessionsOngoing.push({
                "SessionId": await contract.methods.adrCheck(info.playerA).call({ from: $selectedAccount }),
                "PlayerA": info.playerA,
                "PlayerB": info.playerB,
                "nftIdA": info.nftIdA,
                "nftIdB": info.nftIdB,
                "nftHpA": info.nftHpA,
                "nftHpB": info.nftHpB,
                "nftNrgA": info.nftNrgA,
                "nftNrgB": info.nftNrgB,
                "amountAtStakeA": info.amountAtStakeA,
                "amountAtStakeB": info.amountAtStakeB,
                "TurnOfPlayer": info.TurnOfPlayer,
                "SessionState": info.SessionState,
              });
          }
        }
        console.log(SessionsOngoing);
    }

  async function getSessions() {
        Sessions = [];
        const contract = new $web3.eth.Contract(gameABI, gameAddress)

        let index = await contract.methods.sessions().call({ })
        await $selectedAccount != null;
        let addr :string = await $web3.eth.getAccounts();
        const check = await contract.methods.adrCheck($selectedAccount).call({ from: $selectedAccount });
        console.log(check)
        if(check != 0) {
            hostingSession = true;
        }
        if(check == 0) {
            hostingSession = false;
        }
        // console.log(inSession);

        for (let i = 1; i <= index; i++) {
          const info = await contract.methods.SessionIDMapping(i).call({ from:  $selectedAccount });
          //console.log(info.SessionState);
          //console.log(info[0], info[1], info[11]);
          // info.playerA = info[0];
          // info.playerB = info[1];
          // info.SessionState = info[11];
          if (info[0] != "0x0000000000000000000000000000000000000000" && info[0] != addr && info[11] == 0) {
            Sessions.push({
                "SessionId": await contract.methods.adrCheck(info.playerA).call({ from: $selectedAccount }),
                "PlayerA": info.playerA,
                "PlayerB": info.playerB,
                "nftIdA": info.nftIdA,
                "nftIdB": info.nftIdB,
                "nftHpA": info.nftHpA,
                "nftHpB": info.nftHpB,
                "nftNrgA": info.nftNrgA,
                "nftNrgB": info.nftNrgB,
                "amountAtStakeA": info.amountAtStakeA,
                "amountAtStakeB": info.amountAtStakeB,
                "TurnOfPlayer": info.TurnOfPlayer,
                "SessionState": info.SessionState,
              });
          }
        }
        console.log(SessionsOngoing);
    }

    let stakeInput :string = "1";

    $: if(stakeInput.length > 10 || stakeInput.match(/\D/) || stakeInput[0] == "0" || stakeInput[0] == " ") {
        stakeInput = "1";
    }
    
    let amountAtStakeA :string = "0";
    let amountAtStakeB :string = "0";
    let nftIdA :number = 0;
    let nftIdB :number = 0;
    let seventeenZeros :string = "000000000000000000";

    async function createSession() {
        const contract = new $web3.eth.Contract(gameABI, gameAddress);
        let receiptInformation;
        // let convertedBigInt = BigInt(parseInt(amontAtStakeA + "00000000000000000"));
        //   const allowance = await contract.methods.allowance($selectedAccount).call({ from: $selectedAccount })
        //  { from: $selectedAccount, gasPrice : 35000000000, gasLimit: 200000 }
        console.log(amountAtStakeA + seventeenZeros);
        const createSession = await contract.methods.createSession(BigInt(parseInt(amountAtStakeA + seventeenZeros)), nftIdA).send({ from: $selectedAccount, value: (amountAtStakeA + seventeenZeros) });
        amountAtStakeA = "0";
        nftIdA = 0;
        console.log("Session Created");
        // receiptInformation = await $web3.eth.getTransactionReceipt(createSession.transactionHash)
        // console.log(receiptInformation);
        // update(createSession.events.NewSession.returnValues[0]);
        // goto("/battle");
    }

    async function joinSession() {
        const contract = new $web3.eth.Contract(gameABI, gameAddress);
        let convertedBigInt = BigInt(parseInt(amountAtStakeB));
        let receiptInformation;
        //   const allowance = await contract.methods.allowance($selectedAccount).call({ from: $selectedAccount })
        //  { from: $selectedAccount, gasPrice : 35000000000, gasLimit: 200000 }
        // console.log(convertedBigInt);
        update(sessionIdB);
        // console.log(sessionIdB);
        let info = await contract.methods.joinSession(sessionIdB, nftIdB).send({ from:  $selectedAccount, value: (amountAtStakeB) });
        // receiptInformation = await contract.events.SessionJoined({filter: {nftIdB} }, function(error, event){ console.log(event); })
        // receiptInformation = await $web3.eth.getTransactionReceipt();
        // console.log(receiptInformation.events);
        goto("/battle");
        // let status = receipt.status;
    }

    function goToSession(i :number) {
        update(i);
        goto("/battle");
        // console.log(SessionIdStore);
    }

    async function testEvent() {
        const contract = new $web3.eth.Contract(TestABI, eventTesterAddress);
        let receiptInformation;
        let info = await contract.methods.newSession(777).send({ from:  $selectedAccount });
        receiptInformation = await $web3.eth.getTransactionReceipt(info.transactionHash);
		// let status = receiptInformation.on('receipt')
        // console.log(info.events.NewSession.returnValues[0]); 
    }


</script>

    <section>
        <h1>Sessions</h1>
        <!-- <button on:click="{testEvent}">Test Event</button> -->
        <div>
            <div class="session-selection">
                <h2 style="color: {color1};" on:click="{()=>select(1)}" on:keypress="{()=>select(1)}">Create a Session</h2>
                <h2 style="color: {color2};" on:click="{()=>select(2)}" on:keypress="{()=>select(2)}">Join a Session</h2>
                <h2 style="color: {color3};" on:click="{()=>select(3)}" on:keypress="{()=>select(3)}">Ongoing Sessions</h2>
            </div> 
            {#if selected == 1}
                {#if !hostingSession}
                <div class="sessions-container-1">
                    <div class="create-session-container">
                        <div class="place-stake-container">
                            <p>{amountAtStakeA}</p>
                            <img src="/img/logo-green-on-transparent-2.png" alt="Canto">
                            <button on:click="{openStakeModal}">Place Stake</button>
                        </div>
                        <div class="place-nft-container">
                            {#if nftIdA == 0}
                            <div>
                                <button on:click="{openFighterModal}">+Select Fighter</button>
                            </div>
                            {/if}
                            {#if nftIdA > 0}
                            <div>
                                <img on:click="{openFighterModal}" on:keypress="{openFighterModal}" src="https://storage.fleek.zone/e2fdad04-83fb-4c64-8a56-a7490cd84eb2-bucket/img/{nftIdA}.png" alt="NFT">
                            </div>
                            {/if}
                        </div>
                        {#if nftIdA == 0 || parseInt(amountAtStakeA) == 0}
                        <button class="inactive">Create Session</button>
                        {/if}
                        {#if nftIdA > 0 && parseInt(amountAtStakeA) > 0}
                        <button on:click="{createSession}">Create Session</button>
                        {/if}
                    </div>
                </div>
                {/if}
                {#if hostingSession}
                <div class="sessions-container-1">
                    <div>
                        <h1>Already in a Session!</h1>
                    </div>
                </div>
                {/if}
            {/if}
            {#if selected == 2} 
            <div class="sessions-container-2">
                <div class="join-session-container">
                    {#await getSessions()}
                        Loading ...
                    {:then}
                    {#each Sessions as ses}
                        <div class="join-session-block">
                            <div>
                                <img src="{NFTcards[ses.nftIdA].Image}" alt="Fighter Name">
                            </div>
                            <div>
                                <p>Player: </p>
                                <!-- <p>{ses.PlayerA}</p> -->
                                <p>{ses.PlayerA.slice(0, 4)}..{ses.PlayerA.slice(38, 42)}</p>
                            </div>
                            <div>
                                <p>HP:</p>
                                <p>{ses.nftHpA}</p>
                            </div>
                            <div>
                                <p>Current Stake: </p>
                                <div>
                                    <p>{(ses.amountAtStakeA).toString().slice(0, -18)}</p>
                                    <img src="/img/logo-green-on-transparent-2.png" alt="Canto">
                                </div> 
                            </div>
                            <div>
                                <p>Session ID: </p>
                                <p>{ses.SessionId}</p>
                            </div>
                            <div>
                                <p>Energy:</p>
                                <p>{ses.nftNrgA}</p>
                            </div>

                            <button on:click="{() => openFighterModalForJoining(parseInt(ses.SessionId), ses.amountAtStakeA.toString())}">Join Session</button>

                            <!-- <p>{ses.amountAtStakeA}</p>
                            <p>{ses.amountAtStakeB}</p> -->
                        </div>
                    {/each}
                    {:catch error}
                        <!-- promise was rejected -->
                    {/await}
                    <!-- <button on:click="{createSession}">Create Session</button>
                    <button on:click="{getSession}">Get Session</button> -->
                </div>
            </div>
            {/if}
            {#if selected == 3} 
            <div class="sessions-container-2">
                <div class="join-session-container">
                    {#await getOngoingSessions()}
                        Loading ...
                    {:then}
                    {#each SessionsOngoing as ses}
                        <div class="join-session-block">
                            <div>
                                <img src="/img/cards/card{4}.png" alt="Fighter Name">
                            </div>
                            <div>
                                <p>PlayerA: </p>
                                <!-- <p>{ses.PlayerA}</p> -->
                                <p>{ses.PlayerA.slice(0, 4)}..{ses.PlayerA.slice(38, 42)}</p>
                            </div>
                            <div>
                                <p>PlayerB: </p>
                                <!-- <p>{ses.PlayerA}</p> -->
                                <p>{ses.PlayerB.slice(0, 4)}..{ses.PlayerB.slice(38, 42)}</p>
                            </div>
                            <div>
                                <p>Current Stake: </p>
                                <div>
                                    <p>{(ses.amountAtStakeA).toString().slice(0, -18)}</p>
                                    <img src="/img/logo-green-on-transparent-2.png" alt="Canto">
                                </div> 
                            </div>
                            <div>
                                <p>Session ID: </p>
                                <p>{ses.SessionId}</p>
                            </div>
                            <div>
                                <p>Turn: </p>
                                <p>{ses.TurnOfPlayer == 0 ? "PlayerA" : "Player B"}</p>
                            </div>

                            <button on:click="{() => goToSession(parseInt(ses.SessionId))}">Go To Session</button>

                            <!-- <p>{ses.amountAtStakeA}</p>
                            <p>{ses.amountAtStakeB}</p> -->
                        </div>
                    {/each}
                    {:catch error}
                        <!-- promise was rejected -->
                    {/await}
                    <!-- <button on:click="{createSession}">Create Session</button>
                    <button on:click="{getSession}">Get Session</button> -->
                </div>
            </div>
            {/if}
        </div>

        {#if stakeOpen}
        <div id="stake-modal-container" class="stake-modal">
            <div class="stake-modal-content">
                <span on:click="{closeStakeModal}" class="stake-close-button" on:keypress="{closeStakeModal}">×</span>

                <div class="stake-input-modal">
                <input name="stake" bind:value={stakeInput} type="text" inputmode="numeric">
                <button on:click="{() => confirmStakeModal(stakeInput)}">Confirm</button>
                </div>

            </div>
        </div>
        {/if}

        {#if fighterOpen}
        <div id="fighter-modal-container" class="fighter-modal">
            <div class="fighter-modal-content">
                <span on:click="{closeFighterModal}" class="fighter-close-button" on:keypress="{closeFighterModal}">×</span>

                <div class="fighter-selection-modal">
                    <!-- {#await ownNfts}
                        Loading ...
                    {:then} -->
                    {#each ownNfts as id}
                    <div class="fighter-modal-select" on:click={() => confirmFighterModal(parseInt(id))} on:keypress={() => confirmFighterModal(parseInt(id))}>
                        <div class="fighter-img-modal-container" style="border: {normalBorder};">
                            <img src="{NFTcards[parseInt(id)].Image}" alt="{id}">
                        </div>
                        <div class="fighter-stats-modal-container" style="border: {normalBorder};">
                            <p>{NFTcards[parseInt(id)].Name}</p>
                            <p>HP: {NFTcards[parseInt(id)].HP}</p>
                            <p>NRG: {NFTcards[parseInt(id)].Energy}</p>
                            <p>{NFTcards[parseInt(id)].Type}</p>
                        </div>
                    </div>
                    {/each}
                    <!-- {/await} -->
                </div>

            </div>
        </div>
        {/if}

        {#if fighterOpen2}
        <div id="fighter-modal-container" class="fighter-modal">
            <div class="fighter-modal-content">
                <span on:click="{closeFighterModalForJoining}" class="fighter-close-button" on:keypress="{closeFighterModalForJoining}">×</span>

                <div class="fighter-selection-modal">
                    <!-- {#await ownNfts}
                        Loading ...
                    {:then} -->
                    {#each ownNfts as id}
                    <div class="fighter-modal-select" on:click={() => confirmFighterModalForJoining(parseInt(id))} on:keypress={() => confirmFighterModalForJoining(parseInt(id))}>
                        <div class="fighter-img-modal-container" style="border: {normalBorder};">
                            <img src="{NFTcards[parseInt(id)].Image}" alt="{id}">
                        </div>
                        <div class="fighter-stats-modal-container" style="border: {normalBorder};">
                            <p>{NFTcards[parseInt(id)].Name}</p>
                            <p>HP: {NFTcards[parseInt(id)].HP}</p>
                            <p>NRG: {NFTcards[parseInt(id)].Energy}</p>
                            <p>{NFTcards[parseInt(id)].Type}</p>
                        </div>
                    </div>
                    {/each}
                    <!-- {/await} -->
                </div>

            </div>
        </div>
        {/if}
    </section>
<style>
    section {
        display: grid;
        justify-items: center;
        align-items: center;
        width: fit-content;
        width: 100%;
        height: 100vh;
        margin-top: 0em;
        z-index: 3;
    }

    h1 {
        font-size: 4em;
        font-weight: 700;
        max-height: 400px;
        color: #f7d621;
        /* text-shadow: 1px 1px 10px #f7d621; */
        /* margin: 0px;
        padding: 0px; */
    }

    section > div {
        display: grid;
        justify-items: center;
        align-items: start;
        height: 100vh;
        width: 100%;
    }

    .session-selection {
        display: grid;
        justify-items: center;
        align-items: center;
        width: 45%;
        max-width: 800px;
        grid-template-columns: auto auto;
    }

    .session-selection > h2:nth-child(1) {
        font-size: 2em;
        font-weight: 700;
        max-height: 400px;
        margin: 50px 0px 0px 0px;
        cursor: pointer;
    }

    .session-selection > h2:nth-child(2) {
        font-size: 2em;
        font-weight: 700;
        max-height: 400px;
        margin: 50px 0px 0px 0px;
        cursor: pointer;
    }

    .session-selection > h2:nth-child(3) {
        font-size: 2em;
        font-weight: 700;
        max-height: 400px;
        margin: 20px 0px 50px 0px;
        cursor: pointer;
        grid-column: 1/3;
    }





    .sessions-container-1 {
        position: relative;
        display: grid;
        align-items: center;
        justify-items: center;
        grid-gap: 1em;
        color: white;
        width: 50%;
        height: 500px;
        border: 2px solid white;
        margin-top: -15em;
    }

    .sessions-container-2 {
        position: relative;
        display: grid;
        align-items: center;
        justify-items: center;
        grid-gap: 1em;
        color: white;
        width: 50%;
        height: 500px;
        border: 2px solid white;
        margin-top: -15em;
        overflow-y: scroll;
    }

    .create-session-container {
        display: grid;
        align-items: center;
        justify-items: center;
        grid-template-columns: auto auto;
    }





    .place-stake-container {
        display: grid;
        align-items: center;
        justify-items: center;
        grid-template-columns: auto auto;
        margin-top: -50px;
    }

    .place-stake-container > button {
        max-width: 100px;
        max-height: 30px;
        justify-items: center;
        align-items: center;
        border: 1px solid black;
        color: #250abb;
        font-size: 1.2em;
        font-weight: 500;
        background: #f7d621;
        grid-column: 3/1;
    }

    .place-stake-container > button:hover {
        background: #ffe552;
        transition: all 0.3s linear;
    }

    .place-stake-container > p {
        font-size: 3em;
        margin: 0px;
    }

    .place-stake-container > img {
        width: 27px; 
        height: 27px;
    }

    .place-nft-container {
        display: grid;
        align-items: center;
        justify-items: center;
        background-color: rgba(130, 130, 130, 0.5);
        margin: 0px 0px 0px 50px;
        border: 2px dashed #f7d621;
        border-radius: 15px;
        margin-top: -50px;
    }

    .place-nft-container > div {
        display: grid;
        align-items: center;
        justify-items: center;
        padding: 0px;
        margin: 0px;
        width: 180px;
        height: 250px;
    }

    .place-nft-container > div > button {
        max-width: 130px;
        max-height: 30px;
        justify-items: center;
        align-items: center;
        border: 1px solid black;
        color: #250abb;
        font-size: 1.2em;
        font-weight: 500;
        background: #f7d621;
    }

    .place-nft-container > div > button:hover {
        background: #ffe552;
        transition: all 0.3s linear;
    }

    .place-nft-container > div > img {
        width: 107%;
        height: 107%;
        margin-top: -5px;
    }

    .place-nft-container > div > img:hover {
        cursor: pointer;
        opacity: 0.8;
        transition: all 0.2s linear;
    }







    .join-session-container {
        display: grid;
        align-items: center;
        justify-items: center;
        grid-template-columns: auto;
        width: 100%;
        padding: 20px 0px 20px 0px;
    }

    .join-session-block {
        display: grid;
        justify-items: center;
        align-items: center;
        grid-template-columns: auto auto auto auto;
        max-width: 700px;
        width: 90%;
        height: 90%;
        padding: 0px 0px 0px 0px;
        background: #f7d621;
        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
        border-radius: 0.5em;
        margin: 15px 0px 5px 0px;
    }

    .join-session-block > div {
        display: grid;
        justify-items: center;
        align-items: center;
    }

    .join-session-block > div:nth-child(1) {
        width: 70px;
        height: 90px;
        border-radius: 10px;
        margin: 0px;
        padding: 0px;
        border: 2px dashed #250abb;
        grid-row: 1/3;
        background-color: rgba(255, 255, 255, 0.5);
        overflow: hidden;
    }

    .join-session-block > div > img {
        width: 100%;
        height: 100%;
        margin-top: -2px;
    }

    .join-session-block > div > p {
        margin: 0px;
        padding: 0px;
        color: #250abb;
    }

    .join-session-block > div > p:nth-child(2) {
        font-size: 1.4em;
        font-weight: 600;
    }

    .join-session-block > div:nth-child(4) > div {
        display: flex;
        justify-content: center;
        align-items: center;
    }

    .join-session-block > div:nth-child(4) > div > p {
        margin: 0px;
        padding: 0px;
        width: 15px;
        color: #250abb;
        font-size: 1.4em;
        font-weight: 600;
    }

    .join-session-block > div:nth-child(4) > div > img {
        width: 14px;
        height: 15px;
        margin: 0px;
        padding: 0px;
    }

    .join-session-block > button {
        max-width: 130px;
        max-height: 30px;
        justify-items: center;
        align-items: center;
        border: 1px solid black;
        color: #250abb;
        font-size: 1.2em;
        font-weight: 500;
        background: #85fa5e;
        /* grid-column: 2/3; */
    }

    .join-session-block > button:hover {
        cursor: pointer;
        background-color: #63e737;
        transition: all 0.3s linear;
    }





    .create-session-container > button {
        position: absolute;
        max-width: 180px;
        max-height: 50px;
        justify-items: center;
        align-items: center;
        border: 1px solid black;
        color: #250abb;
        font-size: 1.8em;
        font-weight: 500;
        background: #f7d621;
        bottom: 2%;
        grid-column: 3/1;
    }

    .create-session-container > button:hover {
        background: #ffe552;
        transition: all 0.3s linear;
    }
    









/************** Stake Modal ********************************************************************/

      .stake-modal {
        display: block; 
        position: fixed; 
        z-index: 1; 
        padding-top: 50px; 
        left: 0;
        top: 0;
        width: 100%;
        height: 100%; 
        overflow: auto;
        background-color: rgb(0,0,0);
        background-color: rgba(0, 0, 0, 0.95); 
      }

      /* Modal Content */
      .stake-modal-content {
        background-color: #f7d621;
        margin: auto;
        padding: 10px 15px;
        border: 1px solid #888;
        width: 80%;
        border-radius: 20px;
        margin-top: 15em;
        height: 200px;
      }

      /* The Close Button */
      .stake-close-button {
        color: #000000;
        float: right;
        font-size: 30px;
        font-weight: 700;
        width: 35px;
        height: 33px;
        text-align: center;
        border: 2px solid black;
        background-color: red;
      }

      .stake-close-button:hover,
      .stake-close-button:focus {
        background-color: rgb(223, 0, 0);
        cursor: pointer;
      }

      .stake-input-modal {
        display: grid;
        justify-items: center;
        align-items: center;
        height: 200px;
      }

      .stake-input-modal > input {
        height: 40px;
        max-width: 150px;
        font-size: 2em;
      }
      
      .stake-input-modal > button {
        max-width: 130px;
        max-height: 30px;
        justify-items: center;
        align-items: center;
        border: 1px solid black;
        color: #250abb;
        font-size: 1.4em;
        font-weight: 500;
        background: #85fa5e;
      } 

/************** Stake Modal ********************************************************************/





/************** Fighter Modal ********************************************************************/

    .fighter-modal {
        display: block; 
        position: fixed; 
        z-index: 1; 
        padding-top: 50px; 
        left: 0;
        top: 0;
        width: 100%;
        height: 100%; 
        overflow: auto;
        background-color: rgb(0,0,0);
        background-color: rgba(0, 0, 0, 0.95); 
      }

      /* Modal Content */
      .fighter-modal-content {
        background-color: #f7d621;
        margin: auto;
        padding: 10px 15px;
        border: 1px solid #888;
        width: 80%;
        border-radius: 20px;
        margin-top: 5em;
        height: 40em;
      }

      /* The Close Button */
      .fighter-close-button {
        color: #000000;
        float: right;
        font-size: 30px;
        font-weight: 700;
        width: 35px;
        height: 33px;
        text-align: center;
        border: 2px solid black;
        background-color: red;
      }

      .fighter-close-button:hover,
      .fighter-close-button:focus {
        background-color: rgb(223, 0, 0);
        cursor: pointer;
      }

      .fighter-selection-modal {
        display: grid;
        justify-items: center;
        align-items: center;
        height: 500px;
        width: 100%;
        grid-template-columns: auto auto auto;
        margin-top: 5em;
        overflow-y: scroll;
      }

      .fighter-selection-modal > .fighter-modal-select {
        display: grid;
        justify-items: center;
        align-items: center;
        height: 200px;
        grid-template-columns: auto auto;
      }

      .fighter-selection-modal > .fighter-modal-select .fighter-img-modal-container {
        display: grid;
        justify-items: center;
        align-items: center;
        width: 120px;
        height: 150px;
        border-radius: 15px;
        overflow: hidden;
        transition: all 0.2s ease;
        cursor: pointer;
        z-index: 1;
      }

      .fighter-selection-modal > .fighter-modal-select > .fighter-img-modal-container > img {
        width: 120%;
        height: 130%;
        margin: 15px 0px 0px 0px;
      }

      .fighter-selection-modal > .fighter-modal-select > .fighter-stats-modal-container {
        display: grid;
        justify-items: left;
        align-items: center;
        width: 120%;
        height: 100px;
        background: #041225;
        margin: 0px 0px 0px -18px;
        border-radius: 0px 15px 15px 0px;
        transition: all 0.2s ease;
        z-index: 0;
      }

      .fighter-selection-modal > .fighter-modal-select > .fighter-stats-modal-container > p {
        padding: 0px;
        margin: 0px 0px 0px 25px;
        text-align: left;
      }
      

/************** Fighter Modal ********************************************************************/


.inactive {
    opacity: 0.8 !important;
    background-color: #888 !important;
    color: #dadada !important;
    cursor: default !important;
}


</style>