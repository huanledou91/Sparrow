pragma solidity >=0.4.0 <0.6.0;

contract LessorT{

	bytes32 name;
	uint public amount;

	address _LessorAddress;

	function getAddress() public returns (address a){
		return _LessorAddress;
	}

	function getname() public returns(bytes32 _result){
		return name;
	}

	function setname( bytes32 a) public {
		name = a;
	}

	function getamount() public returns(uint _result){
		return amount;
	}

	function setamount( uint a) public {
		amount = a;
	}

}
