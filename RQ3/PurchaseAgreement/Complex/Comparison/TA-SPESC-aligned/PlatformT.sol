pragma solidity >=0.4.0 <0.6.0;

contract PlatformT{

	uint public amount;

	//attributes of actionconfirmArrive
	bool _isconfirmArriveDone;
	uint _confirmArriveTime;

	address _PlatformAddress;
	uint _max;

	function PlatformT(){
		_max = now*1000;
	}

	function getAddress() public returns (address a){
		return _PlatformAddress;
	}

	function getamount() public returns(uint _result){
		return amount;
	}

	function setamount( uint a) public {
		amount = a;
	}

	function confirmArriveDone(){
		_confirmArriveTime = now;
		_isconfirmArriveDone = true;
	}

	function confirmArriveTime() public returns (uint result){
	    if(_isconfirmArriveDone){
	        return _confirmArriveTime;
	    }
	    return _max;
	}

}
