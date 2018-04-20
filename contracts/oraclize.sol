pragma solidity ^0.4.19;
import "./usingOraclize.sol";  //Importing Oraclize

contract TestOraclizeCall is usingOraclize {  // inherit oraclize
    uint public price;
    event Log(string text);
    //Constructor
    function TestOraclizeCall() {
        OAR = OraclizeAddrResolverI(0xa884A803223DC1A72544Fa0f8bDddF333cbad248);  // oraclize contract
    }
    function __callback(bytes32 _myid, string _result) {
        require (msg.sender == oraclize_cbAddress());
        Log(_result);
        price = parseInt(_result, 2);  // set by oraclize
    }
    function update() payable {
        oraclize_query("URL","json(https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD).USD");  // {"USD":506.1}
    }
}