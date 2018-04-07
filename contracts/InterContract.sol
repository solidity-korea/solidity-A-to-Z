pragma solidity ^0.4.21;

contract A {

    address aAddress = this;  // this.balance will be deprecated from 0.4.21
    // or address(this).balance

    event Logging(address);
    event Logging(uint);

    function returnMsgSender() public view returns(address) {
        return msg.sender;
    }

    function returnThisAddress() public view returns(address) {
        return this;
    }

    function getBalance() public constant returns(uint) { return aAddress.balance; }


    uint256 public publicUint = 10;
    uint256 internal internalUint = 20;


    function getPublicUint() public view returns(uint256) {
        return publicUint;
    }

    function getInternalUint() public view returns(uint256) {
        return internalUint;
    }

    function getInternalUintInternal() internal view returns(uint256) {
        return internalUint;
    }

    string public publicString = "public String";

    function getPublicString() public view returns(string) {
        return publicString;
    }


    // uint256 external externalUint = 40; // can't declare variable as external, external only able as function
    uint256 public uintForExternal = 40;
    function externalFunction() external view returns(uint256) {
        return uintForExternal;
    }
    function getExternalFunction() public view returns(uint256) {
        // return externalFunction(); // error, need this.
        return this.externalFunction();  // not error, but expensive
    }
}

contract B {

    A public a;

    event Logging(string);

    function B(address _a) public {
        a = A(_a);
    }

    function callReturnMsgSender() public view returns(address) {
        return a.returnMsgSender();
    }

    function callReturnThisAddress() public view returns(address) {
        return a.returnThisAddress();
    }

    function getBalance() public constant returns(uint) { return address(this).balance; }

    function getPublicUint2() public view returns(uint256) {
        // return a.publicUint;  // error, variable can't be passed directly between contracts, need to use getter function
        return a.getPublicUint();
    }

    function getInternalUint() public view returns(uint256) {
        // return a.publicUint;  // error, variable can't be passed directly between contracts, need to use getter function
        return a.getInternalUint();
    }

    // function getInternalUintInternal() public view returns(uint256) {
    //     return a.getInternalUintInternal(); // error, internal function
    // }

    //  function getPublicString() public view returns(string) {
    //      return a.getPublicString(); // The problem is dynamic length string can't be passed between contracts
    //  }

    function callExternalFunction() public view returns(uint256) {
        return a.externalFunction();
    }


}