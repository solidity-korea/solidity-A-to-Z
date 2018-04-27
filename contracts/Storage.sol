pragma solidity ^0.4.18;

contract Storage {
    uint[10] public x;

    function callWithNoting() public {  // need view
        withNothing(x);
    }

    function callWithMemory() public {
        withMemory(x);
    }

    function callWithStorage() public {
        withStorage(x);
    }

    // call of value, copy
    function withNothing(uint[10] xPointer) internal {  // need pure
        xPointer[2] = 1;
    }

    // get x as call of reference using storage xPointer
    function withMemory(uint[10] memory xPointer) internal {
        xPointer[2] = 2;
    }

    // get x as call of reference using storage xPointer
    function withStorage(uint[10] storage xPointer) internal {  // can't public with storage
        xPointer[2] = 3;
    }
}

contract Betting is Ownable{

    enum BettingStatus {Ongoing, Closed, Claimed}


    struct betting {
        uint256 id;
        uint256 startTime;
        uint256 closeTime;
        uint256 bettedAmount;
        uint256 targetAmount;
        uint256 block;
        BettingStatus status;
    }

    betting[] public bettings;

    address owner;
    uint numberMax;

    function addBetting() public {
        bettings.push(betting(bettings.length, now, now+600, 0, 0, block.number, BettingStatus.Ongoing));
    }

    function test(uint _index) public returns (uint, uint){
        uint tmp;
        for (uint i=0; i< bettings[_index].id; i++){
            tmp += 1;
        }
        return (bettings[_index].id, tmp);
    }

    function test2(uint _index) public returns (uint, uint){
        betting storage bet = bettings[_index];
        uint tmp;
        for (uint i=0; i< bet.id; i++){
            tmp += 1;
        }
        return (bet.id, tmp);
    }
}