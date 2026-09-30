pragma solidity >=0.4.0 <0.6.0;

import "./SellerT.sol";
import "./BuyerT.sol";
import "./PlatformT.sol";
contract regularPurchase {

	SellerT Seller;
	BuyerT Buyer;
	PlatformT Platform;

	contractInfo info1;
	uint lateIR;
	uint finishIR;

	struct contractInfo{
		uint giveDate;
		uint Price;
	}

	function regularPurchase(){
		Seller = new SellerT();
		Buyer = new BuyerT();
		Platform = new PlatformT();
	}

	modifier onlySeller{
		require(msg.sender == Seller.getAddress());
		_;
	}

	modifier onlyBuyer{
		require(msg.sender == Buyer.getAddress());
		_;
	}

	modifier onlyPlatform{
		require(msg.sender == Platform.getAddress());
		_;
	}

	modifier no2Modifier{
		require(now < info1.giveDate && now > Buyer.confirmBuyTime());
		_;
	}

	modifier no3Modifier{
		require(now > Seller.deliveryTime() || now > Seller.suspendDelivery1Time());
		_;
	}

	modifier no4Modifier{
		require((now > Platform.confirmArriveTime()) &&(now < Platform.confirmArriveTime()+1296000));
		_;
	}

	modifier no5Modifier{
		require(now > Buyer.confirmGetTime());
		_;
	}

	modifier no6Modifier{
		require(now > Platform.confirmArriveTime()+1296000);
		_;
	}

	modifier no7Modifier{
		require((now > info1.giveDate && now > Buyer.confirmBuyTime()) &&(now < info1.giveDate + 432000));
		_;
	}

	modifier no8Modifier{
		require(now > info1.giveDate + 432000 && now > Buyer.confirmBuyTime());
		_;
	}

	modifier no9Modifier{
		require(now > Seller.suspendDelivery2Time());
		_;
	}

	modifier no12Modifier{
		require(now > Buyer.endSale2Time() || now > Seller.endSale1Time());
		_;
	}

	function confirmBuy() onlyBuyer() public payable {
		//USER CODE HERE
		Platform.setamount(Platform.getamount() + info1.Price);
		Buyer.confirmBuyDone();
		//CHECK

	}

	function delivery() onlySeller() no2Modifier() public {
		//USER CODE HERE
		Seller.deliveryDone();
		//CHECK

	}

	function confirmArrive() onlyPlatform() no3Modifier() public {
		//USER CODE HERE
		Platform.confirmArriveDone();
		//CHECK

	}

	function confirmGet() onlyBuyer() no4Modifier() public {
		//USER CODE HERE
		Buyer.confirmGetDone();
		//CHECK

	}

	function endSale31() onlyPlatform() no5Modifier() public payable {
		//USER CODE HERE
		Seller.setamount(Seller.getamount() + info1.Price);
		//CHECK

	}

	function endSale32() onlyPlatform() no6Modifier() public payable {
		//USER CODE HERE
		Seller.setamount(Seller.getamount() + info1.Price);
		//CHECK

	}

	function suspendDelivery1(uint lateDays) onlySeller() no7Modifier() public payable {
		//USER CODE HERE
		Buyer.setamount(Buyer.getamount() + info1.Price * lateIR);
		Seller.suspendDelivery1Done();
		//CHECK

	}

	function suspendDelivery2() onlySeller() no8Modifier() public payable {
		//USER CODE HERE
		Buyer.setamount(Buyer.getamount() + info1.Price * lateIR);
		Seller.suspendDelivery2Done();
		//CHECK

	}

	function endSale33() onlyPlatform() no9Modifier() public payable {
		//USER CODE HERE
		Buyer.setamount(Buyer.getamount() + info1.Price);
		//CHECK

	}

	function endSale2() onlyBuyer() public payable {
		//USER CODE HERE
		Seller.setamount(Seller.getamount() + info1.Price * finishIR);
		Buyer.endSale2Done();
		//CHECK

	}

	function endSale1() onlySeller() public payable {
		//USER CODE HERE
		Buyer.setamount(Buyer.getamount() + info1.Price * finishIR);
		Seller.endSale1Done();
		//CHECK

	}

	function endSale34() onlyPlatform() no12Modifier() public payable {
		//USER CODE HERE
		Buyer.setamount(Buyer.getamount() + info1.Price);
		//CHECK

	}

}
