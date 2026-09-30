pragma solidity >=0.4.22 <0.7.0;
pragma experimental ABIEncoderV2;
import "./lib/cml/ConditionalContract.sol";
import "./lib/cml/DateTime.sol";
import "./lib/cml/Model.sol";

contract ComplexPurchase is ConditionalContract {

	/*
	 * State variables
	 */
	Model.Party seller;
	Model.Party buyer;
	Model.Party platform;
	Model.Party ca;
	Model.Party aa;
	Model.Party ra;
	Model.Party court;
	uint value;
	uint giveTime;
	bool finalResult;
	uint lateIR;
	uint finishIR;
	bytes32 solutionS;
	bytes32 solutionB;
	bytes32 faultName;
	uint compensation;
	bool confirm;
	bool endContract;

	/*
	 * Constructor
	 */
	constructor(Model.Party memory _seller, Model.Party memory _buyer, Model.Party memory _platform, Model.Party memory _ca, Model.Party memory _aa, Model.Party memory _ra, Model.Party memory _court, uint _value, uint _giveTime, bool _finalResult, uint _lateIR, uint _finishIR)public {
		seller = _seller;
		buyer = _buyer;
		platform = _platform;
		ca = _ca;
		aa = _aa;
		ra = _ra;
		court = _court;
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

	modifier checkAllowedSetSolution() {
		require(contractObeyed());
		require(
			(onlyBy(buyer.id) && solutionB == "negotiation" && solutionS == "negotiation")
			|| onlyBy(court.id)
			|| onlyBy(aa.id),
			"Clause not allowed to start."
		);
		_;
		setCallContext();
	}

	modifier checkAllowedPayFaultB() {
		require(contractObeyed());
		require(
			onlyBy(buyer.id) && faultName == "buyer" &&
			(
				(callSuccess(this.confirmSolution.selector) && callCaller(this.confirmSolution.selector) == seller.id && onlyAfter(callTime(this.confirmSolution.selector), 0, false) && confirm)
				||
				(callSuccess(this.setSolution.selector) && callCaller(this.setSolution.selector) == court.id && onlyAfter(callTime(this.setSolution.selector), 0, false))
				||
				(callSuccess(this.setSolution.selector) && callCaller(this.setSolution.selector) == aa.id && onlyAfter(callTime(this.setSolution.selector), 0, false))
			),
			"Clause not allowed to start."
		);
		_;
		setCallContext();
	}

	modifier checkAllowedPayFaultS() {
		require(contractObeyed());
		require(
			onlyBy(seller.id) && faultName == "seller" &&
			(
				(callSuccess(this.confirmSolution.selector) && callCaller(this.confirmSolution.selector) == seller.id && onlyAfter(callTime(this.confirmSolution.selector), 0, false) && confirm)
				||
				(callSuccess(this.setSolution.selector) && callCaller(this.setSolution.selector) == court.id && onlyAfter(callTime(this.setSolution.selector), 0, false))
				||
				(callSuccess(this.setSolution.selector) && callCaller(this.setSolution.selector) == aa.id && onlyAfter(callTime(this.setSolution.selector), 0, false))
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
	function checkResult(bool result) public
		checkAllowed("rule1")
	{
		finalResult = result;
	}

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

	// @notice function for clause �cl.name�
	function pauseContract() public
		checkAllowed("rule14")
	{
		endContract = true;
	}

	// @notice function for clause �cl.name�
	function restartContract() public
		checkAllowed("rule15")
	{
		endContract = false;
	}

	// @notice function for clause �cl.name�
	function chooseSolutionB(bytes32 solution) public
		checkAllowed("rule16")
	{
		solutionB = solution;
	}

	// @notice function for clause �cl.name�
	function chooseSolutionS(bytes32 solution) public
		checkAllowed("rule17")
	{
		solutionS = solution;
	}

	// @notice function for clause �cl.name�
	function setSolution(bytes32 _faultName, uint _compensation) public
		checkAllowedSetSolution()
	{
		faultName = _faultName;
		compensation = _compensation;
	}

	// @notice function for clause �cl.name�
	function confirmSolution(bool _confirm) public
		checkAllowed("rule19")
	{
		confirm = _confirm;
	}

	// @notice function for clause �cl.name�
	function payFaultB() public
		checkAllowedPayFaultB()
	{
		seller.id.transfer(compensation);
	}

	// @notice function for clause �cl.name�
	function payFaultS() public
		checkAllowedPayFaultS()
	{
		buyer.id.transfer(compensation);
	}

	// Fallback function
	function() external payable {}

	function clauseAllowed(bytes32 _clauseId) internal returns (bool) {
		if (_clauseId == "rule1") {
			require(onlyBy(ca.id), "Caller not authorized");
			return true;
		}
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
		if (_clauseId == "rule14") {
			require(onlyBy(ra.id), "Caller not authorized");
			return true;
		}
		if (_clauseId == "rule15") {
			require(onlyBy(ra.id), "Caller not authorized");
			return true;
		}
		if (_clauseId == "rule16") {
			require(onlyBy(buyer.id), "Caller not authorized");
			return true;
		}
		if (_clauseId == "rule17") {
			require(onlyBy(seller.id), "Caller not authorized");
			return true;
		}
		if (_clauseId == "rule18") {
			require(onlyBy(buyer.id), "Caller not authorized");
			require(solutionB == "negotiation" && solutionS == "negotiation", "Given condition(s) not met");
			return true;
		}
		if (_clauseId == "rule19") {
			require(onlyBy(seller.id), "Caller not authorized");
			return true;
		}
		if (_clauseId == "rule20_1") {
			require(onlyBy(buyer.id), "Caller not authorized");
			require(callSuccess(this.confirmSolution.selector), "Action confirmSolution did not occur");
			require(callCaller(this.confirmSolution.selector) == seller.id, "Party seller did not confirmSolution");
			require(onlyAfter(callTime(this.confirmSolution.selector), 0, false), "Function called too early");
			require(confirm && faultName == "buyer", "Given condition(s) not met");
			return true;
		}
		if (_clauseId == "rule20_2") {
			require(onlyBy(seller.id), "Caller not authorized");
			require(callSuccess(this.confirmSolution.selector), "Action confirmSolution did not occur");
			require(callCaller(this.confirmSolution.selector) == seller.id, "Party seller did not confirmSolution");
			require(onlyAfter(callTime(this.confirmSolution.selector), 0, false), "Function called too early");
			require(confirm && faultName == "seller", "Given condition(s) not met");
			return true;
		}
		if (_clauseId == "rule21") {
			require(onlyBy(court.id), "Caller not authorized");
			return true;
		}
		if (_clauseId == "rule22_1") {
			require(onlyBy(buyer.id), "Caller not authorized");
			require(callSuccess(this.setSolution.selector), "Action setSolution did not occur");
			require(callCaller(this.setSolution.selector) == court.id, "Party court did not setSolution");
			require(onlyAfter(callTime(this.setSolution.selector), 0, false), "Function called too early");
			require(faultName == "buyer", "Given condition(s) not met");
			return true;
		}
		if (_clauseId == "rule22_2") {
			require(onlyBy(seller.id), "Caller not authorized");
			require(callSuccess(this.setSolution.selector), "Action setSolution did not occur");
			require(callCaller(this.setSolution.selector) == court.id, "Party court did not setSolution");
			require(onlyAfter(callTime(this.setSolution.selector), 0, false), "Function called too early");
			require(faultName == "seller", "Given condition(s) not met");
			return true;
		}
		if (_clauseId == "rule23") {
			require(onlyBy(aa.id), "Caller not authorized");
			return true;
		}
		if (_clauseId == "rule24_1") {
			require(onlyBy(buyer.id), "Caller not authorized");
			require(callSuccess(this.setSolution.selector), "Action setSolution did not occur");
			require(callCaller(this.setSolution.selector) == aa.id, "Party aa did not setSolution");
			require(onlyAfter(callTime(this.setSolution.selector), 0, false), "Function called too early");
			require(faultName == "buyer", "Given condition(s) not met");
			return true;
		}
		if (_clauseId == "rule24_2") {
			require(onlyBy(seller.id), "Caller not authorized");
			require(callSuccess(this.setSolution.selector), "Action setSolution did not occur");
			require(callCaller(this.setSolution.selector) == aa.id, "Party aa did not setSolution");
			require(onlyAfter(callTime(this.setSolution.selector), 0, false), "Function called too early");
			require(faultName == "seller", "Given condition(s) not met");
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
		if (_clauseId == "rule14" && (callSuccess(this.pauseContract.selector))) {
			if (max < callTime(this.pauseContract.selector)) {
				max =  callTime(this.pauseContract.selector);
			}
			return max;
		}
		if (_clauseId == "rule15" && (callSuccess(this.restartContract.selector))) {
			if (max < callTime(this.restartContract.selector)) {
				max =  callTime(this.restartContract.selector);
			}
			return max;
		}
		if (_clauseId == "rule16" && (callSuccess(this.chooseSolutionB.selector))) {
			if (max < callTime(this.chooseSolutionB.selector)) {
				max =  callTime(this.chooseSolutionB.selector);
			}
			return max;
		}
		if (_clauseId == "rule17" && (callSuccess(this.chooseSolutionS.selector))) {
			if (max < callTime(this.chooseSolutionS.selector)) {
				max =  callTime(this.chooseSolutionS.selector);
			}
			return max;
		}
		if (_clauseId == "rule18" && (callSuccess(this.setSolution.selector))) {
			if (max < callTime(this.setSolution.selector)) {
				max =  callTime(this.setSolution.selector);
			}
			return max;
		}
		if (_clauseId == "rule19" && (callSuccess(this.confirmSolution.selector))) {
			if (max < callTime(this.confirmSolution.selector)) {
				max =  callTime(this.confirmSolution.selector);
			}
			return max;
		}
		if (_clauseId == "rule20_1" && (callSuccess(this.payFaultB.selector))) {
			if (max < callTime(this.payFaultB.selector)) {
				max =  callTime(this.payFaultB.selector);
			}
			return max;
		}
		if (_clauseId == "rule20_2" && (callSuccess(this.payFaultS.selector))) {
			if (max < callTime(this.payFaultS.selector)) {
				max =  callTime(this.payFaultS.selector);
			}
			return max;
		}
		if (_clauseId == "rule21" && (callSuccess(this.setSolution.selector))) {
			if (max < callTime(this.setSolution.selector)) {
				max =  callTime(this.setSolution.selector);
			}
			return max;
		}
		if (_clauseId == "rule22_1" && (callSuccess(this.payFaultB.selector))) {
			if (max < callTime(this.payFaultB.selector)) {
				max =  callTime(this.payFaultB.selector);
			}
			return max;
		}
		if (_clauseId == "rule22_2" && (callSuccess(this.payFaultS.selector))) {
			if (max < callTime(this.payFaultS.selector)) {
				max =  callTime(this.payFaultS.selector);
			}
			return max;
		}
		if (_clauseId == "rule23" && (callSuccess(this.setSolution.selector))) {
			if (max < callTime(this.setSolution.selector)) {
				max =  callTime(this.setSolution.selector);
			}
			return max;
		}
		if (_clauseId == "rule24_1" && (callSuccess(this.payFaultB.selector))) {
			if (max < callTime(this.payFaultB.selector)) {
				max =  callTime(this.payFaultB.selector);
			}
			return max;
		}
		if (_clauseId == "rule24_2" && (callSuccess(this.payFaultS.selector))) {
			if (max < callTime(this.payFaultS.selector)) {
				max =  callTime(this.payFaultS.selector);
			}
			return max;
		}
		return max;
	}

	function contractObeyed() internal returns (bool) {
		return true;
	}

}
