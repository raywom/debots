pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import "base/Terminal.sol";
import "base/Menu.sol";
import "IShoppingList.sol";
import "Structs.sol";
import "BaseDebot.sol";

contract AddItemToCartDebot is BaseDebot {
    
    string private purchaseName;

    function _menu() internal override {
        string sep = '----------------------------------------';
        Menu.select(
            format(
                "You have {}/{} of paid items in total of {}",
                    m_summary.left,
                    m_summary.paid,
                    m_summary.total
            ),
            sep,
            [
                MenuItem("Add item","",tvm.functionId(addPurchase)),
                MenuItem("Show shopping list","",tvm.functionId(showPurchases)),
                MenuItem("Delete product","",tvm.functionId(deletePurchase))
            ]
        );
    }

    function addPurchase(uint32 index) public {
        Terminal.input(tvm.functionId(addPurchase_), "Enter item name:", false);
    }

    function addPurchase_(string value) public {
        purchaseName = value;
        Terminal.input(tvm.functionId(addPurchase__), "How many of it?", false);
    }

    function addPurchase__(string value) public  {
        (uint count, bool status) = stoi(value);
        optional(uint256) pubkey = 0;
        IShoppingList(m_address).addPurchase{
                abiVer: 2,
                extMsg: true,
                sign: true,
                pubkey: pubkey,
                time: uint64(now),
                expire: 0,
                callbackId: tvm.functionId(onSuccess),
                onErrorId: tvm.functionId(onError)
            }( purchaseName,  count);
    }
}