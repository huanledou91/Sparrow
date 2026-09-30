pragma solidity >=0.4.0 <0.6.0;

contract platformT{

	bytes32 name;
	uint public amount;

	//attributes of actionStartBidding
	bool _isStartBiddingDone;
	uint _StartBiddingTime;

	address _platformAddress;
	uint _max;

	function platformT(){
		_max = now*1000;
	}

	function getAddress() public returns (address a){
		return _platformAddress;
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

	function StartBiddingDone(){
		_StartBiddingTime = now;
		_isStartBiddingDone = true;
	}

	function StartBiddingTime() public returns (uint result){
	    if(_isStartBiddingDone){
	        return _StartBiddingTime;
	    }
	    return _max;
	}

}
