pragma solidity >=0.4.0 <0.6.0;

contract LessorT{

	bytes32 name;
	uint public amount;

	//attributes of actiongetAA1
	bool _isgetAA1Done;
	uint _getAA1Time;

	address _LessorAddress;
	uint _max;

	function LessorT(){
		_max = now*1000;
	}

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

	function getAA1Done(){
		_getAA1Time = now;
		_isgetAA1Done = true;
	}

	function getAA1Time() public returns (uint result){
	    if(_isgetAA1Done){
	        return _getAA1Time;
	    }
	    return _max;
	}

}
