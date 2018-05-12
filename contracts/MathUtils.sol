pragma solidity ^0.4.21;

/* from https://github.com/LanguageNetwork/smart-contracts
* @title MathUtils
* @author dongsamb, LangNet.io
*/

library MathUtils {

    function ceil(uint256 input, uint256 decimals) pure internal returns (uint256) {
        uint256 target = 10 ** decimals;
        require(input > target);
        return ((input + target - 1) / target) * target;
    }

    function round(uint256 input, uint256 decimals) pure internal returns (uint256) {
        uint256 target = 10 ** decimals;
        require(input > target);
        return (input / target) * target;
    }

    function roundOff(uint256 input, uint256 decimals) pure internal returns (uint256) {
        uint256 target = 10 ** decimals;
        require(input > target);
        if ( input % target >= 5 * target / 10 ) {
            return ((input + target - 1) / target) * target;
        }
        else {
            return (input / target) * target;
        }
    }
}