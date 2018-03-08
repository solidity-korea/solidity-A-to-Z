pragma solidity ^0.4.19;

contract Main {
  address public owner;
  
  // sample function
  function helloWorld() public pure returns (string) {
    return 'HelloWorld!';
  }

  // sample Constructor
  function Main() public {
    owner = msg.sender;
  }
  
  // sample event
  event Logging(string logs);

  // sample callback function
  function() public {
    string memory log = helloWorld();
    Logging(log);
  }
}
