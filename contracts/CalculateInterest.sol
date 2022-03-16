pragma solidity ^0.5.0;

contract CalculateInterest {
	address public owner;

	constructor() public {
		owner = msg.sender;
	}

	function getOne() public pure returns (uint) {
		return 1;
	}
}
