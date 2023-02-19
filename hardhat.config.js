
const { task } = require('hardhat/config') ;

require("@nomiclabs/hardhat-ethers")
require("@nomiclabs/hardhat-waffle");
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
 const accounts = await hre.ethers.getSigners();

 for (const account of accounts) {
   console.log(account.address);
 }
});
module.exports = {
  solidity:{
    version: "0.8.9",
  settings: {
    optimizer: {
      enabled: true,
      runs: 200,
    },
  }
}
};
