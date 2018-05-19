pragma solidity ^0.4.23;
// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md

interface EIP165Example {
  function hello() external pure;
  function world(uint256) external pure;
}

contract Selector {
  event Logging(bytes4);
  EIP165Example i;
  function calculateSelector() public view returns (bytes4) {
    return i.hello.selector ^ i.world.selector;
  }

  function returnHelloSelector() public view returns (bytes4) {
    return i.hello.selector;
  }

  function returnWorldSelector() public view returns (bytes4) {
    return i.world.selector;
  }

  function returnHelloHash() public pure returns (bytes4) {
    return bytes4(keccak256('hello()'));
  }

  function returnWorldHash() public pure returns (bytes4) {
    return bytes4(keccak256('world(uint256)'));
  }
}