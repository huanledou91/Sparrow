pragma solidity >=0.4.0 <0.6.0;

import "./biddersT.sol";
import "./platformT.sol";
import "./auctioneerT.sol";
import "./caT.sol";
import "./aaT.sol";
import "./raT.sol";
contract complexAuction {

	biddersT bidders;
	platformT platform;
	auctioneerT auctioneer;
	caT ca;
	aaT aa;
	raT ra;

	uint BiddingStartTime;
	uint bidPrice;
	uint highestPrice;
	address highestBidder;
	uint BiddingStopTime;
	bool result;
	uint commission;
	uint defaultIR;
	bytes32 faultName;
	uint compensation;

	function complexAuction(){
		bidders = new biddersT();
		platform = new platformT();
		auctioneer = new auctioneerT();
		ca = new caT();
		aa = new aaT();
		ra = new raT();
	}

	modifier onlyplatform{
		require(msg.sender == platform.getAddress());
		_;
	}

	modifier onlyauctioneer{
		require(msg.sender == auctioneer.getAddress());
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

	modifier no2Modifier{
		require(result == true);
		_;
	}

	modifier no3Modifier{
		require(now > BiddingStartTime);
		_;
	}

	modifier no4Modifier{
		require(now > platform.StartBiddingTime() && now < BiddingStopTime);
		_;
	}

	modifier no5Modifier{
		require((now > BiddingStopTime) && (now < BiddingStopTime+43200));
		_;
	}

	modifier no6Modifier{
		require(now > bidders.payBidTime(msg.sender));
		_;
	}

	modifier no8Modifier{
		require(now > BiddingStopTime + 43200);
		_;
	}

	modifier no9Modifier{
		require(now > bidders.payDefaultTime(msg.sender));
		_;
	}

	modifier no12Modifier{
		require(now > BiddingStopTime + 259200);
		_;
	}

	modifier no13Modifier{
		require(now > platform.getAATime());
		_;
	}

	modifier no14_1Modifier{
		require(now > aa.aaSetResultTime() && faultName == platform.getname());
		_;
	}

	modifier no14_2Modifier{
		require(now > aa.aaSetResultTime() && faultName == bidders.getname());
		_;
	}

	function check(bool checkResult) onlyca() public {
		//USER CODE HERE
		result = checkResult;
		//CHECK
		assert(result == checkResult);
	}

	function payCommission() onlyauctioneer() no2Modifier() public payable {
		//USER CODE HERE
		platform.setamount(platform.getamount() + commission);
		//CHECK

	}

	function StartBidding() onlyplatform() no3Modifier() public {
		//USER CODE HERE
		platform.StartBiddingDone();
		//CHECK

	}

	function Bid(uint price) no4Modifier() public {
		//USER CODE HERE
		bidPrice = price;
		require(bidPrice > highestPrice);
		highestPrice = price;
		highestBidder = msg.sender;
		//CHECK
		assert(highestPrice == bidPrice);
	}

	function payBid() no5Modifier() public payable {
		//USER CODE HERE
		platform.setamount(platform.getamount() + highestPrice);
		bidders.payBidDone(msg.sender);
		//CHECK

	}

	function transferRight() onlyplatform() no6Modifier() public payable {
		//USER CODE HERE
		auctioneer.setamount(auctioneer.getamount() + highestPrice);
		//CHECK

	}

	function payDefault() no8Modifier() public payable {
		//USER CODE HERE
		platform.setamount(platform.getamount() + highestPrice * defaultIR);
		bidders.payDefaultDone(msg.sender);
		//CHECK

	}

	function returnThing() onlyplatform() no9Modifier() public payable {
		//USER CODE HERE
		platform.setamount(platform.getamount() + highestPrice * defaultIR);
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

	function getAA() onlyplatform() no12Modifier() public {
		//USER CODE HERE
		platform.getAADone();
		//CHECK

	}

	function aaSetResult(bytes32 name, uint Compensation) onlyaa() no13Modifier() public {
		//USER CODE HERE
		faultName = name;
		compensation = Compensation;
		aa.aaSetResultDone();
		//CHECK
		assert(faultName == name && compensation == Compensation);
	}

	function payCompensationP() onlyplatform() no14_1Modifier() public payable {
		//USER CODE HERE
		highestBidder.transfer(compensation);
		//CHECK

	}

	function payCompensationB() no14_2Modifier() public payable {
		//USER CODE HERE
		platform.setamount(platform.getamount() + compensation);
		//CHECK

	}

}
