pragma solidity ^0.4.19;

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
    OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

}


contract Inheritance is Ownable {
    string public name = "Inheritance";
}



contract ChangeName is Ownable{
    string public name = "ChangeName";

    function changeName(string _name) public onlyOwner {
        name = _name;
    }
}

contract Inheritance2 is Inheritance, ChangeName {

}

contract Inheritance3 is ChangeName, Inheritance {
    
}

contract Inheritance4 is ChangeName, Inheritance {
    string public name = "Inheritance4";
}