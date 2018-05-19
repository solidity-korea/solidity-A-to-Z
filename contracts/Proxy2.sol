pragma solidity ^0.4.23;


contract SomeInterface {
    StorageContract public storageContract;
    constructor(address _storageAddr) public {
        storageContract = StorageContract(_storageAddr);
    }
    function someFunction(uint256 a) external returns(uint256);
}

contract ContractV1 is SomeInterface {
    constructor(address _storageAddr) public SomeInterface(_storageAddr) {}
    function someFunction(uint256 a) external returns (uint256) {
        storageContract.setFunction(a*2);
    }
}

contract ContractV2 is SomeInterface {
    constructor(address _storageAddr) public SomeInterface(_storageAddr) {}
    function someFunction(uint256 a) external returns (uint256) {
        storageContract.setFunction(a*5);
    }
}

contract StorageContract {

    uint256[] public dataList;

    function getFunction() public view returns(uint256) {
        return dataList[dataList.length-1];
    }

    function setFunction(uint256 _value) public {
        dataList.push(_value);
    }

    function getLength() public view returns(uint256) {
        return dataList.length;
    }

    function getDataList() public view returns(uint256[]){
        return dataList;
    }

}

contract ContractProxy {
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    SomeInterface public targetContract;
    StorageContract public storageContract;

    constructor() public {
        owner = msg.sender;
        storageContract = new StorageContract();
    }


    function setTarget(address _target) external onlyOwner {
        targetContract = SomeInterface(_target);
    }

    function someFunction(uint256 a) public returns (uint256){
        return targetContract.someFunction(a);
    }

    function getDataList() public view returns(uint256[]){
        return storageContract.getDataList();
    }

}