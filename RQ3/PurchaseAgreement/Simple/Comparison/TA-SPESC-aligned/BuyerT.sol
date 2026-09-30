pragma solidity >=0.4.0 <0.6.0;

contract BuyerT{

	bytes32 name;
	uint public amount;

	//attributes of actionconfirmBuy
	bool _isconfirmBuyDone;
	uint _confirmBuyTime;

	//attributes of actionconfirmGet
	bool _isconfirmGetDone;
	uint _confirmGetTime;

	address _BuyerAddress;
	uint _max;

	function BuyerT(){
		_max = now*1000;
	}

	function getAddress() public returns (address a){
		return _BuyerAddress;
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

	function confirmBuyDone(){
		_confirmBuyTime = now;
		_isconfirmBuyDone = true;
	}

	function confirmBuyTime() public returns (uint result){
	    if(_isconfirmBuyDone){
	        return _confirmBuyTime;
	    }
	    return _max;
	}

	function confirmGetDone(){
		_confirmGetTime = now;
		_isconfirmGetDone = true;
	}

	function confirmGetTime() public returns (uint result){
	    if(_isconfirmGetDone){
	        return _confirmGetTime;
	    }
	    return _max;
	}

}
