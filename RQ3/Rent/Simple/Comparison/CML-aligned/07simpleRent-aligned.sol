pragma solidity >=0.4.22 <0.7.0;
pragma experimental ABIEncoderV2;
import "./lib/cml/ConditionalContract.sol";
import "./lib/cml/DateTime.sol";
import "./lib/cml/Model.sol";

contract SimpleRent is ConditionalContract {

	/*
	 * State variables
	 */
	Model.Party lessor;
	Model.Party lessee;
	uint rent;
	uint continueRent;
	uint continueDays;
	uint despoit;
	uint payPeriod;
	uint totalPeriod;
	uint startTime;
	uint finishTime;
	bool end;
	bool continueResult;

	/*
	 * Constructor
	 */
	constructor(Model.Party memory _lessor, Model.Party memory _lessee, uint _rent, uint _despoit, uint _payPeriod, uint _totalPeriod, uint _startTime, uint _finishTime, uint _continueRent, uint _continueDays)public {
		lessor = _lessor;
		lessee = _lessee;
		rent = _rent;
		despoit = _despoit;
		payPeriod = _payPeriod;
		totalPeriod = _totalPeriod;
		startTime = _startTime;
		finishTime = _finishTime;
		continueRent = _continueRent;
		continueDays = _continueDays;
	}

	/*
	 * Functions
	 */
	// @notice function for clause �cl.name�
	function payOne() public
		checkAllowed("rule1")
	{
		lessor.id.transfer(despoit + rent);
	}

	// @notice function for clause �cl.name�
	function payRegular() public
		checkAllowed("rule2")
	{
		lessor.id.transfer(rent);
	}

	// @notice function for clause �cl.name�
	function confirmContinue(uint Days) public
		checkAllowed("rule3")
	{
		continueDays = Days;
		lessor.id.transfer(continueRent * continueDays);
	}

	// @notice function for clause �cl.name�
	function setContinue(bool result) public
		checkAllowed("rule4")
	{
		continueResult = result;
	}

	// @notice function for clause �cl.name�
	function changeFinish() public
		checkAllowed("rule4_1")
	{
	}

	// @notice function for clause �cl.name�
	function rejectChange() public
		checkAllowed("rule4_2")
	{
		lessee.id.transfer(continueRent * continueDays);
	}

	// @notice function for clause �cl.name�
	function finishBack() public
		checkAllowed("rule5")
	{
		lessee.id.transfer(despoit);
		end = true;
	}

	// Fallback function
	function() external payable {}

	function clauseAllowed(bytes32 _clauseId) internal returns (bool) {
		if (_clauseId == "rule1") {
			require(onlyBy(lessee.id), "Caller not authorized");
			require(onlyBefore(startTime, 0, false), "Function called too late");
			return true;
		}
		if (_clauseId == "rule2") {
			require(onlyBy(lessee.id), "Caller not authorized");
			require(onlyBefore(finishTime, 0, false), "Function called too late");
			return true;
		}
		if (_clauseId == "rule3") {
			require(onlyBy(lessee.id), "Caller not authorized");
			require(onlyBefore(DateTime.addDuration(startTime, totalPeriod), 0, false), "Function called too late");
			return true;
		}
		if (_clauseId == "rule4") {
			require(onlyBy(lessor.id), "Caller not authorized");
			require(callSuccess(this.confirmContinue.selector), "Action confirmContinue did not occur");
			require(callCaller(this.confirmContinue.selector) == lessee.id, "Party lessee did not confirmContinue");
			require(onlyAfter(callTime(this.confirmContinue.selector), 0, false), "Function called too early");
			require( !end, "Given condition(s) not met");
			return true;
		}
		if (_clauseId == "rule4_1") {
			require(onlyBy(lessor.id), "Caller not authorized");
			require(callSuccess(this.setContinue.selector), "Action setContinue did not occur");
			require(callCaller(this.setContinue.selector) == lessor.id, "Party lessor did not setContinue");
			require(onlyAfter(callTime(this.setContinue.selector), 0, false), "Function called too early");
			require( !end && continueResult, "Given condition(s) not met");
			return true;
		}
		if (_clauseId == "rule4_2") {
			require(onlyBy(lessor.id), "Caller not authorized");
			require(callSuccess(this.setContinue.selector), "Action setContinue did not occur");
			require(callCaller(this.setContinue.selector) == lessor.id, "Party lessor did not setContinue");
			require(onlyAfter(callTime(this.setContinue.selector), 0, false), "Function called too early");
			require( !end &&  !continueResult, "Given condition(s) not met");
			return true;
		}
		if (_clauseId == "rule5") {
			require(onlyBy(lessor.id), "Caller not authorized");
			require(onlyAfter(DateTime.addDuration(startTime, totalPeriod), 0, false), "Function called too early");
			require( !end, "Given condition(s) not met");
			return true;
		}
		return false;
	}

	function clauseFulfilledTime(bytes32 _clauseId) internal returns (uint) {
		uint max = 0;
		if (_clauseId == "rule1" && (callSuccess(this.payOne.selector))) {
			if (max < callTime(this.payOne.selector)) {
				max =  callTime(this.payOne.selector);
			}
			return max;
		}
		if (_clauseId == "rule2" && (callSuccess(this.payRegular.selector))) {
			if (max < callTime(this.payRegular.selector)) {
				max =  callTime(this.payRegular.selector);
			}
			return max;
		}
		if (_clauseId == "rule3" && (callSuccess(this.confirmContinue.selector))) {
			if (max < callTime(this.confirmContinue.selector)) {
				max =  callTime(this.confirmContinue.selector);
			}
			return max;
		}
		if (_clauseId == "rule4" && (callSuccess(this.setContinue.selector))) {
			if (max < callTime(this.setContinue.selector)) {
				max =  callTime(this.setContinue.selector);
			}
			return max;
		}
		if (_clauseId == "rule4_1" && (callSuccess(this.changeFinish.selector))) {
			if (max < callTime(this.changeFinish.selector)) {
				max =  callTime(this.changeFinish.selector);
			}
			return max;
		}
		if (_clauseId == "rule4_2" && (callSuccess(this.rejectChange.selector))) {
			if (max < callTime(this.rejectChange.selector)) {
				max =  callTime(this.rejectChange.selector);
			}
			return max;
		}
		if (_clauseId == "rule5" && (callSuccess(this.finishBack.selector))) {
			if (max < callTime(this.finishBack.selector)) {
				max =  callTime(this.finishBack.selector);
			}
			return max;
		}
		return max;
	}

	function contractObeyed() internal returns (bool) {
		return true;
	}

}
