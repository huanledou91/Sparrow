pragma solidity >=0.7.0 <0.9.0;
contract simpleRent
{
	uint256 public startTime = 970747200;
	uint256 public finishTime = 973425600;
	uint256 public payTime = 970747200;
	uint256 public period = 864000 ;
	uint public rent = 1000 ;
	uint public despoit = 500 ;
	uint public continueDays = 0 ;
	bool public continueResult = false ;
	mapping(string => bool) public functionStatus;
	mapping(string => uint) public functionFinishTime;
	struct Person {
		string name;
		address payable account;
	}
		struct token {
		   string   name ;
		   uint   price ;
		   uint   day ;
	}

	Person public lessor = Person("A", payable(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4));
	Person public lessee = Person("B", payable(0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2));
	modifier onlylessor(){
		require(msg.sender == lessor.account,"Only lessor can access this.");
		 _;
	}
	modifier onlylessee(){
		require(msg.sender == lessee.account,"Only lessee can access this.");
		 _;
	}
	token public House = token("thing", 100, 30);
	constructor() {
	// Initialize the group
	}
	function rule1() public payable onlylessee{
		if(!isTime(startTime)){
			transferTo(lessor.account,10**14*rent+despoit);
			functionStatus["rule1"] = true;
			functionFinishTime["rule1"]=block.timestamp;
		}
	}
	function rule2() public payable onlylessee {
		if(isDone("rule1")||isTime(payTime+period)||!isTime(payTime+period+86400)||!isTime(finishTime)){
			transferTo(lessor.account,10**14*rent);
			payTime=payTime+period;
			functionStatus["rule2"] = true;
			functionFinishTime["rule2"]=block.timestamp;
		}
	}
	function rule3(uint _continueDays) public payable onlylessee {
		continueDays = _continueDays;
		if(!isTime(finishTime)){
			transferTo(lessor.account,10**14*rent*continueDays);
			functionStatus["rule3"] = true;
			functionFinishTime["rule3"]=block.timestamp;
		}
	}
	function rule4(bool _continue) public payable onlylessor {
		continueResult = _continue;
		if(isDone("rule3")){
			if(isTrue(continueResult)){
				finishTime=finishTime+continueDays*60*60*24;
			}
			if(!isTrue(continueResult)){
				transferTo(lessee.account,10**14*rent*continueDays);
			}
			functionStatus["rule4"] = true;
			functionFinishTime["rule4"]=block.timestamp;
		}
	}
	function rule5() public payable onlylessor{
		if(isTime(finishTime)){
			transferTo(lessee.account,10**14*despoit);
			functionStatus["rule5"] = true;
			functionFinishTime["rule5"]=block.timestamp;
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
