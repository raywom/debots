pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;
pragma AbiHeader pubkey;
pragma AbiHeader time;

import "IShoppingList.sol";
import "HasConstructorWithPubkey.sol";
import "Structs.sol";

contract ShoppingList is IShoppingList, HasConstructorWithPubkey {

    uint256 private owner;

    mapping(uint256 => Purchase) private purchases;
    uint256 private firstAvaliableId = 0;
    Summary private summary;

    constructor(uint256 pubkey) HasConstructorWithPubkey(pubkey) public {
        require(pubkey != 0, 120);
        tvm.accept();
        owner = pubkey;
    }

    modifier onlyOwner {
        require(msg.pubkey() == owner, 101);
        _;
    }

    function getPurchaseList() external override view returns(Purchase[] purchasesList) {
        for ((uint id, Purchase purchase) : purchases){
            purchasesList.push(purchase);
        }
        return purchasesList;
    }

    function getSummary() external override returns(Summary) {
        tvm.accept();
        return summary;
    }

    function addPurchase(string name, uint amount) external override onlyOwner {
        tvm.accept();
        Purchase newPurchase = Purchase({
            id: firstAvaliableId,
            name: name,
            amount: amount,
            createdAt: now,
            isPurchased: false,
            cost: 0
        });
        summary.left++;
        purchases[firstAvaliableId] = newPurchase;
        firstAvaliableId++;
    }

    function removePurchase(uint id) external override onlyOwner {
        require(purchases.exists(id), 102);
        tvm.accept();
        delete purchases[id];
    }

    function buy(uint id, uint price) external override onlyOwner {
        tvm.accept();
        require(purchases.exists(id), 102);
        require(!purchases[id].isPurchased, 105);
        purchases[id].isPurchased = true;
        purchases[id].cost = price;

        summary.paid++;
        summary.left--;
        summary.total += price; 
    }
}