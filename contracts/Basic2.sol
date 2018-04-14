pragma solidity ^0.4.21;

contract Basic2 {
    uint[] intList = [1,2,3];  // uint == uint256
    
    function getIntList(uint _index) public view returns(uint) {
        return intList[_index];
    }

    function getIntListLength() public view returns(uint) {
        return intList.length;
    }
    
    uint[] intListDynamic;
    event Logging(uint[]);
    
    function getIntListDynamicLength() public view returns(uint) {
        return intListDynamic.length;
    }
    
    function pushIntListDynamic(uint _input) public {
        intListDynamic.push(_input);
        emit Logging(intListDynamic);
    }
    
    function getIntListDynamic(uint _index) public view returns(uint) {
        return intListDynamic[_index];
    }
    
    // function listInLocal(uint _input) public view returns(uint[]) {
    //     uint[] intListDynamicLocal;
    //     intListDynamicLocal.push(_input);
    //     return intListDynamicLocal;
    // }
    
    
    event Logging(uint);
    function forStatement1(uint _input) public returns(uint _length) {
        for (uint i = 0; i < _input; i++) {
            intListDynamic.push(i);
            emit Logging(i);
        }
        emit Logging(intListDynamic);
        return intListDynamic.length;
    }
    
    function whileStatement1(uint _a, uint _b) public pure returns(uint) {
        uint result = 0;
        while (_b != 0) {
            result += _a;
            _b--;
        }
        return result;
    }

    struct Note {
        uint time; // time of start burrow
        string text;
        address writer;
    }

    Note[] noteList;
    event Logging(Note);
    function addNote(string _text) public returns(uint _length) {
        Note memory note = Note({  // struct, array, mapping 를 local 에 선언하려면 memory 에 저장하겠다고 명시적 표기가 필요
            time: uint(now), // now == block.timestamp
            text: _text,
            writer: msg.sender
        });
        noteList.push(note);
        emit Logging(note);
        return noteList.length;
    }
    
    function getNote(uint _index) public view returns(uint _time, string _text, address _writer) {
        return (noteList[_index].time, noteList[_index].text, noteList[_index].writer);
    }
  
}