const path = require("path");
const HDWalletProvider = require("truffle-hdwallet-provider");
const mnemonic = "allow age token fantasy engine useless bench hawk ticket ginger gasp jungle";
const infuraAPIkey = "cbc36b9572214781b09811d7339d58d9";

module.exports = {
  contracts_build_directory: path.join(__dirname, "app/src/contracts"),
  networks: {
    development: {
      host: 'localhost',
      port: 8545,
      network_id: '*'
    },

    rinkeby: {
      provider: function() { 
       return new HDWalletProvider(mnemonic, "https://rinkeby.infura.io/v3/"+infuraAPIkey);
      },
      network_id: '4',
      gas: 5000000,
      gasPrice: 10000000000,
    }
  }
};
