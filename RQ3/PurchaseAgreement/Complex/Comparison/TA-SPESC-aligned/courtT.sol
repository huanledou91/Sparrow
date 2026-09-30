pragma solidity >=0.4.0 <0.6.0;

contract courtT{


	//attributes of actioncourtSetResult
	bool _iscourtSetResultDone;
	uint _courtSetResultTime;

	address _courtAddress;
	uint _max;

	function courtT(){
		_max = now*1000;
	}

	function getAddress() public returns (address a){
		return _courtAddress;
	}

	function courtSetResultDone(){
		_courtSetResultTime = now;
		_iscourtSetResultDone = true;
	}

	function courtSetResultTime() public returns (uint result){
	    if(_iscourtSetResultDone){
	        return _courtSetResultTime;
	    }
	    return _max;
	}

}
