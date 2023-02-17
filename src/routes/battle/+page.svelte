<script lang="ts">

    import { goto } from '$app/navigation';
    import { onMount } from 'svelte';
    import { browser } from '$app/environment';
    import { defaultEvmStores as evm, web3, selectedAccount, connected, chainId, chainData } from 'svelte-web3';
    import nftABI from '../../contract/NFTabi.json';
    import gameABI from '../../contract/GameABI.json';
    import TestABI from '../../contract/TestABI.json';
    import { NFTcards } from '../../NFTs/NFTs';
    import { each } from 'svelte/internal';
    import { writable, readable } from 'svelte/store';
    import { SessionIdStore }  from '../../stores/stores.js';

    let eventTesterAddress :string = "0x993cC8F4ccbe5345992122e50858DF82b2eE29d9";
    let nftAddress :string = "0x29B7e92bc53B1a881F33A0465444f96672AB4284";
    let gameAddress :string = "0x871b5812399ebeD14a1c8655CE784d2E7667d009";
    // let SelectedSessionId :number;
    // SessionIdStore.subscribe(value => {
	// 	$SelectedSessionId = value;
	// });

    let enemyAttacksEffect :boolean = false;
    let attackEnemyEffect :boolean = false;

    let winnerModal :boolean = false;
    let winnerPot :number = 0;
    let winnerPotConverted :string;
    $: winnerPotConverted = (winnerPot.toString().slice(0, -18)) + "." + (winnerPot.toString().slice(winnerPot.toString().length - winnerPot.toString().length + 1, -16))

    function closeWinnerModal() {
        winnerModal = false;
    }

    
    onMount(async () => {
		if(browser) {
			await evm.setProvider();
            // loadData();

            // console.log(SessionIdStore)
			// if ($chainId != 7700) {
			// 	alert("Please connect to the Polygon or BSC network.")
			// }
		}
	});

    const contract = new $web3.eth.Contract(gameABI, gameAddress)

    let subscriptionA = contract.events.TurnAEnded({
    filter: {myIndexedParam: [20,23], myOtherIndexedParam: '0x123456789...'}, // Using an array means OR: e.g. 20 or 23
    fromBlock: 0
    //@ts-ignore
    }, async function(error){
        const info = await contract.methods.SessionIDMapping(SessionIdStore).call({ from:  $selectedAccount });
        let hpB = Session[0].nftHpB;
        Session[0] = {
            "SessionId": SessionIdStore,
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
        };
        if(isPlayer == "B" && hpB > info.nftHpB) {
            enemyAttacksAnim();
        }
     })
    .on('data', function(){
    })
    //@ts-ignore
    .on('changed', function(){
        // remove event from local database
    })
    .on('error', console.error);

    let subscriptionB = contract.events.TurnBEnded({
    filter: {myIndexedParam: [20,23], myOtherIndexedParam: '0x123456789...'}, // Using an array means OR: e.g. 20 or 23
    fromBlock: 0
    //@ts-ignore
    }, async function(error){
        const info = await contract.methods.SessionIDMapping(SessionIdStore).call({ from:  $selectedAccount });
        let hpA = Session[0].nftHpA;
        Session[0] = {
            "SessionId": SessionIdStore,
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
        };
        if(isPlayer == "A" && hpA > info.nftHpA) {
            enemyAttacksAnim();
        }
     })
    .on('data', function(){
    })
    //@ts-ignore
    .on('changed', function(){
        // remove event from local database
    })
    .on('error', console.error);

    // contract.events.TurnBEnded({
    // filter: {myIndexedParam: [20,23], myOtherIndexedParam: '0x123456789...'}, // Using an array means OR: e.g. 20 or 23
    // fromBlock: 0
    // }, function(error, event){ console.log(event.returnValues[0]); })
    // .on('data', function(event){
    //     console.log(event.returnValues[0]); // same results as the optional callback above
    // })
    // .on('changed', function(event){
    //     // remove event from local database
    // })
    // .on('error', console.error);

    // let src :string = "/img/anim/empty.png"
    // const timeout = setTimeout(effect2, 1000);
    // function stop() {
    //     clearTimeout(timeout);
    // }

    // const timeout = setTimeout(effect2, 1000);
    // clearTimeout(timeout)

    // let anim :string = "effect 0s linear 0s 1;"

    // function effect() {
    //     anim = "effect 1.5s linear 0s 1;"
    //     // const timeout = setTimeout(effect2, 1000);
    //     // clearTimeout(timeout)
    // }

    // function effect2() {
    //     anim = ""
    // }

    type SessionData = {
        "SessionId" :number,
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

    type AtkData = {
        "Atk1Name" :string,
        "Atk1Dmg" :number,
        "Atk1Cost" :number,
        "Atk1Type" :number,
        "Atk2Name" :number,
        "Atk2Dmg" :number,
        "Atk2Cost" :number,
        "Atk2Type" :string,
        "Atk3Name" :String,
        "Atk3Gain" :number,
        "Atk3Cost" :number,
        "Atk3Type" :string,
        "Atk4Name" :String,
        "Atk4Gain" :number,
        "Atk4Type" :string,
    };

    let Attacks :AtkData[] = [];

    let Session :SessionData[] = [];
    // let SessionID :number = parseInt(SessionIdStore.toString());
    let isPlayer :string = "";

    async function loadData() {
        Session = [];
        let nftId :number;
        await $selectedAccount != null;
        let addr :string = await $web3.eth.getAccounts();
        const contract = new $web3.eth.Contract(gameABI, gameAddress)
        const contract2 = new $web3.eth.Contract(nftABI, nftAddress)
        const info = await contract.methods.SessionIDMapping(SessionIdStore).call({ from:  $selectedAccount });
        Session.push({
            "SessionId": SessionIdStore,
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
        if(addr == Session[0].PlayerA) {
            isPlayer = "A";
            const info1 = await contract2.methods.Attack1Mapping(Session[0].nftIdA).call({ from:  $selectedAccount });
            const info2 = await contract2.methods.Attack2Mapping(Session[0].nftIdA).call({ from:  $selectedAccount });
            const info3 = await contract2.methods.Attack3Mapping(Session[0].nftIdA).call({ from:  $selectedAccount });
            const info4 = await contract2.methods.Attack4Mapping(Session[0].nftIdA).call({ from:  $selectedAccount });
            console.log(info)
            Attacks.push({
                "Atk1Name": info1.Name,
                "Atk1Dmg": info1.Dmg,
                "Atk1Cost": info1.NrgCost,
                "Atk1Type": info1.Type,
                "Atk2Name": info2.Name,
                "Atk2Dmg": info2.Dmg,
                "Atk2Cost": info2.NrgCost,
                "Atk2Type": info2.Type,
                "Atk3Name": info3.Name,
                "Atk3Gain": info3.HpGain,
                "Atk3Cost": info3.NrgCost,
                "Atk3Type": info3.Type,
                "Atk4Name": info4.Name,
                "Atk4Gain": info4.NrgGain,
                "Atk4Type": info4.Type,
            })
        }
        if(addr == Session[0].PlayerB) {
            isPlayer = "B";
            const info1 = await contract2.methods.Attack1Mapping(Session[0].nftIdB).call({ from:  $selectedAccount });
            const info2 = await contract2.methods.Attack2Mapping(Session[0].nftIdB).call({ from:  $selectedAccount });
            const info3 = await contract2.methods.Attack3Mapping(Session[0].nftIdB).call({ from:  $selectedAccount });
            const info4 = await contract2.methods.Attack4Mapping(Session[0].nftIdB).call({ from:  $selectedAccount });
            Attacks.push({
                "Atk1Name": info1.Name,
                "Atk1Dmg": info1.Dmg,
                "Atk1Cost": info1.NrgCost,
                "Atk1Type": info1.Type,
                "Atk2Name": info2.Name,
                "Atk2Dmg": info2.Dmg,
                "Atk2Cost": info2.NrgCost,
                "Atk2Type": info2.Type,
                "Atk3Name": info3.Name,
                "Atk3Gain": info3.HpGain,
                "Atk3Cost": info3.NrgCost,
                "Atk3Type": info3.Type,
                "Atk4Name": info4.Name,
                "Atk4Gain": info4.NrgGain,
                "Atk4Type": info4.Type,
            })
        }
        
        winnerPot = ( (Session[0].amountAtStakeA * 2) - ( ( (Session[0].amountAtStakeA) * 2) / 100 * 5) );
        // Session = Session;
        // console.log(Attacks);
    }

    let atkNr :number;
    async function attack(i :number) {
        const testContract = new $web3.eth.Contract(TestABI, eventTesterAddress);
        const gameContract = new $web3.eth.Contract(gameABI, gameAddress);
        let receiptInformation
        atkNr = i;
        if(isPlayer == "A") {
            let atk = await gameContract.methods.turnA(SessionIdStore, atkNr).send({ from:  $selectedAccount });
            // receiptInformation = await $web3.eth.getTransactionReceipt(atk.transactionHash);
            if(i = 1 || 2) {
                attackEnemyAnim();
            }
        }
        if(isPlayer == "B") {
            let atk = await gameContract.methods.turnB(SessionIdStore, atkNr).send({ from:  $selectedAccount });
            // receiptInformation = await $web3.eth.getTransactionReceipt(atk.transactionHash);
            if(i = 1 || 2) {
                attackEnemyAnim();
            }
        }
        // console.log(receiptInformation);
        // loadData();
    }

    async function claimWin() {
        const testContract = new $web3.eth.Contract(TestABI, eventTesterAddress);
        const gameContract = new $web3.eth.Contract(gameABI, gameAddress);
        if(isPlayer == "A") {
            let atk = await gameContract.methods.claimWin(SessionIdStore).send({ from:  $selectedAccount });
        }
        if(isPlayer == "B") {
            let atk = await gameContract.methods.claimWin(SessionIdStore).send({ from:  $selectedAccount });
        }
        goto("/");
        // loadData();
    }

    let roundIndicator :string = "none";
    let roundIndicator2 :string = "none";

    $: if(isPlayer == "A" && Session[0].TurnOfPlayer == 0) {
        roundIndicator = "2px solid";
        roundIndicator2 = "none";
       }
    $: if(isPlayer == "B" && Session[0].TurnOfPlayer == 1) {
        roundIndicator = "2px solid";
        roundIndicator2 = "none";
       }
    $: if(!(isPlayer == "A" && Session[0].TurnOfPlayer == 0) && !(isPlayer == "B" && Session[0].TurnOfPlayer == 1)) {
        roundIndicator2 = "2px solid";
        roundIndicator = "none";
       }
        
        function enemyAttacksAnim() {
            enemyAttacksEffect = true;
            let t = setTimeout(function d() {enemyAttacksEffect = false;}, 1200);
       }

       function attackEnemyAnim() {
            attackEnemyEffect = true;
            let t = setTimeout(function d() {attackEnemyEffect = false;}, 1200);
       }

       $: if(isPlayer == "A" && (Session[0].nftHpB == 0 && Session[0].nftHpA != 0)) {
            winnerModal = true;
       }
       $: if(isPlayer == "B" && (Session[0].nftHpA == 0 && Session[0].nftHpB != 0)) {
            winnerModal = true;
       }

</script>

    <section>
        <!-- <button on:click={testAnim}>test</button> -->
        {#await loadData()}
           <h1>Loading ...</h1> 
        {:then}
        {#each Session as ses}
        <div>
            <div class="top" style="border: {roundIndicator2};">
                <div class="card-container-top">
                    {#if isPlayer == "A"}
                    <p>{ses.nftHpB}</p>
                    <div class="health-bar-top">
                        <div style="width: {(ses.nftHpB / NFTcards[ses.nftIdB].HP) * 100}%"></div>
                    </div>
                    <img src="{NFTcards[ses.nftIdB].Image}" alt="{NFTcards[ses.nftIdB].Name}">
                    {/if}
                    {#if isPlayer == "B"}
                    <p>{ses.nftHpA}</p>
                    <div class="health">
                        <div class="health-bar-top">
                            <div style="width: {(ses.nftHpA / NFTcards[ses.nftIdA].HP) * 100}%"></div>
                        </div>
                    </div>
                    <img src="{NFTcards[ses.nftIdA].Image}" alt="{NFTcards[ses.nftIdA].Name}">
                    {/if}
                    
                    {#if attackEnemyEffect}
                    <div id="effect">
                        <audio controls autoplay style="visibility: hidden;">
                            <source src="/sounds/damage.wav" type="audio/wav">
                        </audio>
                    </div>
                    {/if}

                </div>
            </div>

            <div class="bottom" style="border: {roundIndicator};">
                <div class="card-container-bottom">
                    {#if isPlayer == "A"}
                    <img src="{NFTcards[ses.nftIdA].Image}" alt="{NFTcards[ses.nftIdA].Name}">
                    <p>{ses.nftHpA}</p>
                    <div class="health">
                        <div class="health-bar-bottom">
                            <div style="width: {(ses.nftHpA / NFTcards[ses.nftIdA].HP) * 100}%"></div>
                        </div>
                    </div>
                    <div class="energy-container">
                        <p>Energy</p>
                        <h2>{ses.nftNrgA}</h2>
                    </div>
                    {/if}
                    {#if isPlayer == "B"}
                    <img src="{NFTcards[ses.nftIdB].Image}" alt="{NFTcards[ses.nftIdB].Name}">

                    {#if enemyAttacksEffect}
                    <div id="effect">
                        <audio controls autoplay style="visibility: hidden;">
                            <source src="/sounds/damage.wav" type="audio/wav">
                        </audio>
                    </div>
                    {/if}

                    <p>{ses.nftHpB}</p>
                    <div class="health">
                        <div class="health-bar-bottom">
                            <div style="width: {(ses.nftHpB / NFTcards[ses.nftIdB].HP) * 100}%"></div>
                        </div>
                    </div>
                    <div class="energy-container">
                        <p>Energy</p>
                        <h2>{ses.nftNrgB}</h2>
                    </div>
                    {/if}
                </div>
                <div class="attack-bottom">
                    <div class="atk1" on:click="{() => attack(1)}" on:keypress="{() => attack(1)}">
                        <h2>{Attacks[0].Atk1Name}</h2>
                        <div>
                            <p>Cost: {Attacks[0].Atk1Cost}</p>
                            <p>Damage: {Attacks[0].Atk1Dmg}</p>
                            <p>Type: {Attacks[0].Atk1Type}</p>
                        </div>
                    </div>
                    <div on:click="{() => attack(2)}" on:keypress="{() => attack(1)}">
                        <h2>{Attacks[0].Atk2Name}</h2>
                        <div>
                            <p>Cost: {Attacks[0].Atk2Cost}</p>
                            <p>Damage: {Attacks[0].Atk2Dmg}</p>
                            <p>Type: {Attacks[0].Atk2Type}</p>
                        </div>
                    </div>
                    <div on:click="{() => attack(3)}" on:keypress="{() => attack(1)}">
                        <h2>{Attacks[0].Atk3Name}</h2>
                        <div>
                            <p>Cost: {Attacks[0].Atk3Cost}</p>
                            <p>HP Gain: {Attacks[0].Atk3Gain}</p>
                            <p>Type: {Attacks[0].Atk3Type}</p>
                        </div>
                    </div>
                    <div on:click="{() => attack(4)}" on:keypress="{() => attack(1)}">
                        <h2>{Attacks[0].Atk4Name}</h2>
                        <div>
                            <p>Energy Gain: {Attacks[0].Atk4Gain}</p>
                            <p>Type: {Attacks[0].Atk4Type}</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        {/each}
        {:catch error}
        <h1>Game couldn't be loaded.</h1>
        {/await}
        {#if winnerModal}
        <div id="winner-modal-container" class="winner-modal">
            <div class="winner-modal-content">
                <span on:click="{closeWinnerModal}" class="winner-close-button" on:keypress="{closeWinnerModal}">×</span>
                {#await Session}
                   <h1>...</h1>
                {:then Session}
                <div class="winner-selection-modal">    
                    <div class="winner-modal-select">
                        <div class="winner-stats-modal-container">
                            <h1>Congratulations!</h1>
                            <p style="font-size: 1.4em; margin: 0px;">You Won</p>
                            <h2><span style="font-size: 1.8em;">{winnerPotConverted}</span> <img style="width: 25px; height: 25px;" src="/img/logo-green-on-transparent-2.png" alt="Canto"></h2>
                            <button class="claim-win-button" on:click={claimWin}>Claim your Canto</button>
                        </div>
                    </div>
                </div>
                {:catch error}
                   <h1>Failed to load</h1>
                {/await}

            </div>
        </div>
        {/if}
    </section>
<style>
    section {
        background-image: url("img/11.png");
        display: grid;
        justify-items: center;
        align-items: center;
        width: fit-content;
        width: 100%;
        height: 100vh;
        background-image: url("/img/11.png");
        background-repeat: no-repeat;
        background-size: cover;
        margin-top: -85px;
        z-index: 5;
    }

    section > div {
        display: grid;
        justify-items: flex-start;
        align-items: baseline;
        height: 100vh;
    }

    section > div > .top {
        background-image: url("img/20.png");
        background-size: cover;
        display: grid;
        justify-items: center;
        align-items: center;
        width: 25em;
        height: 15em;
        width: 45em;
        height: 15em;
        border-radius: 2.5em;
        margin-bottom: auto;
    }

    section > div > .top > .card-container-top {
        position: relative;
        width: 220px;
        height: 300px;
        width: 250px;
        height: 350px;
        background-color: #06093a;
        border-radius: 2em;
        margin-top: 0em;
    }

    section > div > .top > .card-container-top > p {
        font-size: 1.7em;
        font-weight: 700;
        text-align: center;
        text-shadow: 1px 1px 5px#06093a;
        margin: 0px;
        padding: 0px;
        z-index: 2;
        position: absolute;
        top: 0%;
        left: 44%;
    }

    .health-bar-top {
        width: 200px;
        height: 25px;
        background-color: rgb(2, 161, 161);
        border: 1px solid blueviolet;
        box-shadow: 1px 1px 5px 1px blueviolet;
        margin: 0px;
        padding: 0px;
        z-index: 3;
        position: absolute;
        top: 9%;
        left: 10%;
        /* margin-bottom: -0.5em; */
    }

    .health-bar-top > div {
        height: 25px;
        background-color: aqua;
        margin: 0px;
        padding: 0px;
        color: #06093a;
    }

    section > div > .top > .card-container-top > img {
        position: absolute;
        bottom: -2%;
        left: 6.5%;
        width: 220px;
        height: 300px;
    }

    section > div > .bottom {
        background-image: url("img/20.png");
        background-size: cover;
        display: grid;
        justify-items: center;
        align-items: center;
        width: 25em;
        height: 15em;
        width: 45em;
        height: 15em;
        border-radius: 2.5em;
        margin-top: auto;
    }

    section > div > .bottom > .card-container-bottom {
        position: relative;
        width: 220px;
        height: 300px;
        width: 250px;
        height: 350px;
        background-color: #06093a;
        border-radius: 2em;
        margin-top: -13em;
    }

    section > div > .bottom > .card-container-bottom > img {
        position: absolute;
        bottom: 0%;
        left: 6.5%;
        width: 220px;
        height: 300px;
        /* width: 300px;
        height: 420px; */
    }

    .attack-bottom {
        display: grid;
        justify-items: center;
        align-content: center;
        grid-template-columns: auto auto;
        margin: -120px 0px 0px 0px;
        z-index: 2;
    }

    .attack-bottom > div {
        display: grid;
        justify-items: center;
        align-content: center;
        grid-template-columns: auto;
        background-color: rgb(19, 19, 19);
        border: 1px solid blueviolet;
        box-shadow: 1px 1px 7px 1px blueviolet;
        font-size: 1.2em;
        padding: 0;
        width: 150px;
        /* height: 55px; */
        margin: -10px 0px 20px 0px;
        border-radius: 10px;
    }

    .attack-bottom > div:nth-child(1) {
        margin-right: 150px;
    }

    .attack-bottom > div:nth-child(2) {
        margin-left: 150px;
    }

    .attack-bottom > div:nth-child(3) {
        margin-right: 150px;
    }

    .attack-bottom > div:nth-child(4) {
        margin-left: 150px;
    }

    .attack-bottom > div > h2 {
        margin: 0px;
        padding: 0px;
    }

    .attack-bottom > div > div > p {
        margin: 0px;
        padding: 0px;
    }

    .attack-bottom > div:hover {
        background-color: #02a1a1;
        cursor: pointer;
        transition: all 0.3s ease-in-out;
    }

    section > div > .bottom > .card-container-bottom > .health {
        display: grid;
        justify-items: center;
        align-items: center;
        margin: 0px;
        padding: 0px;
        position: absolute;
        top: 5.5%;
        left: 11.5%;
    }

    section > div > .bottom > .card-container-bottom > p {
        font-size: 1.7em;
        font-weight: 700;
        text-align: center;
        text-shadow: 1px 1px 5px#06093a;
        margin: 0px;
        padding: 0px;
        z-index: 2;
        position: absolute;
        top: -1%;
        left: 44%;
    }

    .energy-container {
        position: absolute;
        bottom: -80px;
        left: 23%;
        display: grid;
        justify-items: center;
        align-content: center;
        grid-template-columns: auto;
        background-color: rgb(19, 19, 19);
        border: 1px solid rgb(156, 223, 94);
        box-shadow: 1px 1px 7px 1px blueviolet;
        font-size: 1.2em;
        padding: 0;
        width: 150px;
    }

    .energy-container > h2 {
        margin: 0px;
        padding: 0px;
    }

    .energy-container > p {
        margin: 0px;
        padding: 0px;
    }

    section > div > .bottom > .card-container-bottom > .health > .health-bar-bottom {
        width: 200px;
        height: 25px;
        background-color: rgb(2, 161, 161);
        border: 1px solid blueviolet;
        box-shadow: 1px 1px 5px 1px blueviolet;
        margin: 0px;
        padding: 0px;
        z-index: 2;
        margin-bottom: -2.5em;
    }

    section > div > .bottom > .card-container-bottom > .health > .health-bar-bottom > div {
        height: 25px;
        background-color: aqua;
        margin: 0px;
        padding: 0px;
        color: #06093a;
    }

    #effect {
        position: absolute;
        background-image: url("/img/anim/LightCast_96.gif");
        /* background-image: url("/img/anim/LightCast_96.gif"); */
        background-size: cover;
        background-repeat: no-repeat;
        background-size: 100%;
        top: 25%;
        left: 20%;
        width: 60%;
        height: 50%;
        z-index: 2;
        /* animation: effect 1.5s linear 0s infinite; */
    }

    /* section > div > .bottom > .card-container-bottom > img:hover #effect {
        animation: effect 0.1s linear 0s infinite alternate;
    } */

    @keyframes effect {
        from {background-image: url("/img/anim/empty.png")}
        to {background-image: url("/img/anim/LightCast_96.gif")}
    }


    .claim-win-button {
        width: 80%;
        font-size: 1.5em;
        max-height: 50px;
    }

    .claim-win-button:hover {
        cursor: pointer;
        background-color: rgb(248, 248, 21);
        transition: all 0.3s linear;
    }


    /************** Winner Modal ********************************************************************/

    .winner-modal {
        display: block; 
        position: fixed; 
        z-index: 4; 
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
      .winner-modal-content {
        background-color: #000000;
        margin: auto;
        padding: 10px 15px;
        border: 1px solid #888;
        width: 80%;
        border-radius: 20px;
        margin-top: 5em;
        height: 40em;
      }

      /* The Close Button */
      .winner-close-button {
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

      .winner-close-button:hover,
      .winner-close-button:focus {
        background-color: rgb(223, 0, 0);
        cursor: pointer;
      }

      .winner-selection-modal {
        display: grid;
        justify-items: center;
        align-items: center;
        height: 500px;
        width: 100%;
        grid-template-columns: auto;
        margin-top: 5em;
      }

      .winner-selection-modal > .winner-modal-select {
        display: grid;
        justify-items: center;
        align-items: center;
        height: 200px;
        grid-template-columns: auto auto;
      }

      .winner-selection-modal > .winner-modal-select > .winner-stats-modal-container {
        display: grid;
        justify-items: center;
        align-items: center;
        width: 150%;
        background: #041225;
        margin: 0px 0px 0px -18px;
        border-radius: 20px;
        transition: all 0.2s ease;
        z-index: 5;
      }
      

/************** Fighter Modal ********************************************************************/


</style>