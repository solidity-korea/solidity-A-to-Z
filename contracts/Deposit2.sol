pragma solidity ^0.4.21;

// code of openzeppelin
// library SafeMath {

//   /**
//   * @dev Multiplies two numbers, throws on overflow.
//   */
//   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
//     if (a == 0) {
//       return 0;
//     }
//     uint256 c = a * b;
//     assert(c / a == b);
//     return c;
//   }

//   /**
//   * @dev Integer division of two numbers, truncating the quotient.
//   */
//   function div(uint256 a, uint256 b) internal pure returns (uint256) {
//     // assert(b > 0); // Solidity automatically throws when dividing by 0
//     uint256 c = a / b;
//     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
//     return c;
//   }

//   /**
//   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
//   */
//   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
//     assert(b <= a);
//     return a - b;
//   }

//   /**
//   * @dev Adds two numbers, throws on overflow.
//   */
//   function add(uint256 a, uint256 b) internal pure returns (uint256) {
//     uint256 c = a + b;
//     assert(c >= a);
//     return c;
//   }
// }

import "github.com/OpenZeppelin/zeppelin-solidity/contracts/math/SafeMath.sol";

contract Deposit {
  using SafeMath for uint256;

  mapping (address => uint256) balances;
  
  // callback 함수로서 payable 하여 Account가 ETH 를 전송하면 Contract 에 Deposit 하는 함수
  function() public payable {
    // 전송한 ETH(Wei) 양이 0 보다 커야 하는 조건
    // payable 을 통해 받은 ETH(Wei) 를 balances 에 저장 ( 각 account 별로 따로 )
    require(msg.value > 0);
    balances[msg.sender] = balances[msg.sender].add(msg.value);
  }
  
  // Doposit 한 Account 가 자신의 Deposit 양을 리턴하는 view 함수
  function myBalance() public view returns(uint256) {
    return balances[msg.sender];
  }

  // 모든 Account 가 Deposit 한 총 ETH(Wei)의 양을 리턴하는 view 함수 
  function totalDepositAmount() public view returns(uint256) {
    // this.balance 사용 -> 0.4.21 부터 this 를 address 로 명시적 형변환 필요 address(this).*
    return address(this).balance;
  }
  
  // 해당 함수를 호출한 Account 의 Deposit ETH(Wei)를 모두 다시 Account 에게 돌려주는 함수
  // address.send(value); 함수 사용
  function claim() public {
    // 해당 Account 가 Deposit 한 양이 0 보다 커야하는 조건
    require(balances[msg.sender] > 0);
    // require(address(this).balance >= balances[msg.sender]);  // optional, 어차피 send 에서 revert 됨
    
    // send 전 balances[msg.sender] 를 미리 감소시키는게 로직 상 안전하다.
    uint256 claimValue = balances[msg.sender];
    balances[msg.sender] = 0;
    
    // address.send() 의 경우 실패시 false 반환, require 와 함께 써서 실패시 revert 처리 가능
    require(msg.sender.send(claimValue));  
  }
}
