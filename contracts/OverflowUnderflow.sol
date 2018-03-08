pragma solidity ^0.4.19;

contract OverflowUnderflow {
    // (2**256 - 1) + 1 = 0
    function overflow() public pure returns (uint256 _maximum, uint256 _overflow) {
        uint256 max = 2**256 - 1; // 115792089237316195423570985008687907853269984665640564039457584007913129639935
        return (max, _maximum + 1); // 1
    }
    // 0 - 1 = 2**256 - 1
    function underflow() public pure returns (uint256 _minium, uint256 _underflow) {
        uint256 min = 0; // 0
        return (min, min - 1); // 115792089237316195423570985008687907853269984665640564039457584007913129639935
    }
}