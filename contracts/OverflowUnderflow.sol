pragma solidity ^0.4.19;

contract OverflowUnderflow {
    // (2**256 - 1) + 1 = 0
    function overflow() public pure returns (uint256 _maximum, uint256 _overflow) {
        uint256 max = 2**256 - 1; // 115792089237316195423570985008687907853269984665640564039457584007913129639935
        return (max, max + 1); // 1
    }
    // 0 - 1 = 2**256 - 1
    function underflow() public pure returns (uint256 _minium, uint256 _underflow) {
        uint256 min = 0; // 0
        return (min, min - 1); // 115792089237316195423570985008687907853269984665640564039457584007913129639935
    }
    
    // when if _b > _a, underflow , 11579208923731619542357098500868790785326998466564056403945...
    function mySub(uint256 _a, uint256 _b) public pure returns (uint256) {
        return _a - _b;
    }
}


// code of openzeppelin
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  /**
  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}


contract SafeOverflowUnderflow {
    using SafeMath for uint256;

    // when if _b > _a, underflow error
    function mySub(uint256 _a, uint256 _b) public pure returns (uint256) {
        return _a.sub(_b);
    }
    
    function overflow() public pure returns (uint256 _maximum, uint256 _overflow) {
        uint256 max = 2**256 - 1; 
        return (max, max.add(1)); // overflow error
    }
    
    function underflow() public pure returns (uint256 _minium, uint256 _underflow) {
        uint256 min = 0; // 0
        return (min, min.sub(1)); // underflow error
    }
}

