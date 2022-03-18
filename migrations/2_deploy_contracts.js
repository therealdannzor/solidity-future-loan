var CI = artifacts.require("./contracts/CalculateLoan.sol");

module.exports = function(deployer) {
	deployer.deploy(CI);
};
