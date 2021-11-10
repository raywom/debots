pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "Structs.sol";

interface IShoppingList {
    function getPurchaseList() external view returns(Purchase[] purchases);
    function getSummary() external returns(Summary summary);
    function addPurchase(string name, uint amount) external;
    function removePurchase(uint id) external;
    function buy(uint id, uint price) external;
}