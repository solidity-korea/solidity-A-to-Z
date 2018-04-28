pragma solidity ^0.4.21;
// https://github.com/wikibook/blockchain-solidity/blob/master/chap6/6.4.2.sol

contract RandomNumber {
    address owner;
    uint numberMax;

    struct draw {
        // (1) 예약할 때 마지막 블록 번호만 유지
        uint blockNumber;
    }

    struct draws {
        uint numDraws;
        mapping (uint => draw) draws;
    }

    mapping (address => draws) requests;

    // (2) request()의 반환 값 참조용 이벤트에 정의
    event ReturnNextIndex(uint _index);

    function RandomNumber(uint _max) {
        owner = msg.sender;
        numberMax = _max;
    }

    function request() returns (uint) {
        uint _nextIndex = requests[msg.sender].numDraws;
        requests[msg.sender].draws[_nextIndex].blockNumber = block.number;
        requests[msg.sender].numDraws = _nextIndex + 1;
        ReturnNextIndex(_nextIndex);
        return _nextIndex;
    }

    // (3) 난수 값 계산 결과를 저장하지 않게끔 변경하고 constant 함수로 변경
    function get(uint _index) public view returns (int status_, bytes32 blockhash_, uint drawnNumber_){
        if(_index >= requests[msg.sender].numDraws){
            return (-2, 0, 0);
        }else{
            uint _nextBlockNumber = requests[msg.sender].draws[_index]. blockNumber + 1;
            if (_nextBlockNumber >= block.number) {
                return (-1, 0, 0);
            }
            else{
                // (4) 매번 블록 번호로부터 블록 해시를 참조해 반환
                bytes32 _blockhash = block.blockhash(_nextBlockNumber);  // blocks - deprecated in version 0.4.22 and replaced by blockhash(uint blockNumber).
                uint drawnNumber = uint(_blockhash) % numberMax + 1;
                return (0, _blockhash, drawnNumber);
            }
        }
    }
}
