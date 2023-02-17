<script lang="ts">
  import { browser } from '$app/environment';
  import { defaultEvmStores as evm, web3, selectedAccount, connected, chainId, chainData } from 'svelte-web3';
  import { onMount } from 'svelte'
  import { fade } from 'svelte/transition'
  import nftABI from '../contract/NFTabi.json'
  import gameABI from '../contract/GameABI.json'

  let nftAddress :string = "0x29B7e92bc53B1a881F33A0465444f96672AB4284"
  let gameAddress :string = "0x871b5812399ebeD14a1c8655CE784d2E7667d009"

  let animate = false

  onMount(() => {
    animate = true
  })

  async function test() {
      const contract = new $web3.eth.Contract(gameABI, gameAddress)
      let receiptInformation 

      const allowance = await contract.methods.allowance($selectedAccount).call({ from: $selectedAccount })
      // const test = await contract.methods.approve(CONTRACT, mintPayment).send({ from: $selectedAccount, gasPrice : 35000000000, gasLimit: 200000 })

      // receiptInformation = await $web3.eth.getTransactionReceipt(approve.transactionHash)
      // let status = receipt.status
  }

</script>

<svelte:head>
	<title>Canto Legends</title>
	<meta name="description" content="Canto Legends is" />
</svelte:head>

    <section class="section-1">

        <div class="front-page-content">
            <h1>Canto Legends</h1>
            <p>A PVP Round Based NFT Game Fully Operating On The Canto Blockchain</p>
        </div>

        <div class="cta-page-content">
          <a href="/#"><button>Buy NFT</button></a>
          <!-- <button>Buy CLT</button> -->
          <a href="/play"><button>Play</button></a>
        </div>
    
    </section>

    <section class="section-2-5">
      <p style="background-color: red; text-align: center;">!BE AWARE THAT THIS SITE IS CURRENTLY UNDER DEVELOPMENT AND THAT THIS IS JUST A BETA VERSION. 
         ALL THE DESIGN CHOICES CAN CHANGE AND THERE WILL BE MUCH MORE CONTENT AVAILABLE SOON!</p>
      <div>
        <p>Canto Legends is a fully on-chain and round based PVP game. The base principle is simple, players can participate in PVP 
           battles against other players with an NFT that you can buy from our own marketplace directly. Players can put up Canto 
           tokens at stake when opening a game session, the player who joins needs to pu the same amount at stake as the first player.
           The winner of the battle gets all the tokens. There can only be two players battling in a game session. There can be an indefinite
           number of game sessions opened. A player can win by decreasing the HP of the enemy player's NFT to 0 or by timeout. A timeout is activated
           when a player hasn't called his turn for more than 2 minutes in block time.
        </p>
      </div>
    </section>

    <section class="section-2">
      <div>
        <h2>Enter The Arena</h2>
        <p>Host a battle session or join sessions hosted by players from all over the world</p>

        <img src="/img/arena2.jpg" alt="Arena">

      </div>
    </section>

    <section class="section-3">
      	<div>
          <h2>Choose Your Fighter</h2>
          <p>Choose between different types of fighter NFTs ranging from Fire, Water, Earth, Air, Ice, Thunder and Void with different attack and defense values
             and various types of attacks, all stored on IPFs</p>
        </div>
        <div class="cards">
          <img src="/img/cards/card2.png" alt="Card2">
          <img src="/img/cards/card1.png" alt="Card1">
        </div>
        <p>More Coming Soon ...</p>
    </section>

    <section class="section-4">
      <div>
        <h2>Features</h2>
        <p>Main features shortly explained</p>

        <div class="feat-container">
          <div>
            <h3>Canto as the Currency</h3>
            <p>All transactions will be done with the Canto native token, be it buying NFTs or putting tokens at stake</p>
          </div>
  
          <div>
            <h3>Fully On-Chain</h3>
            <p>The whole game runs on-chain in its entirety, so making it secure and available for everyone around the world</p>
          </div>
  
          <div>
            <h3>Fair and Fun</h3>
            <p>All NFTs have their strengths and weaknesses, it's up to you to play them the best way</p>
          </div>
  
          <div>
            <h3>Immutable</h3>
            <p>The game contract and all NFTs are stored on-chain and on IPFs, giving you full control over your game assets</p>
          </div>
        </div>
        
      </div>
      
    </section>


<style>

  h2 {
    text-shadow: 2px 2px 10px #f7d621;
    font-size: 2.8em;
    /* text-align: center; */
    max-width: 700px;
    color: #00ff01;
    color: #f7d621;
    font-weight: 500;
    margin: 25px 0px;
    padding: 0px 10px;
  }

  p {
    margin: 25px 0px;
    font-size: 1.8em;
    color: #00ff01;
    color: #ffffff;
    font-weight: 500;
    margin: 25px 0px;
    max-width: 1000px;
    padding: 0px 10px;
  }

    /* @keyframes image {
      0% {
        background-image: url("/img/bg-anim/bg6.jpg");
      }
      10% {
        background-image: url("/img/bg-anim/1.jpg");
      }
      20% {
        background-image: url("/img/bg-anim/2.jpg");
      }
      30% {
        background-image: url("/img/bg-anim/3.jpg");
      }
      40% {
        background-image: url("/img/bg-anim/4.jpg");
      }
      50% {
        background-image: url("/img/bg-anim/5.jpg");
      }
      60% {
        background-image: url("/img/bg-anim/6.jpg");
      }
      70% {
        background-image: url("/img/bg-anim/7.jpg");
      }
      80% {
        background-image: url("/img/bg-anim/8.jpg");
      }
      90% {
        background-image: url("/img/bg-anim/9.jpg");
      }
      100% {
        background-image: url("/img/bg-anim/bg7.jpg");
      }
    } */

    .section-1 {
        display: grid;
        justify-items: center;
        align-items: center;
        width: fit-content;
        width: 100%;
        height: 115vh;
        background-image: url("/img/11.png");
        background-repeat: no-repeat;
        background-size: cover;
        opacity: 1;
        margin-top: -12em;
        padding: 0px 0px 0px 0px;
        background-color: #baffe3;
        background-color: #ffffff;
        background-color: #041225;
        /* animation: image 1.5s linear 0s 1 alternate; */
    }

    .section-1 > .front-page-content {
        display: flex;
        justify-items: center;
        align-items: center;
        flex-flow: column;
        width: 100%;
        margin-top: 10em;
        /* padding: 0em 0em 0em 5em; */
    }

    .section-1 > .front-page-content > h1 {
        font-family: Funkystar;
        text-shadow: 3px 3px 25px #f904f9;
        text-shadow: 3px 3px 25px #f7d621;
        font-size: 9em;
        text-align: center;
        margin: 0;
        padding: 0;
        color: #f904f9;
        color: #f7d621;
        font-weight: 700;
        /* max-width: 50%; */
        -webkit-text-stroke: 2px #250abb;
        text-stroke: 2px #250abb;
    }

    .section-1 > .front-page-content > p {
        text-shadow: 2px 2px 50px #f904f9;
        /* background-color: rgba(0, 0, 0, 0.5); */
        font-size: 2.8em;
        text-align: center;
        max-width: 700px;
        color: #00ff01;
        color: #ffffff;
        font-weight: 500;
        margin: 0;
        /* -webkit-text-stroke: 0.1px #250abb;
        text-stroke: 0.1px #250abb; */
    }

    .section-1 > .cta-page-content {
        display: grid;
        justify-items: center;
        align-items: center;
        grid-template-columns: auto auto;
        margin-top: -14em;
        /* width: 100%; */
    }

    .section-1 > .cta-page-content > a > button {
      /* box-shadow: 3px 3px 15px 1px #f904f9; */
      background-color: rgba(0, 255, 0, 0.777);
      width: 4.5em;
      height: 2em;
      font-size: 1.5em;
      margin: 5px 10px 15px 10px;
      padding: 0.2em 0.5em 0.2em 0.5em;
      background: #f7d621;
      color: #1c050f;
      color: #250abb;
      font-weight: bold;
      text-transform: uppercase;
      text-align: center;
      font-size: 2.5em;
      border-right: 7px solid #1c050f;
      border-bottom: 7px solid #1c050f;
    }

    .section-1 > .cta-page-content > a > button:nth-child(3) {
      grid-column: 3/1;
    }

    .section-1 > .cta-page-content > a > button:hover {
      transform: translateY(-5px);
      background: #ffffff;
      cursor: pointer;
      color: #1c050f;
      transition: all 0.3s;
    }

    .section-2-5 {
      margin: 50px 0px 150px 0px;
    }

    .section-2 > div > img {
      width: 100%;
      height: auto;
    }

    .section-3 {
      background-color: #041225;
      position: relative;
      isolation: isolate;
      width: 100%;
      height: 55em;
      margin-top: 3em;
      padding: 0em;
      display: grid;
      align-items: center;
      justify-content: center;
    }

    .section-3::after {
      content: "";
      background-image: linear-gradient(45deg, #232989, #0d1f4f, #051225);
      position: absolute;
      inset: 0;
      transform: skewY(-5deg);
      z-index: -1;
    }

    .section-3 > .cards {
      margin: 0px;
      display: grid;
      justify-items: center;
      align-items: center;
      grid-template-columns: auto auto;
      margin-top: -60px;
    }

    .section-3 > .cards > img {
      max-width: 380px;
      width: 100%;
      height: auto;
    }

    .section-3 > .cards > img:nth-child(1) {
      transform: rotate(-5deg);
      margin-right: -200px;
    }

    .section-3 > .cards > img:nth-child(2) {
      transform: rotate(5deg);
      margin-left: -200px;
    }

    /* .section-3 > div > h2 {
      font-size: 2.5em;
      color: #ffffff;
      font-weight: 700;
      -webkit-text-stroke: 1px navy;
      text-stroke: 1px navy;
      margin: 0;
    } */

    /* .section-3 > div > p {
      font-size: 1.5em;
      color: #ffffff;
      font-weight: 700;
      -webkit-text-stroke: 0.7px navy;
      text-stroke: 0.7px navy;
    } */

    .section-4 {
      background-color: #041225;
      width: 100%;
      height: 55em;
      margin-top: 3em;
      padding: 0em;
      display: grid;
      align-items: center;
      justify-content: center;
    }

    .feat-container {
      display: grid;
      justify-items: center;
      align-items: center;
      grid-template-columns: auto auto;
      margin: 100px 0px 15px 0px;
    }

    .feat-container > div {
      display: grid;
      justify-items: center;
      /* align-items: center; */
      background-color: rgba(0, 255, 0, 0.777);
      width: auto;
      height: 100px;
      margin: 25px 0px 15px 0px;
      background: #f7d621;
      color: #1c050f;
      font-weight: bold;
      text-transform: uppercase;
      max-width: 500px;
      width: 90%;
      height: 80%;
      padding: 5px;
    }

    .feat-container > div > h3 {
      color: #1c050f;
      font-weight: bold;
      text-transform: uppercase;
      text-align: center;
      font-size: 2em;
      margin: 0px 0px 5px 0px;
    }

    .feat-container > div > p {
      color: #1c050f;
      font-weight: bold;
      text-transform: uppercase;
      text-align: center;
      font-size: 1.2em;
      margin: 0px;
      max-width: 500px;
    }

    @media (min-width: 531px) and (max-width: 1000px) {

      .feat-container {
        grid-template-columns: auto;
      }
    }

    @media (min-width: 381px) and (max-width: 530px) {
      .section-1 {
        margin-top: -19em;
        /* animation: image 1.5s linear 0s 1 alternate; */
      }

      .section-1 > .front-page-content > h1 {
          font-size: 5em;
      }

      .section-1 > .front-page-content > p {
          font-size: 1.8em;
      }

      .feat-container {
        grid-template-columns: auto;
      }

      
      .feat-container > div {
        margin: 15px 0px 15px 0px;
        padding: 5px 5px;
      }
    }

    @media (min-width: 0px) and (max-width: 380px) {
      .section-1 {
        margin-top: -19em;
        /* animation: image 1.5s linear 0s 1 alternate; */
      }

      .section-1 > .front-page-content > h1 {
          font-size: 5em;
      }

      .section-1 > .front-page-content > p {
          font-size: 1.8em;
      }

      .feat-container {
        grid-template-columns: auto;
      }

      
      .feat-container > div {
        width: 240px;
        margin: 15px 0px 15px 0px;
        padding: 5px 5px;
      }

      .section-1 > .cta-page-content {
        grid-template-columns: auto;
        /* width: 100%; */
      }
    }

</style>


