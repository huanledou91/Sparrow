pragma solidity >=0.4.0 <0.6.0;

import "./LessorT.sol";
import "./LesseeT.sol";
contract regularRent {

	LessorT Lessor;
	LesseeT Lessee;

	contractInfo info1;
	bool result;
	uint faultIR;
	uint lateDays;
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

	function regularRent(){
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
		require(now > Lessee.payFirstTime() && now < info1.startDate);
		_;
	}

	modifier no3Modifier{
		require((now > info1.startDate) &&(now < info1.startDate+432000));
		_;
	}

	modifier no4Modifier{
		require(now > info1.startDate+432000);
		_;
	}

	modifier no5Modifier{
		require((now > info1.payDate + info1.payDuration) &&(now < info1.payDate + info1.payDuration+86400));
		_;
	}

	modifier no6Modifier{
		require((now > info1.payDate + info1.payDuration) &&(now < info1.payDate + info1.payDuration+432000));
		_;
	}

	modifier no7Modifier{
		require(now > info1.payDate + info1.payDuration+432000);
		_;
	}

	modifier no8Modifier{
		require(now < info1.finishDate);
		_;
	}

	modifier no9_1Modifier{
		require(now > Lessee.continueTime() && continueFlag == true);
		_;
	}

	modifier no9_2Modifier{
		require(now > Lessee.continueTime() && continueFlag == false);
		_;
	}

	modifier no10Modifier{
		require(now > info1.finishDate);
		_;
	}

	function payFirst() onlyLessee() no1Modifier() public payable {
		//USER CODE HERE
		Lessor.setamount(Lessor.getamount() + info1.rent + info1.depositMoney);
		Lessee.payFirstDone();
		//CHECK

	}

	function changeUse() onlyLessor() no2Modifier() public {
		//USER CODE HERE
		//CHECK

	}

	function changeLate(uint LateDay) onlyLessor() no3Modifier() public payable {
		//USER CODE HERE
		lateDays = LateDay;
		Lessee.setamount(Lessee.getamount() + info1.rent * faultIR);
		//CHECK
		assert(lateDays == LateDay);
	}

	function finishLate() onlyLessor() no4Modifier() public payable {
		//USER CODE HERE
		Lessee.setamount(Lessee.getamount() + info1.rent * faultIR);
		Lessee.setamount(Lessee.getamount() + info1.rent + info1.depositMoney);
		//CHECK

	}

	function payRegular() onlyLessee() no5Modifier() public payable {
		//USER CODE HERE
		info1.payDate = now;
		Lessor.setamount(Lessor.getamount() + info1.rent);
		//CHECK
		assert(info1.payDate == now);
	}

	function payRegularLate(uint LateDay) onlyLessee() no6Modifier() public payable {
		//USER CODE HERE
		info1.payDate = info1.payDate + info1.payDuration;
		Lessor.setamount(Lessor.getamount() + info1.rent * lateDays);
		//CHECK
		assert(info1.payDate == info1.payDate + info1.payDuration);
	}

	function back() onlyLessor() no7Modifier() public {
		//USER CODE HERE
		//CHECK

	}

	function continueRent(uint _days) onlyLessee() no8Modifier() public payable {
		//USER CODE HERE
		continueDays = _days;
		Lessor.setamount(Lessor.getamount() + info1.continueRent * continueDays);
		Lessee.continueDone();
		//CHECK
		assert(continueDays == _days);
	}

	function confirmContinue(bool result) onlyLessor() no9_1Modifier() public {
		//USER CODE HERE
		continueFlag = result;
		info1.finishDate = info1.finishDate + continueDays;
		//CHECK
		assert(continueFlag == result && info1.finishDate == info1.finishDate + continueDays);
	}

	function confirmContinue2(bool result) onlyLessor() no9_2Modifier() public payable {
		//USER CODE HERE
		continueFlag = result;
		Lessee.setamount(Lessee.getamount() + info1.continueRent * continueDays);
		//CHECK
		assert(continueFlag == result);
	}

	function endRent() onlyLessor() no10Modifier() public payable {
		//USER CODE HERE
		Lessee.setamount(Lessee.getamount() + info1.depositMoney);
		//CHECK

	}

}
