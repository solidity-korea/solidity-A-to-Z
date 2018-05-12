pragma solidity ^0.4.23;

contract A {

    uint256 [] public dynamicList;

    function push(uint256 _input) public {
        dynamicList.push(_input);
    }

    function returnList() public view returns (uint256[]) {
        return dynamicList;
    }
}

contract B {

    event Logging(uint256);
    A public a;
    //function B(address _a) public {
    constructor(address _a) public {
        a = A(_a);
    }

    function checkList() public {
        uint256[] memory test = a.returnList();
        for (uint256 i; i<test.length; i++) {
            emit Logging(test[i]);
        }
    }

}
