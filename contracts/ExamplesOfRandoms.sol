pragma solidity ^0.4.21;

// code from https://medium.com/coinmonks/is-block-blockhash-block-number-1-okay-14a28e40cc4b

contract ExamplesOfRandoms {

    // ETHERBOTS
    function genRandom() public view returns (uint) {  // when production, need to be private
        uint rand = uint(keccak256(block.blockhash(block.number-1)));
        return uint(rand % (10 ** 20));
    }

    // CryptoFighters
    function randMod(uint256 _randCounter, uint _modulus) public view returns (uint256) {
        return uint(keccak256(now, msg.sender, _randCounter)) % _modulus;
    }

    // Ether Quest
    function getRandom2(uint256 _targetBlock, uint256 _heroIdentity) public view returns(uint256){
        uint256 hash = uint256(keccak256(block.blockhash(_targetBlock), _heroIdentity, block.coinbase, block.difficulty));
        return hash;
    }

    // Angel Battle
    function getRandomNumber(uint16 maxRandom, uint8 min, address privateAddress) public view returns(uint8) {
        uint256 genNum = uint256(block.blockhash(block.number-1)) + uint256(privateAddress);
        return uint8(genNum % (maxRandom - min + 1)+min);
    }

    // Etheremon — no real gaming mechanics, but:
    function getRandom(uint8 maxRan, uint8 index, address priAddress) public view returns(uint8) {
        uint256 genNum = uint256(block.blockhash(block.number-1)) + uint256(priAddress);
        for (uint8 i = 0; i < index && i < 6; i ++) {
            genNum /= 256;
        }
        return uint8(genNum % maxRan);
    }

}