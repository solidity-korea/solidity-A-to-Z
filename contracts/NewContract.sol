pragma solidity ^0.4.23;

/* from https://www.toshblocks.com/solidity/creating-contracts-via-new-operator */

// lets define a simple contract D with payable modifier
contract D {
    uint public x;
    // function D(uint a) payable {
    constructor(uint a) payable public {
        x = a;
    }

}


contract C {
    // this is how you can create a contract using new keyword
    D public d = new D(4);
    // this above line will be executed as part of C's constructor

    function viewD() public view returns (uint) {
        return d.x();
    }
    // you can also create a contract which is already defined inside a function like this
    function createD(uint arg) public returns (address){
        D newD = new D(arg);
        return newD;
    }

}
