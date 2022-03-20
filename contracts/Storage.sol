// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

interface ICalculateLoan {
	function calculateNewDebt(uint principal, uint loanStartDate, uint loanEnd)
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
		balance[borrower] = Borrower(amount, currDate);
		// keep track of all our loans
		outstandingBalance += amount;
	}

	// This function can be used by a third party API for a periodic update of debts.
	// It is not optimal as of now to have to target each address individually but it
	// demonstrates the principle.
	function updateBorrower(address borrower) public returns (uint) {
		Borrower storage b = balance[borrower];
		uint debt = b.amount;
		uint fromDate = b.fromDate;
		uint actualDate = block.timestamp;
		uint newDebt = ICalculateLoan(calculatorAddr).calculateNewDebt(debt, fromDate, actualDate);
		if (newDebt > debt) {
			balance[borrower].amount = newDebt;
		}
	}



	function getDebtFor(address borrower) public view returns (uint) {
		return balance[borrower].amount;
	}

	function totalCreditGiven() public view returns (uint) {
		return outstandingBalance;
	}
}
