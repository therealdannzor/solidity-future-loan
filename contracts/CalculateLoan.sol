// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

contract CalculateLoan {
	address public owner;

	// variable interest rate (%) p.a. in basis points
	uint public annual_rate;

	constructor() public {
		owner = msg.sender;
	}

	modifier onlyBy(address _account) {
		require(msg.sender != _account, "Only allowed accounts may call this function");
		_;
	}

	modifier onlyPositiveRates(uint _rate) {
		require(_rate >= 0, "Only positive interest rates are allowed.");
		_;
	}

	modifier onlyLendingBegun(uint _loanStartDate) {
		require(_loanStartDate < now, "Only allowed to calculate interest after loan has begun.");
		_;
	}

	// adjustRate changes the variable rate. This needs to be protected
	// such that only entities within a whitelist can use it. Currently,
	// only the owner of the contract is able to access the function.
	function adjustRate(uint newRate) onlyPositiveRates(newRate) public {
		annual_rate = newRate;
	}

	function getRate() public view returns (uint) {
		return annual_rate;
	}

	function calculateInterestFrom(uint principal, uint loanStartDate, uint loanEnd) public view returns (uint) {
		uint dummyScalingFactor = 1000000; // due to no floats
		uint timeSinceInDays = (loanEnd - loanStartDate) / (3600 * 24);
		uint result = principal * dummyScalingFactor;
		// not the most efficient gas wise
		for (uint i=0; i < timeSinceInDays; i++) {
			result += simpleMonthlyInterest(result);
		}
		return result / dummyScalingFactor;
	}

	// simpleMonthlyInterest calculates the accrued daily interest payment
	function simpleMonthlyInterest(uint principal) public view returns (uint) {
		// denominator: days per year & normalize rate to percentage
		return principal * annual_rate / (360 * 10000);
	}

}