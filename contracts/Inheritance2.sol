pragma solidity 0.4.21;

// code of openzeppelin

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
    address public owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    function Ownable() public {
        owner = msg.sender;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

}


contract Inheritance is Ownable {
    string public name = "Inheritance";
    string private privateValue;

    function Inheritance(string _privateValue) public {
        privateValue = _privateValue;
    }

    uint256 public publicUint = 10;
    uint256 internal internalUint = 20;
    string internalValue = "internalValue";  // default visibility of variable is internal
    uint256 private privateUint = 30;

    function getPrivateValue() private view returns(string) {
        return privateValue;
    }

    function callGetPrivateValue() public view returns(string) {
        return getPrivateValue();
    }

    function getInternalUint() public view returns(uint256) {
        return internalUint;
    }
}

contract Inheritance2 is Inheritance {

    // 상속받은 부모 contract 에 constructor 가 있다면, 부모의 constructor 를 호출하는 자식 constructor 를 작성해야 한다.
    function Inheritance2(string _privateValue) public Inheritance(_privateValue){
        internalUint = 50;
        // privateValue = "private value from inheritance2";  // error
    }

    function getPublicUint() public view returns(uint256) {
        return publicUint;
    }

    function getInternalUint2() public view returns(uint256) {
        return internalUint;
    }

    function getInternalUint3() public pure returns(uint256) {
        return Inheritance.internalUint;
    }

    // function getPrivateUint() public view returns(uint256) {
    //     return privateUint; // error, private
    // }
}
