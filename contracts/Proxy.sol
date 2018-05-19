pragma solidity ^0.4.23;


contract SomeInterface {
    function someFunction(uint256 a) external returns(uint256);
}

contract ContractV1 is SomeInterface {
    function someFunction(uint256 a) external returns (uint256) {
        return a*2;
    }
}

contract ContractV2 is SomeInterface {
    function someFunction(uint256 a) external returns (uint256) {
        return a*5;
    }
}

contract ContractProxy {
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor() public {
        owner = msg.sender;
    }

    SomeInterface public targetContract;

    function setTarget(address _target) external onlyOwner {
        targetContract = SomeInterface(_target);
    }

    function someFunction(uint256 a) public returns (uint256){
        return targetContract.someFunction(a);
    }

}
// 결과를 저장하려면 getter, setter 가 있는 별도 storage contract 가 있어야함, 결과를 넘길 수 없으니