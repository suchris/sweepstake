const SweepstakeFactory = artifacts.require("SweepstakeFactory");

module.exports = function(deployer) {
  deployer.deploy(SweepstakeFactory);
};
