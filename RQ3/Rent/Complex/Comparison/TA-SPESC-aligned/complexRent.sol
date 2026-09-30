pragma solidity >=0.4.0 <0.6.0;

import "./LessorT.sol";
import "./LesseeT.sol";
import "./caT.sol";
import "./aaT.sol";
import "./raT.sol";
contract complexRent {

	LessorT Lessor;
	LesseeT Lessee;
	caT ca;
	aaT aa;
	raT ra;

	contractInfo info1;
	bool result;
	uint faultIR;
	bytes32 faultName;
	uint compensation;
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

	function complexRent(){
		Lessor = new LessorT();
		Lessee = new LesseeT();
		ca = new caT();
		aa = new aaT();
		ra = new raT();
	}

	modifier onlyLessor{
		require(msg.sender == Lessor.getAddress());
		_;
	}

	modifier onlyLessee{
		require(msg.sender == Lessee.getAddress());
		_;
	}

	modifier onlyca{
		require(msg.sender == ca.getAddress());
		_;
	}

	modifier onlyaa{
		require(msg.sender == aa.getAddress());
		_;
	}

	modifier onlyra{
		require(msg.sender == ra.getAddress());
		_;
	}

	modifier no1Modifier{
		require(now < info1.startDate);
		_;
	}

	modifier no2Modifier{
		require(result == true && now < info1.startDate);
		_;
	}

	modifier no3Modifier{
		require(now > Lessee.payFirstTime() && now < info1.startDate);
		_;
	}

	modifier no4Modifier{
		require((now > info1.startDate) &&(now < info1.startDate+432000));
		_;
	}

	modifier no5Modifier{
		require(now > info1.startDate+432000);
		_;
	}

	modifier no6Modifier{
		require((now > info1.payDate + info1.payDuration) &&(now < info1.payDate + info1.payDuration+86400));
		_;
	}

	modifier no7Modifier{
		require((now > info1.payDate + info1.payDuration) &&(now < info1.payDate + info1.payDuration+432000));
		_;
	}

	modifier no8Modifier{
		require(now > info1.payDate + info1.payDuration+432000);
		_;
	}

	modifier no9Modifier{
		require(now < info1.finishDate);
		_;
	}

	modifier no10_1Modifier{
		require(now > Lessee.continueTime() && continueFlag == true);
		_;
	}

	modifier no10_2Modifier{
		require(now > Lessee.continueTime() && continueFlag == false);
		_;
	}

	modifier no11Modifier{
		require(now > info1.finishDate);
		_;
	}

	modifier no16Modifier{
		require(now > Lessor.getAA1Time() || now > Lessee.getAA2Time());
		_;
	}

	modifier no17_1Modifier{
		require(now > aa.aaSetResultTime() && faultName == Lessor.getname());
		_;
	}

	modifier no18_2Modifier{
		require(now > aa.aaSetResultTime() && faultName == Lessee.getname());
		_;
	}

	function check(bool checkResult) onlyca() no1Modifier() public {
		//USER CODE HERE
		result = checkResult;
		//CHECK
		assert(result == checkResult);
	}

	function payFirst() onlyLessee() no2Modifier() public payable {
		//USER CODE HERE
		Lessor.setamount(Lessor.getamount() + info1.rent + info1.depositMoney);
		Lessee.payFirstDone();
		//CHECK

	}

	function changeUse() onlyLessor() no3Modifier() public {
		//USER CODE HERE
		//CHECK

	}

	function changeLate(uint LateDay) onlyLessor() no4Modifier() public payable {
		//USER CODE HERE
		lateDays = LateDay;
		Lessee.setamount(Lessee.getamount() + info1.rent * faultIR);
		//CHECK
		assert(lateDays == LateDay);
	}

	function finishLate() onlyLessor() no5Modifier() public payable {
		//USER CODE HERE
		Lessee.setamount(Lessee.getamount() + info1.rent * faultIR);
		Lessee.setamount(Lessee.getamount() + info1.rent + info1.depositMoney);
		//CHECK

	}

	function payRegular() onlyLessee() no6Modifier() public payable {
		//USER CODE HERE
		info1.payDate = now;
		Lessor.setamount(Lessor.getamount() + info1.rent);
		//CHECK
		assert(info1.payDate == now);
	}

	function payRegularLate(uint LateDay) onlyLessee() no7Modifier() public payable {
		//USER CODE HERE
		info1.payDate = info1.payDate + info1.payDuration;
		Lessor.setamount(Lessor.getamount() + info1.rent * lateDays);
		//CHECK
		assert(info1.payDate == info1.payDate + info1.payDuration);
	}

	function back() onlyLessor() no8Modifier() public {
		//USER CODE HERE
		//CHECK

	}

	function continueRent(uint _days) onlyLessee() no9Modifier() public payable {
		//USER CODE HERE
		continueDays = _days;
		Lessor.setamount(Lessor.getamount() + info1.continueRent * continueDays);
		Lessee.continueDone();
		//CHECK
		assert(continueDays == _days);
	}

	function confirmContinue(bool result) onlyLessor() no10_1Modifier() public {
		//USER CODE HERE
		continueFlag = result;
		info1.finishDate = info1.finishDate + continueDays;
		//CHECK
		assert(continueFlag == result && info1.finishDate == info1.finishDate + continueDays);
	}

	function confirmContinue2(bool result) onlyLessor() no10_2Modifier() public payable {
		//USER CODE HERE
		continueFlag = result;
		Lessee.setamount(Lessee.getamount() + info1.continueRent * continueDays);
		//CHECK
		assert(continueFlag == result);
	}

	function endRent() onlyLessor() no11Modifier() public payable {
		//USER CODE HERE
		Lessee.setamount(Lessee.getamount() + info1.depositMoney);
		//CHECK

	}

	function pauseContract() onlyra() public {
		//USER CODE HERE
		//CHECK

	}

	function restartContract() onlyra() public {
		//USER CODE HERE
		//CHECK

	}

	function getAA1() onlyLessor() public {
		//USER CODE HERE
		Lessor.getAA1Done();
		//CHECK

	}

	function getAA2() onlyLessee() public {
		//USER CODE HERE
		Lessee.getAA2Done();
		//CHECK

	}

	function aaSetResult(bytes32 name, uint Compensation) onlyaa() no16Modifier() public {
		//USER CODE HERE
		faultName = name;
		compensation = Compensation;
		aa.aaSetResultDone();
		//CHECK
		assert(faultName == name && compensation == Compensation);
	}

	function payCompensation1() onlyLessor() no17_1Modifier() public payable {
		//USER CODE HERE
		Lessee.setamount(Lessee.getamount() + compensation);
		//CHECK

	}

	function payCompensation2() onlyLessee() no18_2Modifier() public payable {
		//USER CODE HERE
		Lessor.setamount(Lessor.getamount() + compensation);
		//CHECK

	}

}
