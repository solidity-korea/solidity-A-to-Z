pragma solidity ^0.4.19;

contract inheritance {
    mapping(address => uint256) public myNumbers;
    uint256 public numberCount;

    function setMyNumber(uint256 _myNumber) public {
        if (myNumbers[msg.sender] == 0) {
            numberCount += 1;
        }
        myNumbers[msg.sender] = _myNumber;
    }

    function getMyNumber() public view returns(uint256 _myNumber) {
        return myNumbers[msg.sender];
    }

    function getOtherNumber(address _address) public view returns(uint256 _myNumber) {
        return myNumbers[_address];
    }
    
    modifier checkNumber() {
        require(myNumbers[msg.sender] != 0);
        _;
    }
    
    function deleteNumber() public checkNumber {
        myNumbers[msg.sender] = 0;
        numberCount -= 1;
    }
}
