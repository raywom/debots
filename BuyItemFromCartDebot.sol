pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import "base/Terminal.sol";
import "base/Menu.sol";
import "IShoppingList.sol";
import "Structs.sol";
import "BaseDebot.sol";

contract BuyItemFromCartDebot is BaseDebot {

    uint private purchaseId;

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
                MenuItem("Pay for the item","",tvm.functionId(buy)),
                MenuItem("Show items list","",tvm.functionId(showPurchases)),
                MenuItem("Delete item","",tvm.functionId(deletePurchase))
            ]
        );
    }

    function buy(uint32 index) public {
        Terminal.input(tvm.functionId(buy_), "Enter item id:", false);
    }

    function buy_(string value) public {
        (uint256 id, ) = stoi(value);
        purchaseId = id;
        Terminal.input(tvm.functionId(buy__), "Enter item price:", false);
    }

    function buy__(string value) public view {
        (uint256 price, ) = stoi(value);
        optional(uint256) pubkey = 0;
        IShoppingList(m_address).buy{
                abiVer: 2,
                extMsg: true,
                sign: true,
                pubkey: pubkey,
                time: uint64(now),
                expire: 0,
                callbackId: tvm.functionId(onSuccess),
                onErrorId: tvm.functionId(onError)
            }( uint(purchaseId),  uint(price));
    }
}