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

	function getRate() public view returns (uint) {
		return ICalculateLoan(calculatorAddr).getRate();
	}

	function issueLoan(address borrower, uint amount) public {
		uint currDate = block.timestamp;
		Borrower memory entry = Borrower(amount, currDate);
		balance[borrower] = entry;
		// keep track of all our loans
		outstandingBalance += amount;
	}

	// This function can be used by a third party API for a periodic update of debts.
	// It is not optimal as of now to have to target each address individually but it
	// demonstrates the principle.
	function updateBorrower(address borrower) public returns (uint) {
		uint debt = balance[borrower].amount;
		uint fromDate = balance[borrower].fromDate;
		uint actualDate = block.timestamp;
		uint newDebt = ICalculateLoan(calculatorAddr).calculateInterestFrom(debt, fromDate, actualDate);
		if (newDebt > debt) {
			balance[borrower].amount = newDebt;
			return newDebt;
		}

		return 0;
	}



	function getDebtFor(address borrower) public view returns (uint) {
		return balance[borrower].amount;
	}

	function totalCreditGiven() public view returns (uint) {
		return outstandingBalance;
	}
}
