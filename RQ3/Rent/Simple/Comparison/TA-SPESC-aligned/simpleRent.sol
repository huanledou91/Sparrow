pragma solidity >=0.4.0 <0.6.0;

import "./LessorT.sol";
import "./LesseeT.sol";
contract simpleRent {

	LessorT Lessor;
	LesseeT Lessee;

	contractInfo info1;
	uint continueDays;
	bool continueFlag;

	struct contractInfo{
		uint payDate;
		uint signTime;
		uint rent;
		uint continueRent;
		uint depositMoney;
		uint startDate;
		uint finishDate;
		uint payDuration;
	}

	function simpleRent(){
		Lessor = new LessorT();
		Lessee = new LesseeT();
	}

	modifier onlyLessor{
		require(msg.sender == Lessor.getAddress());
		_;
	}

	modifier onlyLessee{
		require(msg.sender == Lessee.getAddress());
		_;
	}

	modifier no1Modifier{
		require(now < info1.startDate);
		_;
	}

	modifier no2Modifier{
		require((now > info1.payDate + info1.payDuration) &&(now < info1.payDate + info1.payDuration+86400));
		_;
	}

	modifier no3Modifier{
		require(now < info1.finishDate);
		_;
	}

	modifier no4_1Modifier{
		require(now > Lessee.continueTime() && continueFlag == true);
		_;
	}

	modifier no4_2Modifier{
		require(now > Lessee.continueTime() && continueFlag == false);
		_;
	}

	modifier no5Modifier{
		require(now > info1.finishDate);
		_;
	}

	function payFirst() onlyLessee() no1Modifier() public payable {
		//USER CODE HERE
		Lessor.setamount(Lessor.getamount() + info1.rent + info1.depositMoney);
		//CHECK

	}

	function payRegular() onlyLessee() no2Modifier() public payable {
		//USER CODE HERE
		info1.payDate = now;
		Lessor.setamount(Lessor.getamount() + info1.rent);
		//CHECK
		assert(info1.payDate == now);
	}

	function continueRent(uint _days) onlyLessee() no3Modifier() public payable {
		//USER CODE HERE
		continueDays = _days;
		Lessor.setamount(Lessor.getamount() + info1.continueRent * continueDays);
		Lessee.continueDone();
		//CHECK
		assert(continueDays == _days);
	}

	function confirmContinue(bool result) onlyLessor() no4_1Modifier() public {
		//USER CODE HERE
		continueFlag = result;
		info1.finishDate = info1.finishDate + continueDays;
		//CHECK
		assert(continueFlag == result && info1.finishDate == info1.finishDate + continueDays);
	}

	function confirmContinue2(bool result) onlyLessor() no4_2Modifier() public payable {
		//USER CODE HERE
		continueFlag = result;
		Lessee.setamount(Lessee.getamount() + info1.continueRent * continueDays);
		//CHECK
		assert(continueFlag == result);
	}

	function endRent() onlyLessor() no5Modifier() public payable {
		//USER CODE HERE
		Lessee.setamount(Lessee.getamount() + info1.depositMoney);
		//CHECK

	}

}
