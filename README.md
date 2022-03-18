# Calculate Compound Interests in Solidity

### Context
Calculate the loan with a compounded interest rate through two simple contracts that interact with each other.

The contract `CalculateInterest.sol` controls the interest rate and does that calculations while the other contract `Storage.sol` keeps track of the loans and total outstanding debt.

### MVP Flow

Deploy `CalculateInterest.sol` and obtain the contract address. Now deploy `Storage.sol` and call `setCalculatorAddr(address _addr)` to connect it to the first contract. It is now possible to issue loans with `issueLoan(address borrower, uint amount)`. Make sure the data is periodically updated.

<img src="assets/calculateLoanContract">

### Dependencies

Nothing spicy, only the ones needed for a basic project.
