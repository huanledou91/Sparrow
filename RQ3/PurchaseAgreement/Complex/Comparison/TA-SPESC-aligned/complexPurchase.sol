pragma solidity >=0.4.0 <0.6.0;

import "./SellerT.sol";
import "./BuyerT.sol";
import "./PlatformT.sol";
import "./caT.sol";
import "./aaT.sol";
import "./raT.sol";
import "./courtT.sol";
contract complexPurchase {

	SellerT Seller;
	BuyerT Buyer;
	PlatformT Platform;
	caT ca;
	aaT aa;
	raT ra;
	courtT court;

	contractInfo info1;
	uint lateIR;
	uint finishIR;
	bool result;
	bool confirmSolution;
	bytes32 solutionS;
	bytes32 solutionB;
	bytes32 faultName;
	uint Compensation;

	struct contractInfo{
		uint giveDate;
		uint Price;
	}

	function complexPurchase(){
		Seller = new SellerT();
		Buyer = new BuyerT();
		Platform = new PlatformT();
		ca = new caT();
		aa = new aaT();
		ra = new raT();
		court = new courtT();
	}

	modifier onlySeller{
		require(msg.sender == Seller.getAddress());
		_;
	}

	modifier onlyBuyer{
		require(msg.sender == Buyer.getAddress());
		_;
	}

	modifier onlyPlatform{
		require(msg.sender == Platform.getAddress());
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

	modifier onlycourt{
		require(msg.sender == court.getAddress());
		_;
	}

	modifier no2Modifier{
		require(result == true);
		_;
	}

	modifier no3Modifier{
		require(now < info1.giveDate && now > Buyer.confirmBuyTime());
		_;
	}

	modifier no4Modifier{
		require(now > Seller.deliveryTime() || now > Seller.suspendDelivery1Time());
		_;
	}

	modifier no5Modifier{
		require((now > Platform.confirmArriveTime()) &&(now < Platform.confirmArriveTime()+1296000));
		_;
	}

	modifier no6Modifier{
		require(now > Buyer.confirmGetTime());
		_;
	}

	modifier no7Modifier{
		require(now > Platform.confirmArriveTime()+1296000);
		_;
	}

	modifier no8Modifier{
		require((now > info1.giveDate && now > Buyer.confirmBuyTime()) &&(now < info1.giveDate + 432000));
		_;
	}

	modifier no9Modifier{
		require(now > info1.giveDate + 432000 && now > Buyer.confirmBuyTime());
		_;
	}

	modifier no10Modifier{
		require(now > Seller.suspendDelivery2Time());
		_;
	}

	modifier no13Modifier{
		require(now > Buyer.endSale2Time() || now > Seller.endSale1Time());
		_;
	}

	modifier no18Modifier{
		require(solutionS == 'Negotiate' && solutionB == 'Negotiate');
		_;
	}

	modifier no19Modifier{
		require(now > Buyer.BuyerSetResultTime());
		_;
	}

	modifier no20_1Modifier{
		require((confirmSolution == true || now > court.courtSetResultTime() || now > aa.aaSetResultTime()) && faultName == Seller.getname());
		_;
	}

	modifier no20_2Modifier{
		require((confirmSolution == true || now > court.courtSetResultTime() || now > aa.aaSetResultTime()) && faultName == Buyer.getname());
		_;
	}

	modifier no21Modifier{
		require(solutionS == 'court' && solutionB == 'court');
		_;
	}

	modifier no23Modifier{
		require(solutionS == 'aa' && solutionB == 'aa');
		_;
	}

	function check(bool checkResult) onlyca() public {
		//USER CODE HERE
		result = checkResult;
		//CHECK
		assert(result == checkResult);
	}

	function confirmBuy() onlyBuyer() no2Modifier() public payable {
		//USER CODE HERE
		Platform.setamount(Platform.getamount() + info1.Price);
		Buyer.confirmBuyDone();
		//CHECK

	}

	function delivery() onlySeller() no3Modifier() public {
		//USER CODE HERE
		Seller.deliveryDone();
		//CHECK

	}

	function confirmArrive() onlyPlatform() no4Modifier() public {
		//USER CODE HERE
		Platform.confirmArriveDone();
		//CHECK

	}

	function confirmGet() onlyBuyer() no5Modifier() public {
		//USER CODE HERE
		Buyer.confirmGetDone();
		//CHECK

	}

	function endSale31() onlyPlatform() no6Modifier() public payable {
		//USER CODE HERE
		Seller.setamount(Seller.getamount() + info1.Price);
		//CHECK

	}

	function endSale32() onlyPlatform() no7Modifier() public payable {
		//USER CODE HERE
		Seller.setamount(Seller.getamount() + info1.Price);
		//CHECK

	}

	function suspendDelivery1(uint lateDays) onlySeller() no8Modifier() public payable {
		//USER CODE HERE
		Buyer.setamount(Buyer.getamount() + info1.Price * lateIR);
		Seller.suspendDelivery1Done();
		//CHECK

	}

	function suspendDelivery2() onlySeller() no9Modifier() public payable {
		//USER CODE HERE
		Buyer.setamount(Buyer.getamount() + info1.Price * lateIR);
		Seller.suspendDelivery2Done();
		//CHECK

	}

	function endSale33() onlyPlatform() no10Modifier() public payable {
		//USER CODE HERE
		Buyer.setamount(Buyer.getamount() + info1.Price);
		//CHECK

	}

	function endSale2() onlyBuyer() public payable {
		//USER CODE HERE
		Seller.setamount(Seller.getamount() + info1.Price * finishIR);
		Buyer.endSale2Done();
		//CHECK

	}

	function endSale1() onlySeller() public payable {
		//USER CODE HERE
		Buyer.setamount(Buyer.getamount() + info1.Price * finishIR);
		Seller.endSale1Done();
		//CHECK

	}

	function endSale34() onlyPlatform() no13Modifier() public payable {
		//USER CODE HERE
		Buyer.setamount(Buyer.getamount() + info1.Price);
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

	function chooseSolutionB(bytes32 _solutionB) onlyBuyer() public {
		//USER CODE HERE
		solutionB = _solutionB;
		//CHECK

	}

	function chooseSolutionS(bytes32 _solutionS) onlySeller() public {
		//USER CODE HERE
		solutionS = _solutionS;
		//CHECK

	}

	function BuyerSetResult(bytes32 name, uint Compensation) onlyBuyer() no18Modifier() public {
		//USER CODE HERE
		Buyer.BuyerSetResultDone();
		//CHECK

	}

	function confirmResult(bool confirm) onlySeller() no19Modifier() public {
		//USER CODE HERE
		confirmSolution = confirm;
		//CHECK
		assert(confirmSolution == confirm);
	}

	function payCompensationS() onlySeller() no20_1Modifier() public payable {
		//USER CODE HERE
		Buyer.setamount(Buyer.getamount() + Compensation);
		//CHECK

	}

	function payCompensationB() onlyBuyer() no20_2Modifier() public payable {
		//USER CODE HERE
		Seller.setamount(Seller.getamount() + Compensation);
		//CHECK

	}

	function courtSetResult(bytes32 name, uint _Compensation) onlycourt() no21Modifier() public {
		//USER CODE HERE
		faultName = name;
		Compensation = _Compensation;
		court.courtSetResultDone();
		//CHECK
		assert(faultName == name && Compensation == _Compensation);
	}

	function aaSetResult(bytes32 name, uint _Compensation) onlyaa() no23Modifier() public {
		//USER CODE HERE
		faultName = name;
		Compensation = _Compensation;
		aa.aaSetResultDone();
		//CHECK
		assert(faultName == name && Compensation == _Compensation);
	}

}
