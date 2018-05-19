pragma solidity 0.4.19;
// pragma solidity >=0.4.1 <=0.4.20;
//import "./usingOraclize.sol";  //Importing Oraclize
import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";
// https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.4.sol
// https://medium.com/@crissimrobert/setting-up-of-oraclize-service-in-smart-contracts-9693049b2151

contract ETHUSD is usingOraclize {  // inherit oraclize
    uint public price;
    event Log(string text);
    //Constructor
    function ETHUSD() public {
        // OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);  // set custom OAR when private network
    }
    function __callback(bytes32 _myid, string _result) public {
        require (msg.sender == oraclize_cbAddress());
        Log(_result);
        price = parseInt(_result, 2);  // parseInt(parseFloat*10^_b)
    }
    function update() public payable {
        oraclize_query("URL","json(https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD).USD");  // {"USD":688.95}
    }

    function WeiBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function oraclizeGetPrice(string datasource) public returns (uint){
        return oraclize_getPrice(datasource);
    }
    // function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
    //     return oraclize.getPrice(datasource);
    // }
}