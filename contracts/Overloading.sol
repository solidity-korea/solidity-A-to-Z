pragma solidity ^0.4.19;

// You can check https://ropsten.etherscan.io/address/0x9721325ffb6f9922bece5840441505710fd305b4

contract Overloading {
    
    event Logging(string);
    event Logging(uint256);
    event Logging(string, uint256);
    
    function overload(uint256 a) public pure returns (uint256 _a) {
        return a;
    }
    
    function overload(string b) public pure returns (string _b) {
        return b;
    }
    
    function overload(string c, uint256 c2) public pure returns (string _c, uint256 _c2) {
        return (c, c2);
    }
    
    function overload(uint128 d) public pure returns (uint128 _d) {
        return d;
    }
    
    function overloadEvent(uint256 a) public {
        Logging('overload with uint256 a');
        Logging(a);
    }
    
    function overloadEvent(string b) public {
        Logging('overload with string b');
        Logging(b);
    }
    
    function overloadEvent(string c, uint256 c2) public {
        Logging('overload with string c with uint256 c2');
        Logging(c, c2);
    }
    
    function overloadEvent(uint128 d) public {
        Logging('overload with uint128 d');
        Logging(d);
    }
}