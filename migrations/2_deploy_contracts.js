const Sweepstake = artifacts.require("Sweepstake");

module.exports = function(deployer) {
  deployer.deploy(Sweepstake);
};
