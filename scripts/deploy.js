// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  // const currentTimestampInSeconds = Math.round(Date.now() / 1000);
  // const ONE_YEAR_IN_SECS = 365 * 24 * 60 * 60;
  // const unlockTime = currentTimestampInSeconds + ONE_YEAR_IN_SECS;

  // const lockedAmount = hre.ethers.utils.parseEther("1");

  // const Lock = await hre.ethers.getContractFactory("Lock");
  // const lock = await Lock.deploy(unlockTime, { value: lockedAmount });

  // await lock.deployed();

  // const betterSwapFactory = await hre.ethers.getContractFactory("betterSwapFactory");
  // const bs=await (await betterSwapFactory.deploy()).deployed();
  // const USD = await hre.ethers.getContractFactory("USD");
  // const usd =await (await USD.deploy()).deployed();
  // console.log("BetterSwap Factory Address", bs.address, bs.admin());

  var acc1,acc2 = hre.getSigners();
  console.log(acc1,acc2);
  // console.log("USD address ", usd.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
