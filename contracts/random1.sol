pragma solidity ^0.4.21;


contract GlobalVariables {
    function getBlockInfo() public view returns(address _coinbase, uint _difficulty, uint _gasLimit, uint _number, uint _timestamp, uint _now) {
        return (block.coinbase, block.difficulty, block.gaslimit, block.number, block.timestamp, now);
    }

    address public initialCoinbase;
    uint public initialDifficulty;
    uint public initialGasLimit;
    uint public initialBlockNumber;
    uint public initialBlockTimestamp;
    uint public initialNow;

    function GlobalVariables() public { // fallback function
        (initialCoinbase, initialDifficulty, initialGasLimit, initialBlockNumber, initialBlockTimestamp, initialNow)  = getBlockInfo();
    }
}


// https://github.com/wikibook/blockchain-solidity/blob/master/chap6/6.2.2.sol
contract BlockHashTest {
    event Logging(bytes32);
    event Logging(uint);
    function getBlockHash(uint _blockNumber) public view returns (uint blockNumber_, bytes32 blockhash_, uint blockhashToNumber_){
        if (_blockNumber == 0){
            _blockNumber = block.number-1;
        }
        bytes32 _blockhash = block.blockhash(_blockNumber); // // blocks - deprecated in version 0.4.22 and replaced by blockhash(uint blockNumber).
        uint _blockhashToNumber = uint(_blockhash);
        emit Logging(_blockNumber);
        emit Logging(_blockhash);
        return (_blockNumber, _blockhash, _blockhashToNumber);
    }
}

// https://github.com/wikibook/blockchain-solidity/blob/master/chap6/6.2.2.sol
contract RandomNumber {
    function get(uint max) public view returns (uint, uint) {
        uint block_timestamp = block.timestamp;
        uint mod = block_timestamp % max + 1;
        return (block_timestamp, mod);
    }
}