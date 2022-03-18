const CL = artifacts.require("./CalculateLoan.sol");

contract('CL', async (account) => 
{
	it("should return the correct rate", async() => {
		let contract = await CL.deployed();
		await contract.adjustRate(500);

		let expected_rate = 500;
		let actual_rate = await contract.getRate();
		assert.equal(actual_rate, expected_rate);

		let loanBeginsAt = 1647593304;
		let loanEnd = loanBeginsAt + (3600 * 24 * 180); // half a year later
		let principal = 10000;
		let expected = 10253;

		let actual = await contract.calculateInterestFrom(principal, loanBeginsAt, loanEnd).then(b => { return b.toNumber()});
		assert.equal(actual, expected, "should be the same");
	});

});
