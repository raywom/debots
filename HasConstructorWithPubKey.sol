pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

abstract contract HasConstructorWithPubkey { 
    constructor(uint pubkey) public { }
}