pragma solidity ^0.4.21;

contract Caller {
    uint public n;
    address public sender;

    event Logging4(bytes4);
    event Logging32(bytes32);

    function callSetN(address _target, uint _n) public {
        _target.call(bytes4(sha3("setN(uint256)")), _n); // Target's storage is set, Caller is not modified
        // emit Logging4(bytes4(keccak256("setN(uint256)")));
        // emit Logging32(keccak256("setN(uint256)"));
    }

    function callSetN2(address _target, uint _n) public {
        Target t = Target(_target);
        t.setN(_n);
    }

    function callcodeSetN(address _target, uint _n) public {
        _target.callcode(bytes4(keccak256("setN(uint256)")), _n); // Caller's storage is set, Target is not modified
    }

    function delegatecallSetN(address _target, uint _n) public {
        _target.delegatecall(bytes4(keccak256("setN(uint256)")), _n); // Caller's storage is set, Target is not modified
    }
}

contract Target {
    uint public n;
    address public sender;

    function setN(uint256 _n) public {
        n = _n;
        sender = msg.sender;
    }
}


