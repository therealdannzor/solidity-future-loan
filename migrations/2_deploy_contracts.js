var CI = artifacts.require("./contracts/CalculateInterest.sol");

module.exports = function(deployer) {
	deployer.deploy(CI);
};
