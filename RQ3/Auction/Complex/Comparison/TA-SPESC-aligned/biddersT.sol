pragma solidity >=0.4.0 <0.6.0;

contract biddersT{

	bytes32 name;

	struct bidderstype{
		address _biddersaddress;

		//attributes of actionpayBid
		bool _ispayBidDone;
		uint _payBidTime;

		//attributes of actionpayDefault
		bool _ispayDefaultDone;
		uint _payDefaultTime;

	}

	uint _max;//time max
	uint _payBidDoneNum;
	uint[] _payBidTime;

	uint _payDefaultDoneNum;
	uint[] _payDefaultTime;

	bidderstype _Empty;//used to initialize
	bidderstype[] _biddersEntity;
	mapping(address=>uint) _userlist;

	function biddersT(){
		_payBidDoneNum = 0;

		_payDefaultDoneNum = 0;

		_biddersEntity.push(_Empty);
		_max = now*1000;
	}

	function getname() public returns(bytes32 _result){
		return name;
	}

	function setname( bytes32 a) public {
		name = a;
	}

	function payBidDone(address a) public {
	    uint num = _userlist[a];
		_biddersEntity[num]._payBidTime = now;
		_biddersEntity[num]._ispayBidDone = true;
		_payBidTime.push(_biddersEntity[num]._payBidTime);
		_payBidDoneNum ++;
	}

	function payBidTime(address a) public returns (uint result){
	    uint num = _userlist[a];
	    if(_biddersEntity[num]._ispayBidDone){
	        return _biddersEntity[num]._payBidTime;
	    }
	    return _max;
	}

	function payDefaultDone(address a) public {
	    uint num = _userlist[a];
		_biddersEntity[num]._payDefaultTime = now;
		_biddersEntity[num]._ispayDefaultDone = true;
		_payDefaultTime.push(_biddersEntity[num]._payDefaultTime);
		_payDefaultDoneNum ++;
	}

	function payDefaultTime(address a) public returns (uint result){
	    uint num = _userlist[a];
	    if(_biddersEntity[num]._ispayDefaultDone){
	        return _biddersEntity[num]._payDefaultTime;
	    }
	    return _max;
	}

}
