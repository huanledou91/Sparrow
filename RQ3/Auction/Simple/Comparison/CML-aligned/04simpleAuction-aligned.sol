pragma solidity >=0.4.22 <0.7.0;
pragma experimental ABIEncoderV2;
import "./lib/cml/ConditionalContract.sol";
import "./lib/cml/DateTime.sol";
import "./lib/cml/Model.sol";

contract SimpleAuction is ConditionalContract {

	/*
	 * State variables
	 */
	Model.Party highestBidder;
	Model.Party auctioneer;
	Model.Party platform;
	uint commision;
	uint highestBid;
	uint biddingStart;
	uint biddingTime;
	bool ended;

	/*
	 * Constructor
	 */
	constructor(Model.Party memory _highestBidder, Model.Party memory _auctioneer, uint _commision, uint _highestBid, uint _biddingTime, uint _biddingStart)public {
		highestBidder = _highestBidder;
		auctioneer = _auctioneer;
		commision = _commision;
		highestBid = _highestBid;
		biddingTime = _biddingTime;
		biddingStart = _biddingStart;
	}

	/*
	 * Functions
	 */
	// @notice function for clause �cl.name�
	function payCommision() public
		checkAllowed("rule1")
	{
		platform.id.transfer(commision);
	}

	// @notice function for clause �cl.name�
	function startBid() public
		checkAllowed("rule2")
	{
	}

	// @notice function for clause �cl.name�
	function bid() public payable
		checkAllowed("rule3")
	{
		require(msg.value > highestBid, "There already is a higher bid.");
		highestBidder.id = msg.sender;
		highestBid = msg.value;
	}

	// @notice function for clause �cl.name�
	function payHighest() public
		checkAllowed("rule4")
	{
		platform.id.transfer(highestBid);
	}

	// @notice function for clause �cl.name�
	function endContract() public
		checkAllowed("rule5")
	{
		ended = true;
		auctioneer.id.transfer(highestBid);
	}

	// Fallback function
	function() external payable {}

	function clauseAllowed(bytes32 _clauseId) internal returns (bool) {
		if (_clauseId == "rule1") {
			require(onlyBy(auctioneer.id), "Caller not authorized");
			return true;
		}
		if (_clauseId == "rule2") {
			require(onlyBy(platform.id), "Caller not authorized");
			require(onlyAfter(biddingStart, 0, false), "Function called too early");
			require( !ended, "Given condition(s) not met");
			return true;
		}
		if (_clauseId == "rule3") {
			require(onlyAfter(biddingStart, biddingTime, true), "Function not called within expected timeframe");
			require( !ended, "Given condition(s) not met");
			return true;
		}
		if (_clauseId == "rule4") {
			require(onlyBy(highestBidder.id), "Caller not authorized");
			require(onlyAfter(DateTime.addDuration(biddingStart, biddingTime), 12 hours, true), "Function not called within expected timeframe");
			require( !ended, "Given condition(s) not met");
			return true;
		}
		if (_clauseId == "rule5") {
			require(onlyBy(platform.id), "Caller not authorized");
			require(callSuccess(this.payHighest.selector), "Action payHighest did not occur");
			require(callCaller(this.payHighest.selector) == highestBidder.id, "Party highestBidder did not payHighest");
			require(onlyAfter(callTime(this.payHighest.selector), 0, false), "Function called too early");
			require( !ended, "Given condition(s) not met");
			return true;
		}
		return false;
	}

	function clauseFulfilledTime(bytes32 _clauseId) internal returns (uint) {
		uint max = 0;
		if (_clauseId == "rule1" && (callSuccess(this.payCommision.selector))) {
			if (max < callTime(this.payCommision.selector)) {
				max =  callTime(this.payCommision.selector);
			}
			return max;
		}
		if (_clauseId == "rule2" && (callSuccess(this.startBid.selector))) {
			if (max < callTime(this.startBid.selector)) {
				max =  callTime(this.startBid.selector);
			}
			return max;
		}
		if (_clauseId == "rule3" && (callSuccess(this.bid.selector))) {
			if (max < callTime(this.bid.selector)) {
				max =  callTime(this.bid.selector);
			}
			return max;
		}
		if (_clauseId == "rule4" && (callSuccess(this.payHighest.selector))) {
			if (max < callTime(this.payHighest.selector)) {
				max =  callTime(this.payHighest.selector);
			}
			return max;
		}
		if (_clauseId == "rule5" && (callSuccess(this.endContract.selector))) {
			if (max < callTime(this.endContract.selector)) {
				max =  callTime(this.endContract.selector);
			}
			return max;
		}
		return max;
	}

	function contractObeyed() internal returns (bool) {
		return true;
	}

}
