pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;
struct Purchase{
    uint256 id;
    string name;
    uint256 amount;
    uint64 createdAt;
    bool isPurchased;
    uint256 cost;
}
struct Summary{
    uint256 paid;
    uint256 left;
    uint256 total;
}