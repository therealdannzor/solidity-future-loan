// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

interface ICalculateLoan {
	function calculateInterestFrom(uint principal, uint loanStartDate, uint loanEnd)
	external view returns (uint);

	function getRate() external view returns (uint);

	function adjustRate(uint newRate) external;
}

contract Storage {

	struct Borrower {
		uint amount;   // amount borrowed
		uint fromDate; // borrowing date
	}
	mapping(address => Borrower) balance; // record of all borrowers
	address calculatorAddr;				  // address to library contract (CalculateLoan)
	uint outstandingBalance;			  // amount of credit given

	function setCalculatorAddr(address _addr) public payable {
		calculatorAddr = _addr;
	}

	function setRate(uint newRate) public {
		return ICalculateLoan(calculatorAddr).adjustRate(newRate);
	}

	function getRate() public view returns (uint) {
		return ICalculateLoan(calculatorAddr).getRate();
	}

	function issueLoan(address borrower, uint amount) public {
		uint currDate = now;
		Borrower memory entry = Borrower(amount, currDate);
		balance[borrower] = entry;
		// keep track of all our loans
		outstandingBalance += amount;
	}

	function getOutstanding(address borrower) public view returns (uint) {
		uint principal = balance[borrower].amount;
		uint fromDate = balance[borrower].fromDate;
		return ICalculateLoan(calculatorAddr).calculateInterestFrom(principal, fromDate, now);
	}
}
