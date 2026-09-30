pragma solidity >=0.4.22 <0.7.0;
pragma experimental ABIEncoderV2;
import "./lib/cml/ConditionalContract.sol";
import "./lib/cml/DateTime.sol";
import "./lib/cml/Model.sol";

contract RugularPurchase is ConditionalContract {

	/*
	 * State variables
	 */
	Model.Party seller;
	Model.Party buyer;
	Model.Party platform;
	uint value;
	uint giveTime;
	bool finalResult;
	uint lateIR;
	uint finishIR;
	bool endContract;

	/*
	 * Constructor
	 */
	constructor(Model.Party memory _seller, Model.Party memory _buyer, Model.Party memory _platform, uint _value, uint _giveTime, bool _finalResult, uint _lateIR, uint _finishIR)public {
		seller = _seller;
		buyer = _buyer;
		platform = _platform;
		value = _value;
		giveTime = _giveTime;
		finalResult = _finalResult;
		lateIR = _lateIR;
		finishIR = _finishIR;
	}

	// Merged modifiers: the generator emitted the same action function under
	// several rules (spec rules sharing actions); one function can carry only
	// one checkAllowed, so duplicated functions are merged with the OR of their
	// rule preconditions.
	modifier checkAllowedConfirmGet() {
		require(contractObeyed());
		require(onlyBy(buyer.id) || onlyBy(platform.id), "Clause not allowed to start.");
		_;
		setCallContext();
	}

	modifier checkAllowedReturnMoney() {
		require(contractObeyed());
		require(
			onlyBy(platform.id) &&
			(
				(callSuccess(this.payfinishB.selector) && callCaller(this.payfinishB.selector) == seller.id && onlyAfter(callTime(this.payfinishB.selector), 0, false))
				||
				(callSuccess(this.payfinishS.selector) && callCaller(this.payfinishS.selector) == buyer.id && onlyAfter(callTime(this.payfinishS.selector), 0, false))
			),
			"Clause not allowed to start."
		);
		_;
		setCallContext();
	}

	/*
	 * Functions
	 */
	// @notice function for clause �cl.name�
	function confirmPurchase() public
		checkAllowed("rule2")
	{
		platform.id.transfer(value);
	}

	// @notice function for clause �cl.name�
	function delivery() public
		checkAllowed("rule3")
	{
	}

	// @notice function for clause �cl.name�
	function confirmArrive() public
		checkAllowed("rule4")
	{
	}

	// @notice function for clause �cl.name�
	function confirmGet() public
		checkAllowedConfirmGet()
	{
	}

	// @notice function for clause �cl.name�
	function transfer2s() public
		checkAllowed("rule7")
	{
		seller.id.transfer(value);
	}

	// @notice function for clause �cl.name�
	function changeContract() public
		checkAllowed("rule7")
	{
		endContract = true;
	}

	// @notice function for clause �cl.name�
	function late_delivery(uint lateDays) public
		checkAllowed("rule8")
	{
		buyer.id.transfer(value * lateIR * lateDays);
	}

	// @notice function for clause �cl.name�
	function payfinishB() public
		checkAllowed("rule9")
	{
		buyer.id.transfer(value * finishIR);
	}

	// @notice function for clause �cl.name�
	function returnMoney() public
		checkAllowedReturnMoney()
	{
		buyer.id.transfer(value);
	}

	// @notice function for clause �cl.name�
	function payfinishS() public
		checkAllowed("rule11")
	{
		seller.id.transfer(value * finishIR);
	}

	// Fallback function
	function() external payable {}

	function clauseAllowed(bytes32 _clauseId) internal returns (bool) {
		if (_clauseId == "rule2") {
			require(onlyBy(buyer.id), "Caller not authorized");
			require(finalResult == true, "Given condition(s) not met");
			return true;
		}
		if (_clauseId == "rule3") {
			require(onlyBy(seller.id), "Caller not authorized");
			require(onlyBefore(giveTime, 0, false), "Function called too late");
			return true;
		}
		if (_clauseId == "rule4") {
			require(onlyBy(platform.id), "Caller not authorized");
			require(callSuccess(this.delivery.selector), "Action delivery did not occur");
			require(callCaller(this.delivery.selector) == seller.id, "Party seller did not delivery");
			require(onlyAfter(callTime(this.delivery.selector), 0, false), "Function called too early");
			return true;
		}
		if (_clauseId == "rule5") {
			require(onlyBy(buyer.id), "Caller not authorized");
			return true;
		}
		if (_clauseId == "rule6") {
			require(onlyBy(platform.id), "Caller not authorized");
			require(callSuccess(this.confirmGet.selector), "Action confirmGet did not occur");
			require(callCaller(this.confirmGet.selector) == buyer.id, "Party buyer did not confirmGet");
			require(onlyAfter(callTime(this.confirmGet.selector), 0, false), "Function called too early");
			return true;
		}
		if (_clauseId == "rule7") {
			require(onlyBy(platform.id), "Caller not authorized");
			return true;
		}
		if (_clauseId == "rule8") {
			require(onlyBy(seller.id), "Caller not authorized");
			return true;
		}
		if (_clauseId == "rule9") {
			require(onlyBy(seller.id), "Caller not authorized");
			return true;
		}
		if (_clauseId == "rule10") {
			require(onlyBy(platform.id), "Caller not authorized");
			require(callSuccess(this.payfinishB.selector), "Action payfinishB did not occur");
			require(callCaller(this.payfinishB.selector) == seller.id, "Party seller did not payfinishB");
			require(onlyAfter(callTime(this.payfinishB.selector), 0, false), "Function called too early");
			return true;
		}
		if (_clauseId == "rule11") {
			require(onlyBy(buyer.id), "Caller not authorized");
			require(endContract == false, "Given condition(s) not met");
			return true;
		}
		if (_clauseId == "rule12") {
			require(onlyBy(seller.id), "Caller not authorized");
			require(endContract == false, "Given condition(s) not met");
			return true;
		}
		if (_clauseId == "rule13") {
			require(onlyBy(platform.id), "Caller not authorized");
			require(callSuccess(this.payfinishS.selector), "Action payfinishS did not occur");
			require(callCaller(this.payfinishS.selector) == buyer.id, "Party buyer did not payfinishS");
			require(onlyAfter(callTime(this.payfinishS.selector), 0, false), "Function called too early");
			return true;
		}
		return false;
	}

	function clauseFulfilledTime(bytes32 _clauseId) internal returns (uint) {
		uint max = 0;
		if (_clauseId == "rule2" && (callSuccess(this.confirmPurchase.selector))) {
			if (max < callTime(this.confirmPurchase.selector)) {
				max =  callTime(this.confirmPurchase.selector);
			}
			return max;
		}
		if (_clauseId == "rule3" && (callSuccess(this.delivery.selector))) {
			if (max < callTime(this.delivery.selector)) {
				max =  callTime(this.delivery.selector);
			}
			return max;
		}
		if (_clauseId == "rule4" && (callSuccess(this.confirmArrive.selector))) {
			if (max < callTime(this.confirmArrive.selector)) {
				max =  callTime(this.confirmArrive.selector);
			}
			return max;
		}
		if (_clauseId == "rule5" && (callSuccess(this.confirmGet.selector))) {
			if (max < callTime(this.confirmGet.selector)) {
				max =  callTime(this.confirmGet.selector);
			}
			return max;
		}
		if (_clauseId == "rule6" && (callSuccess(this.transfer2s.selector) && callSuccess(this.changeContract.selector))) {
			if (max < callTime(this.transfer2s.selector)) {
				max =  callTime(this.transfer2s.selector);
			}
			if (max < callTime(this.changeContract.selector)) {
				max =  callTime(this.changeContract.selector);
			}
			return max;
		}
		if (_clauseId == "rule7" && (callSuccess(this.transfer2s.selector) && callSuccess(this.confirmGet.selector) && callSuccess(this.changeContract.selector))) {
			if (max < callTime(this.transfer2s.selector)) {
				max =  callTime(this.transfer2s.selector);
			}
			if (max < callTime(this.confirmGet.selector)) {
				max =  callTime(this.confirmGet.selector);
			}
			if (max < callTime(this.changeContract.selector)) {
				max =  callTime(this.changeContract.selector);
			}
			return max;
		}
		if (_clauseId == "rule8" && (callSuccess(this.late_delivery.selector))) {
			if (max < callTime(this.late_delivery.selector)) {
				max =  callTime(this.late_delivery.selector);
			}
			return max;
		}
		if (_clauseId == "rule9" && (callSuccess(this.payfinishB.selector))) {
			if (max < callTime(this.payfinishB.selector)) {
				max =  callTime(this.payfinishB.selector);
			}
			return max;
		}
		if (_clauseId == "rule10" && (callSuccess(this.returnMoney.selector) && callSuccess(this.changeContract.selector))) {
			if (max < callTime(this.returnMoney.selector)) {
				max =  callTime(this.returnMoney.selector);
			}
			if (max < callTime(this.changeContract.selector)) {
				max =  callTime(this.changeContract.selector);
			}
			return max;
		}
		if (_clauseId == "rule11" && (callSuccess(this.payfinishS.selector))) {
			if (max < callTime(this.payfinishS.selector)) {
				max =  callTime(this.payfinishS.selector);
			}
			return max;
		}
		if (_clauseId == "rule12" && (callSuccess(this.payfinishB.selector))) {
			if (max < callTime(this.payfinishB.selector)) {
				max =  callTime(this.payfinishB.selector);
			}
			return max;
		}
		if (_clauseId == "rule13" && (callSuccess(this.returnMoney.selector) && callSuccess(this.changeContract.selector))) {
			if (max < callTime(this.returnMoney.selector)) {
				max =  callTime(this.returnMoney.selector);
			}
			if (max < callTime(this.changeContract.selector)) {
				max =  callTime(this.changeContract.selector);
			}
			return max;
		}
		return max;
	}

	function contractObeyed() internal returns (bool) {
		return true;
	}

}
