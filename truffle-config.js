const HDWalletProvider = require('@truffle/hdwallet-provider');
const path = require("path");

require("dotenv").config();

const private_keys = process.env.PRIVATE_KEYS;
const infura = process.env.INFURA_URL;

module.exports = {
  contracts_build_directory: path.join(__dirname, "client/src/contracts"),
  networks: {
    development: {
     host: "127.0.0.1",     // Localhost (default: none)
     port: 7545,            // Standard Ethereum port (default: none)
     network_id: "5777",       // Any network (default: none)
    },
    rinkeby: {
      provider: () => new HDWalletProvider({
        privateKeys: process.env.PRIVATE_KEYS,
        providerOrUrl: "https://rinkeby.infura.io/v3/" + process.env.INFURA_URL,
        numberOfAddresses: 2
      }),
      network_id: 4,
      gas: 5500000,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true
    }
  },
  compilers: {
    solc: {
      version: "0.8.0",  
      settings: {          
       optimizer: {
         enabled: false,
         runs: 200
       }
      //  evmVersion: "byzantium"
      }
    }
  }
};
