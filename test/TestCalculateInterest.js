const CI = artifacts.require("./CalculateInterest.sol");

contract('CI', async (account) => 
{
	it("should initially return 1", async() => {
		let contract = await CI.deployed();
		let expected = 1;
		let actual = await contract.getOne();
		assert.equal(expected, actual, "Should be ");
	});

});
