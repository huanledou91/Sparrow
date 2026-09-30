pragma solidity >=0.4.0 <0.6.0;

import "./SellerT.sol";
import "./BuyerT.sol";
import "./PlatformT.sol";
contract simplePurchase {

	SellerT Seller;
	BuyerT Buyer;
	PlatformT Platform;

	contractInfo info1;

	struct contractInfo{
		uint giveDate;
		uint Price;
	}

	function simplePurchase(){
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

	modifier no1Modifier{
		require(now < info1.giveDate);
		_;
	}

	modifier no2Modifier{
		require(now < info1.giveDate && now > Buyer.confirmBuyTime());
		_;
	}

	modifier no3Modifier{
		require(now > Seller.deliveryTime());
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

	function confirmBuy() onlyBuyer() no1Modifier() public payable {
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

}
