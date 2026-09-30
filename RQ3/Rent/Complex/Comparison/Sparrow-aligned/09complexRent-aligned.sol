pragma solidity >=0.7.0 <0.9.0;
contract complexRent
{
	uint256 public startTime = 970747200;
	uint256 public finishTime = 973425600;
	uint256 public payTime = 970747200;
	uint256 public period = 864000 ;
	uint256 public max_late = 432000 ;
	uint public late_days = 0 ;
	uint256 public breakIR = 200.0 ;
	uint public rent = 1000 ;
	uint public despoit = 500 ;
	bool public continueResult = false ;
	uint public continueDays = 0 ;
	bool public checkResult = false ;
	string public faultyParty = "" ;
	uint public compensation = 0 ;
	mapping(string => bool) public functionStatus;
	mapping(string => uint) public functionFinishTime;
	struct Person {
		string name;
		address payable account;
	}
	struct aaS {
		string name;
		address payable account;
	}
	struct caS {
		string name;
		address payable account;
		uint256 key;
		uint256 year;
	}
	struct raS {
		string name;
		address payable account;
	}
		struct token {
		   string   name ;
		   uint   price ;
		   uint   day ;
		   string   ownership ;
		   string   useRight ;
	}

	Person public lessor = Person("A", payable(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4));
	Person public lessee = Person("B", payable(0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2));
	aaS public aa = aaS("aa", payable(0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db));
	caS public ca = caS("ca", payable(0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db), 123, 3);
	raS public ra = raS("ra", payable(0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db));
	modifier onlylessor(){
		require(msg.sender == lessor.account,"Only lessor can access this.");
		 _;
	}
	modifier onlylessee(){
		require(msg.sender == lessee.account,"Only lessee can access this.");
		 _;
	}
	modifier onlyaa(){
		require(msg.sender == aa.account,"Only aa can access this.");
		 _;
	}
	modifier onlyca(){
		require(msg.sender == ca.account,"Only ca can access this.");
		 _;
	}
	modifier onlyra(){
		require(msg.sender == ra.account,"Only ra can access this.");
		 _;
	}
	token public thing = token("thing", 100, 30, "A", "A");
	constructor() {
	// Initialize the group
	}
	function giveUse() internal{
		thing.useRight=lessee.name;
	}
	function getUse() internal{
		thing.useRight=lessor.name;
	}
	function give() internal view returns (bool) {
		if (isDone("rule3")||isDone("rule4")) return true;
		else return false;
	}
	function rule1(bool _checkResult) public payable onlyca{
		checkResult = _checkResult;
		if(!isTime(startTime)){
			functionStatus["rule1"] = true;
			functionFinishTime["rule1"]=block.timestamp;
		}
	}
	function rule2() public payable onlylessee{
		if(!isTime(startTime)||isTrue(checkResult)){
			transferTo(lessor.account,10**14*rent+despoit);
			functionStatus["rule2"] = true;
			functionFinishTime["rule2"]=block.timestamp;
		}
	}
	function rule3() public payable onlylessor{
		if(isDone("rule2")||!isTime(startTime)){
			giveUse();
			functionStatus["rule3"] = true;
			functionFinishTime["rule3"]=block.timestamp;
		}
	}
	function rule4(uint _late_days) public payable onlylessor{
		late_days = _late_days;
		if(!isTime(startTime+max_late)||!isDone("rule3")){
			transferTo(lessee.account,10**14*rent*5*breakIR/1000);
			giveUse();
			functionStatus["rule4"] = true;
			functionFinishTime["rule4"]=block.timestamp;
		}
	}
	function rule5() public payable onlylessor{
		if(isTime(startTime+max_late)||!isDone("rule3")||!isDone("rule4")){
			transferTo(lessee.account,10**14*rent*5*breakIR/1000+rent+despoit);
			functionStatus["rule5"] = true;
			functionFinishTime["rule5"]=block.timestamp;
		}
	}
	function rule6() public payable onlylessee {
		if(give()||isTime(payTime+period)||!isTime(payTime+period+86400)||!isTime(finishTime)){
			transferTo(lessor.account,10**14*rent);
			payTime=payTime+period;
			functionStatus["rule8"]=true;
			functionStatus["rule6"] = true;
			functionFinishTime["rule6"]=block.timestamp;
		}
	}
	function rule7(uint _late_days) public payable onlylessee {
		late_days = _late_days;
		if(isTime(payTime+period+86400)||!isTime(payTime+period+432000)){
			transferTo(lessor.account,10**14*rent*late_days*breakIR/1000);
			payTime=payTime+period;
			functionStatus["rule8"]=true;
			functionStatus["rule7"] = true;
			functionFinishTime["rule7"]=block.timestamp;
		}
	}
	function rule8(uint _late_days) public payable onlylessor{
		late_days = _late_days;
		if(isTime(payTime+period+432000)){
			getUse();
			functionStatus["rule8"] = true;
			functionFinishTime["rule8"]=block.timestamp;
		}
	}
	function rule9(uint _continueDays) public payable onlylessee {
		continueDays = _continueDays;
		if(!isTime(finishTime)){
			transferTo(lessor.account,10**14*rent*continueDays);
			functionStatus["rule9"] = true;
			functionFinishTime["rule9"]=block.timestamp;
		}
	}
	function rule10(bool _continue) public payable onlylessor {
		continueResult = _continue;
		if(isDone("rule9")){
			if(isTrue(continueResult)){
				finishTime=finishTime+continueDays*60*60*24;
			}
			if(!isTrue(continueResult)){
				transferTo(lessee.account,10**14*rent*continueDays);
			}
			functionStatus["rule10"] = true;
			functionFinishTime["rule10"]=block.timestamp;
		}
	}
	function rule11() public payable onlylessor{
		if(isTime(finishTime)){
			getUse();
			transferTo(lessee.account,10**14*despoit);
			functionStatus["rule11"] = true;
			functionFinishTime["rule11"]=block.timestamp;
		}
	}
	function rule12() internal onlyra{
			functionStatus["rule12"] = true;
			functionFinishTime["rule12"]=block.timestamp;
	}
	function rule13() internal onlyra{
			functionStatus["rule13"] = true;
			functionFinishTime["rule13"]=block.timestamp;
	}
	function rule14() public payable onlylessee{
			functionStatus["rule14"] = true;
			functionFinishTime["rule14"]=block.timestamp;
	}
	function rule15() public payable onlylessor{
			functionStatus["rule15"] = true;
			functionFinishTime["rule15"]=block.timestamp;
	}
	function rule16(string memory _fault_party, uint _compensation) public payable onlyaa{
		faultyParty = _fault_party;
		compensation = _compensation;
		if(isDone("rule14")||isDone("rule15")){
			functionStatus["rule16"] = true;
			functionFinishTime["rule16"]=block.timestamp;
		}
	}
	function rule17_1() public payable onlylessor{
		if(compareStrings(faultyParty,lessor.name)){
			transferTo(lessee.account,10**14*compensation);
			functionStatus["rule17_1"] = true;
			functionFinishTime["rule17_1"]=block.timestamp;
		}
	}
	function rule17_2() public payable onlylessee{
		if(compareStrings(faultyParty,lessee.name)){
			transferTo(lessor.account,10**14*compensation);
			functionStatus["rule17_2"] = true;
			functionFinishTime["rule17_2"]=block.timestamp;
		}
	}
	// Check if a specific function has been executed
	function isDone(string memory functionName) internal view returns (bool) {
	    return functionStatus[functionName];
	}
	// Function to determine if the specified time has been reached
	function isTime(uint256 targetTime) internal view returns (bool) {
	    return block.timestamp >= targetTime;
	}
	// Function to check if the value is true.
	function isTrue(bool valueToCheck) internal pure returns (bool) {
	    return valueToCheck == true;
	}
	// Transfer to a specified address
	function transferTo(address payable recipient, uint amount) internal {
	    require(recipient != address(0), "Invalid recipient address");
	    require(amount > 0, "Amount must be greater than zero");
	    recipient.transfer(amount);
	}
	// Helper function to compare if two strings are equal
	function compareStrings(string memory a, string memory b) internal pure returns (bool) {
	    return (keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b)));
	}
}
