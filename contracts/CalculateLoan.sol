// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

contract CalculateLoan {
	address public owner;
	address public contractAddr;

	// variable interest rate (%) p.a. in basis points
	uint public annual_rate;

	constructor() public {
		owner = msg.sender;
		contractAddr = address(this);
	}

	function getAddress() public view returns (address) {
		return contractAddr;
	}

	// can be generalized for additional parties if needed
	modifier onlyByOwner() {
		require(msg.sender == owner, "Only allowed accounts may call this function");
		_;
	}

	modifier onlyPositiveRates(uint _rate) {
		require(_rate >= 0, "Only positive interest rates are allowed.");
		_;
	}

	modifier onlyLendingBegun(uint _loanStartDate) {
		require(_loanStartDate < block.timestamp, "Only allowed to calculate interest after loan has begun.");
		_;
	}

	// adjustRate changes the variable rate. This needs to be protected
	// such that only entities within a whitelist can use it. Currently,
	// only the owner of the contract is able to access the function.
	function adjustRate(uint newRate) onlyByOwner() onlyPositiveRates(newRate) external {
		annual_rate = newRate;
	}

	function getRate() external view returns (uint) {
		return annual_rate;
	}

	function calculateInterestFrom(uint principal, uint loanStartDate, uint loanEnd) external view returns (uint) {
		uint dummyScalingFactor = 1000000; // due to no floats
		uint timeSinceInDays = (loanEnd - loanStartDate) / (3600 * 24);
		uint result = principal * dummyScalingFactor;
		// not the most efficient gas wise
		for (uint i=0; i < timeSinceInDays; i++) {
			result += simpleDailyInterest(result);
		}
		return result / dummyScalingFactor;
	}

	// simpleDailyInterest calculates the accrued daily interest payment
	function simpleDailyInterest(uint principal) private view returns (uint) {
		// denominator: days per year & normalize rate to percentage
		return principal * annual_rate / (360 * 10000);
	}

}
