pragma solidity >=0.4.0 <0.6.0;

contract aaT{


	//attributes of actionaaSetResult
	bool _isaaSetResultDone;
	uint _aaSetResultTime;

	address _aaAddress;
	uint _max;

	function aaT(){
		_max = now*1000;
	}

	function getAddress() public returns (address a){
		return _aaAddress;
	}

	function aaSetResultDone(){
		_aaSetResultTime = now;
		_isaaSetResultDone = true;
	}

	function aaSetResultTime() public returns (uint result){
	    if(_isaaSetResultDone){
	        return _aaSetResultTime;
	    }
	    return _max;
	}

}
