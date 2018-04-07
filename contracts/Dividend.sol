pragma solidity ^0.4.19;

/**
 * Math operations with safety checks
 */
library SafeMath {
  function mul(uint a, uint b) internal returns (uint) {
    uint c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint a, uint b) internal returns (uint) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint a, uint b) internal returns (uint) {
    assert(b <= a);
    return a - b;
  }

  function add(uint a, uint b) internal returns (uint) {
    uint c = a + b;
    assert(c >= a);
    return c;
  }

  function max64(uint64 a, uint64 b) internal constant returns (uint64) {
    return a >= b ? a : b;
  }

  function min64(uint64 a, uint64 b) internal constant returns (uint64) {
    return a < b ? a : b;
  }

  function max256(uint256 a, uint256 b) internal constant returns (uint256) {
    return a >= b ? a : b;
  }

  function min256(uint256 a, uint256 b) internal constant returns (uint256) {
    return a < b ? a : b;
  }

  function assert(bool assertion) internal {
    if (!assertion) {
      throw;
    }
  }
}


contract Dvidend {
  using SafeMath for uint;
  uint public pointMultiplier = 10e18;
  
  struct Account {
    uint balance;
    uint lastDividendPoints;
    uint cash;
  }
  mapping(address=>Account) accounts;
  uint public totalSupply;
  uint public totalSupplyCash;
  uint public totalDividendPoints;
  uint public unclaimedDividends;

  function dividendsOwing(address account) internal returns(uint) {
    var newDividendPoints = totalDividendPoints.sub(accounts[account].lastDividendPoints);
    return (accounts[account].balance.mul(newDividendPoints).div(pointMultiplier));
  }
  modifier updateAccount(address account) {
    var owing = dividendsOwing(account);
    if(owing > 0) {
      unclaimedDividends = unclaimedDividends.sub(owing);
      accounts[account].cash = accounts[account].cash.add(owing);
      accounts[account].lastDividendPoints = totalDividendPoints;
    }
    _;
  }
  function disburse(uint amount) public {
    totalDividendPoints = totalDividendPoints.add(amount.mul(pointMultiplier).div(totalSupply));
    totalSupplyCash = totalSupplyCash.add(amount);
    unclaimedDividends = unclaimedDividends.add(amount);
  }
  function addMyBalance(uint256 add) public {
    totalSupply = totalSupply.add(add);
    accounts[msg.sender].balance = accounts[msg.sender].balance.add(add);
  }
  function subMybalance(uint256 sub) public {
    totalSupply = totalSupply.sub(sub);
    accounts[msg.sender].balance = accounts[msg.sender].balance.sub(sub);
  }
  
  function beforeClaimView() view public returns(uint, uint, uint) {
    return (accounts[msg.sender].balance, accounts[msg.sender].lastDividendPoints, accounts[msg.sender].cash);
  }
  
  function claimView() view public updateAccount(msg.sender) returns(uint, uint, uint) {
    return (accounts[msg.sender].balance, accounts[msg.sender].lastDividendPoints, accounts[msg.sender].cash);
  }
  
  function claim() public updateAccount(msg.sender) returns(uint, uint, uint) {
    return (accounts[msg.sender].balance, accounts[msg.sender].lastDividendPoints, accounts[msg.sender].cash);
  }

  function getBalance(address account) view public returns(uint, uint, uint){
    return (accounts[msg.sender].balance, accounts[msg.sender].lastDividendPoints, accounts[msg.sender].cash);
  }
}