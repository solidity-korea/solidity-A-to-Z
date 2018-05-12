pragma solidity ^0.4.23;

/* from https://www.toshblocks.com/solidity/creating-contracts-via-new-operator/
* @title Example the for Solidity Course
* @author Ethereum Community
* @updated by dongsamb
*/

// A contract can create a new contract using the new keyword.
// The full code of the contract being created has to be known in advance,
// so recursive creation-dependencies are not possible.

// lets define a simple contract D with payable modifier
contract D {
    uint public x;
    // function D(uint a) payable {
    constructor(uint a) payable public {
        x = a;
    }

    function viewBalance() view public returns (uint256) {
        return address(this).balance;
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

    // You can also create a conract and at the same time transfer some ethers to it.
    function createAndEndowD(uint arg, uint amount) public returns (address){
        // Send ether along with the creation of the contract
        D newD = (new D).value(amount)(arg);
        return newD;
    }
}