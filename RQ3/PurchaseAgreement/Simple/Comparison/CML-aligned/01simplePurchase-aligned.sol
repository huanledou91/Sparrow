pragma solidity >=0.4.22 <0.7.0;
pragma experimental ABIEncoderV2;
import "./lib/cml/ConditionalContract.sol";
import "./lib/cml/DateTime.sol";
import "./lib/cml/Model.sol";

contract SimplePurchase is ConditionalContract {

	/*
	 * State variables
	 */
	Model.Party seller;
	Model.Party buyer;
	Model.Party platform;
	uint value;
	uint giveTime;

	/*
	 * Constructor
	 */
	constructor(Model.Party memory _seller, Model.Party memory _buyer, uint _value, Model.Party memory _platform, uint _giveTime)public {
		seller = _seller;
		buyer = _buyer;
		platform = _platform;
		value = _value;
		giveTime = _giveTime;
	}

	/*
	 * Functions
	 */
	// @notice function for clause �cl.name�
	function confirmPurchase() public
		checkAllowed("rule1")
	{
		platform.id.transfer(value);
	}

	// @notice function for clause �cl.name�
	function delivery() public
		checkAllowed("rule2")
	{
	}

	// @notice function for clause �cl.name�
	function confirmArrive() public
		checkAllowed("rule3")
	{
	}

	// @notice function for clause �cl.name�
	function confirmGet() public
		checkAllowed("rule4")
	{
	}

	// @notice function for clause �cl.name�
	function transfer2s() public
		checkAllowed("rule5")
	{
		seller.id.transfer(value);
	}

	// @notice function for clause �cl.name�
	function changeContract() public
		checkAllowed("rule5")
	{
	}

	// Fallback function
	function() external payable {}

	function clauseAllowed(bytes32 _clauseId) internal returns (bool) {
		if (_clauseId == "rule1") {
			require(onlyBy(buyer.id), "Caller not authorized");
			return true;
		}
		if (_clauseId == "rule2") {
			require(onlyBy(seller.id), "Caller not authorized");
			require(onlyBefore(giveTime, 0, false), "Function called too late");
			return true;
		}
		if (_clauseId == "rule3") {
			require(onlyBy(platform.id), "Caller not authorized");
			require(callSuccess(this.delivery.selector), "Action delivery did not occur");
			require(callCaller(this.delivery.selector) == seller.id, "Party seller did not delivery");
			require(onlyAfter(callTime(this.delivery.selector), 0, false), "Function called too early");
			return true;
		}
		if (_clauseId == "rule4") {
			require(onlyBy(buyer.id), "Caller not authorized");
			return true;
		}
		if (_clauseId == "rule5") {
			require(onlyBy(platform.id), "Caller not authorized");
			require(callSuccess(this.confirmGet.selector), "Action confirmGet did not occur");
			require(callCaller(this.confirmGet.selector) == buyer.id, "Party buyer did not confirmGet");
			require(onlyAfter(callTime(this.confirmGet.selector), 0, false), "Function called too early");
			return true;
		}
		return false;
	}

	function clauseFulfilledTime(bytes32 _clauseId) internal returns (uint) {
		uint max = 0;
		if (_clauseId == "rule1" && (callSuccess(this.confirmPurchase.selector))) {
			if (max < callTime(this.confirmPurchase.selector)) {
				max =  callTime(this.confirmPurchase.selector);
			}
			return max;
		}
		if (_clauseId == "rule2" && (callSuccess(this.delivery.selector))) {
			if (max < callTime(this.delivery.selector)) {
				max =  callTime(this.delivery.selector);
			}
			return max;
		}
		if (_clauseId == "rule3" && (callSuccess(this.confirmArrive.selector))) {
			if (max < callTime(this.confirmArrive.selector)) {
				max =  callTime(this.confirmArrive.selector);
			}
			return max;
		}
		if (_clauseId == "rule4" && (callSuccess(this.confirmGet.selector))) {
			if (max < callTime(this.confirmGet.selector)) {
				max =  callTime(this.confirmGet.selector);
			}
			return max;
		}
		if (_clauseId == "rule5" && (callSuccess(this.transfer2s.selector) && callSuccess(this.changeContract.selector))) {
			if (max < callTime(this.transfer2s.selector)) {
				max =  callTime(this.transfer2s.selector);
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
