pragma solidity >=0.4.0 <0.6.0;

contract auctioneerT{

	uint public amount;

	address _auctioneerAddress;

	function getAddress() public returns (address a){
		return _auctioneerAddress;
	}

	function getamount() public returns(uint _result){
		return amount;
	}

	function setamount( uint a) public {
		amount = a;
	}

}
