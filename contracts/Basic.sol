pragma solidity ^0.4.19;

contract Basic {
    address public owner;
    uint256 public a = 10;
    uint256 public b;  // default 0, when without initial 
    
    // sample function
    function helloWorld() public pure returns (string) {
        return 'HelloWorld!';
    }

    // sample function2
    function returnOwner() public view returns(address) {
        return owner;
    }
    
    // sample function3
    function returnAdd() public view returns(uint256) {
        return a + b;
    }

    // sample function4
    function internalFunction() internal returns(uint256) {
        return a ** b;
    }

    // sample function5
    function callInternal() public returns(uint256) {
        return internalFunction();
    }

    // sample Constructor
    function Basic() public {
        owner = msg.sender;
    }
    
    // sample event
    event Logging(string logs);

    // sample callback function
    function() public {
        string memory log = helloWorld();
        b = 5;
        Logging(log);  // emit Logging(log); from pragma solidity ^0.4.21
    }
}