pragma solidity >=0.4.0 <0.6.0;

contract SellerT{

	bytes32 name;
	uint public amount;

	//attributes of actiondelivery
	bool _isdeliveryDone;
	uint _deliveryTime;

	address _SellerAddress;
	uint _max;

	function SellerT(){
		_max = now*1000;
	}

	function getAddress() public returns (address a){
		return _SellerAddress;
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

	function deliveryDone(){
		_deliveryTime = now;
		_isdeliveryDone = true;
	}

	function deliveryTime() public returns (uint result){
	    if(_isdeliveryDone){
	        return _deliveryTime;
	    }
	    return _max;
	}

}
