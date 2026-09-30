pragma solidity >=0.4.0 <0.6.0;

import "./biddersT.sol";
import "./platformT.sol";
import "./auctioneerT.sol";
contract regularAuction {

	biddersT bidders;
	platformT platform;
	auctioneerT auctioneer;

	uint BiddingStartTime;
	uint bidPrice;
	uint highestPrice;
	address highestBidder;
	uint BiddingStopTime;
	uint commission;
	uint defaultIR;

	function regularAuction(){
		bidders = new biddersT();
		platform = new platformT();
		auctioneer = new auctioneerT();
	}

	modifier onlyplatform{
		require(msg.sender == platform.getAddress());
		_;
	}

	modifier onlyauctioneer{
		require(msg.sender == auctioneer.getAddress());
		_;
	}

	modifier no2Modifier{
		require(now > BiddingStartTime);
		_;
	}

	modifier no3Modifier{
		require(now > platform.StartBiddingTime() && now < BiddingStopTime);
		_;
	}

	modifier no4Modifier{
		require((now > BiddingStopTime) && (now < BiddingStopTime+43200));
		_;
	}

	modifier no5Modifier{
		require(now > bidders.payBidTime(msg.sender));
		_;
	}

	modifier no7Modifier{
		require(now > BiddingStopTime + 43200);
		_;
	}

	modifier no8Modifier{
		require(now > bidders.payDefaultTime(msg.sender));
		_;
	}

	function payCommission() onlyauctioneer() public payable {
		//USER CODE HERE
		platform.setamount(platform.getamount() + commission);
		//CHECK

	}

	function StartBidding() onlyplatform() no2Modifier() public {
		//USER CODE HERE
		platform.StartBiddingDone();
		//CHECK

	}

	function Bid(uint price) no3Modifier() public {
		//USER CODE HERE
		bidPrice = price;
		require(bidPrice > highestPrice);
		highestPrice = price;
		highestBidder = msg.sender;
		//CHECK
		assert(highestPrice == bidPrice);
	}

	function payBid() no4Modifier() public payable {
		//USER CODE HERE
		platform.setamount(platform.getamount() + highestPrice);
		bidders.payBidDone(msg.sender);
		//CHECK

	}

	function transferRight() onlyplatform() no5Modifier() public payable {
		//USER CODE HERE
		auctioneer.setamount(auctioneer.getamount() + highestPrice);
		//CHECK

	}

	function payDefault() no7Modifier() public payable {
		//USER CODE HERE
		platform.setamount(platform.getamount() + highestPrice * defaultIR);
		bidders.payDefaultDone(msg.sender);
		//CHECK

	}

	function returnThing() onlyplatform() no8Modifier() public payable {
		//USER CODE HERE
		platform.setamount(platform.getamount() + highestPrice * defaultIR);
		//CHECK

	}

}
