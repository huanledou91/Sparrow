pragma solidity >=0.4.0 <0.6.0;

contract LesseeT{

	bytes32 name;
	uint public amount;

	//attributes of actioncontinue
	bool _iscontinueDone;
	uint _continueTime;

	address _LesseeAddress;
	uint _max;

	function LesseeT(){
		_max = now*1000;
	}

	function getAddress() public returns (address a){
		return _LesseeAddress;
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

	function continueDone(){
		_continueTime = now;
		_iscontinueDone = true;
	}

	function continueTime() public returns (uint result){
	    if(_iscontinueDone){
	        return _continueTime;
	    }
	    return _max;
	}

}
