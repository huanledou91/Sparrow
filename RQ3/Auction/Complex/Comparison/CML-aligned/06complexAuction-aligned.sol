pragma solidity >=0.4.22 <0.7.0;
pragma experimental ABIEncoderV2;
import "./lib/cml/ConditionalContract.sol";
import "./lib/cml/DateTime.sol";
import "./lib/cml/Model.sol";

contract ComplexAuction is ConditionalContract {

	/*
	 * State variables
	 */
	Model.Party highestBidder;
	Model.Party auctioneer;
	Model.Party platform;
	Model.Party ca;
	Model.Party aa;
	Model.Party ra;
	uint commision;
	uint highestBid;
	uint biddingStart;
	uint biddingTime;
	bool ended;
	uint faultIR;
	bytes32 faultName;
	uint compensation;
	uint _contractStart;

	/*
	 * Constructor
	 */
	constructor(Model.Party memory _highestBidder, Model.Party memory _auctioneer, Model.Party memory _platform, Model.Party memory _ca, Model.Party memory _aa, Model.Party memory _ra, uint _commision, uint _highestBid, uint _biddingTime, uint _faultIR, uint _biddingStart)public {
		highestBidder = _highestBidder;
		auctioneer = _auctioneer;
		platform = _platform;
		ca = _ca;
		aa = _aa;
		ra = _ra;
		commision = _commision;
		highestBid = _highestBid;
		biddingTime = _biddingTime;
		faultIR = _faultIR;
		biddingStart = _biddingStart;
		_contractStart = now;
	}

	/*
	 * Functions
	 */
	// @notice function for clause �cl.name�
	function checkResult(bool result) public
		checkAllowed("rule1")
	{
	}

	// @notice function for clause �cl.name�
	function payCommision() public
		checkAllowed("rule2")
	{
		platform.id.transfer(commision);
	}

	// @notice function for clause �cl.name�
	function startBid() public
		checkAllowed("rule3")
	{
	}

	// @notice function for clause �cl.name�
	function bid() public payable
		checkAllowed("rule4")
	{
		require(msg.value > highestBid, "There already is a higher bid.");
		highestBidder.id = msg.sender;
		highestBid = msg.value;
	}

	// @notice function for clause �cl.name�
	function payHighest() public
		checkAllowed("rule5")
	{
		platform.id.transfer(highestBid);
	}

	// @notice function for clause �cl.name�
	function endContract() public
		checkAllowed("rule6")
	{
		ended = true;
		auctioneer.id.transfer(highestBid);
	}

	// @notice function for clause �cl.name�
	function payFault() public
		checkAllowed("rule8")
	{
		platform.id.transfer(faultIR * highestBid);
	}

	// @notice function for clause �cl.name�
	function endContract2() public
		checkAllowed("rule9")
	{
		ended = true;
		auctioneer.id.transfer(highestBid * faultIR);
	}

	// @notice function for clause �cl.name�
	function pauseContract() public
		checkAllowed("rule10")
	{
		ended = true;
	}

	// @notice function for clause �cl.name�
	function restartContract() public
		checkAllowed("rule11")
	{
		ended = false;
	}

	// @notice function for clause �cl.name�
	function getAA() public
		checkAllowed("rule12")
	{
	}

	// @notice function for clause �cl.name�
	function setSolution(bytes32 _faultName, uint _compensation) public
		checkAllowed("rule13")
	{
		faultName = _faultName;
		compensation = _compensation;
	}

	// @notice function for clause �cl.name�
	function payFaultP() public
		checkAllowed("rule14_1")
	{
		highestBidder.id.transfer(compensation);
	}

	// @notice function for clause �cl.name�
	function payFaultB() public
		checkAllowed("rule14_2")
	{
		platform.id.transfer(compensation);
	}

	// Fallback function
	function() external payable {}

	function clauseAllowed(bytes32 _clauseId) internal returns (bool) {
		if (_clauseId == "rule1") {
			require(onlyBy(ca.id), "Caller not authorized");
			require(onlyBefore(biddingStart, 0, false), "Function called too late");
			return true;
		}
		if (_clauseId == "rule2") {
			require(onlyBy(auctioneer.id), "Caller not authorized");
			require(callSuccess(this.checkResult.selector), "Action checkResult did not occur");
			require(callCaller(this.checkResult.selector) == ca.id, "Party ca did not checkResult");
			require(onlyAfter(callTime(this.checkResult.selector), 0, false), "Function called too early");
			return true;
		}
		if (_clauseId == "rule3") {
			require(onlyBy(platform.id), "Caller not authorized");
			require(onlyAfter(biddingStart, 0, false), "Function called too early");
			require( !ended, "Given condition(s) not met");
			return true;
		}
		if (_clauseId == "rule4") {
			require(onlyAfter(biddingStart, biddingTime, true), "Function not called within expected timeframe");
			require( !ended, "Given condition(s) not met");
			return true;
		}
		if (_clauseId == "rule5") {
			require(onlyBy(highestBidder.id), "Caller not authorized");
			require(onlyAfter(DateTime.addDuration(biddingStart, biddingTime), 12 hours, true), "Function not called within expected timeframe");
			require( !ended, "Given condition(s) not met");
			return true;
		}
		if (_clauseId == "rule6") {
			require(onlyBy(platform.id), "Caller not authorized");
			require(callSuccess(this.payHighest.selector), "Action payHighest did not occur");
			require(callCaller(this.payHighest.selector) == highestBidder.id, "Party highestBidder did not payHighest");
			require(onlyAfter(callTime(this.payHighest.selector), 0, false), "Function called too early");
			require( !ended, "Given condition(s) not met");
			return true;
		}
		if (_clauseId == "rule8") {
			require(onlyBy(highestBidder.id), "Caller not authorized");
			require( !ended, "Given condition(s) not met");
			return true;
		}
		if (_clauseId == "rule9") {
			require(onlyBy(platform.id), "Caller not authorized");
			require(callSuccess(this.payFault.selector), "Action payFault did not occur");
			require(callCaller(this.payFault.selector) == highestBidder.id, "Party highestBidder did not payFault");
			require(onlyAfter(callTime(this.payFault.selector), 0, false), "Function called too early");
			require( !ended, "Given condition(s) not met");
			return true;
		}
		if (_clauseId == "rule10") {
			require(onlyBy(ra.id), "Caller not authorized");
			return true;
		}
		if (_clauseId == "rule11") {
			require(onlyBy(ra.id), "Caller not authorized");
			return true;
		}
		if (_clauseId == "rule12") {
			require(onlyBy(platform.id), "Caller not authorized");
			require(onlyAfter(DateTime.addDuration(_contractStart, biddingTime), 0, false), "Function called too early");
			return true;
		}
		if (_clauseId == "rule13") {
			require(onlyBy(aa.id), "Caller not authorized");
			require(callSuccess(this.getAA.selector), "Action getAA did not occur");
			require(callCaller(this.getAA.selector) == platform.id, "Party platform did not getAA");
			require(onlyAfter(callTime(this.getAA.selector), 0, false), "Function called too early");
			return true;
		}
		if (_clauseId == "rule14_1") {
			require(onlyBy(platform.id), "Caller not authorized");
			require(callSuccess(this.setSolution.selector), "Action setSolution did not occur");
			require(callCaller(this.setSolution.selector) == aa.id, "Party aa did not setSolution");
			require(onlyAfter(callTime(this.setSolution.selector), 0, false), "Function called too early");
			require(faultName == "platform", "Given condition(s) not met");
			return true;
		}
		if (_clauseId == "rule14_2") {
			require(onlyBy(highestBidder.id), "Caller not authorized");
			require(callSuccess(this.setSolution.selector), "Action setSolution did not occur");
			require(callCaller(this.setSolution.selector) == aa.id, "Party aa did not setSolution");
			require(onlyAfter(callTime(this.setSolution.selector), 0, false), "Function called too early");
			require(faultName == "bidder", "Given condition(s) not met");
			return true;
		}
		return false;
	}

	function clauseFulfilledTime(bytes32 _clauseId) internal returns (uint) {
		uint max = 0;
		if (_clauseId == "rule1" && (callSuccess(this.checkResult.selector))) {
			if (max < callTime(this.checkResult.selector)) {
				max =  callTime(this.checkResult.selector);
			}
			return max;
		}
		if (_clauseId == "rule2" && (callSuccess(this.payCommision.selector))) {
			if (max < callTime(this.payCommision.selector)) {
				max =  callTime(this.payCommision.selector);
			}
			return max;
		}
		if (_clauseId == "rule3" && (callSuccess(this.startBid.selector))) {
			if (max < callTime(this.startBid.selector)) {
				max =  callTime(this.startBid.selector);
			}
			return max;
		}
		if (_clauseId == "rule4" && (callSuccess(this.bid.selector))) {
			if (max < callTime(this.bid.selector)) {
				max =  callTime(this.bid.selector);
			}
			return max;
		}
		if (_clauseId == "rule5" && (callSuccess(this.payHighest.selector))) {
			if (max < callTime(this.payHighest.selector)) {
				max =  callTime(this.payHighest.selector);
			}
			return max;
		}
		if (_clauseId == "rule6" && (callSuccess(this.endContract.selector))) {
			if (max < callTime(this.endContract.selector)) {
				max =  callTime(this.endContract.selector);
			}
			return max;
		}
		if (_clauseId == "rule8" && (callSuccess(this.payFault.selector))) {
			if (max < callTime(this.payFault.selector)) {
				max =  callTime(this.payFault.selector);
			}
			return max;
		}
		if (_clauseId == "rule9" && (callSuccess(this.endContract2.selector))) {
			if (max < callTime(this.endContract2.selector)) {
				max =  callTime(this.endContract2.selector);
			}
			return max;
		}
		if (_clauseId == "rule10" && (callSuccess(this.pauseContract.selector))) {
			if (max < callTime(this.pauseContract.selector)) {
				max =  callTime(this.pauseContract.selector);
			}
			return max;
		}
		if (_clauseId == "rule11" && (callSuccess(this.restartContract.selector))) {
			if (max < callTime(this.restartContract.selector)) {
				max =  callTime(this.restartContract.selector);
			}
			return max;
		}
		if (_clauseId == "rule12" && (callSuccess(this.getAA.selector))) {
			if (max < callTime(this.getAA.selector)) {
				max =  callTime(this.getAA.selector);
			}
			return max;
		}
		if (_clauseId == "rule13" && (callSuccess(this.setSolution.selector))) {
			if (max < callTime(this.setSolution.selector)) {
				max =  callTime(this.setSolution.selector);
			}
			return max;
		}
		if (_clauseId == "rule14_1" && (callSuccess(this.payFaultP.selector))) {
			if (max < callTime(this.payFaultP.selector)) {
				max =  callTime(this.payFaultP.selector);
			}
			return max;
		}
		if (_clauseId == "rule14_2" && (callSuccess(this.payFaultB.selector))) {
			if (max < callTime(this.payFaultB.selector)) {
				max =  callTime(this.payFaultB.selector);
			}
			return max;
		}
		return max;
	}

	function contractObeyed() internal returns (bool) {
		return true;
	}

}
