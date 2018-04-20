pragma solidity ^0.4.21;

import "github.com/OpenZeppelin/zeppelin-solidity/contracts/math/SafeMath.sol";

// 기존 Deposit 을 오늘 수업 중 다룬  Array, Struct 이용하여 확장 구현
// 기존 버전은 Transaction 단위 없이 ( 입금, 출금 ) 잔액 정보만 존재했음,   이를 struct 를 사용하여 deposit_id, 시간, deposit 양, 상태(deposit, return) 정보를 함께   하나의 단위로 저장
// 각 유저는 여러번 deposit 하여 여러 deposit_id 를 가질 수 있고, 각 단위에 대해 deposit_id 를 통해 claim 할 수 있도록 구현

contract Deposit {
    using SafeMath for uint256;

    enum DepositState { Deposited, Returned }
    
    struct DepositTx {
        uint256 id;
        uint256 time;
        uint256 value; // deposit value
        uint256 balance;  // remaining balance of deposit value
        address owner;
        DepositState state;
    }

    DepositTx[] public depositList;
    mapping (address => uint256[]) public userDepositList;

  
    // callback 함수로서 payable 하여 Account가 ETH 를 전송하면 Contract 에 Deposit 하는 함수
    function() public payable {
        deposit();
    }
    
    function deposit() public payable {
        // 전송한 ETH(Wei) 양이 0 보다 커야 하는 조건
        // payable 을 통해 받은 ETH(Wei) 를 balances 에 저장 ( 각 account 별로 따로 )
        require(msg.value > 0);

        // struct, array, mapping 를 local에 선언하려면 memory 에 저장하겠다고 명시적 표기가 필요
        DepositTx memory depositTx = DepositTx({
            id: depositList.length,
            time: uint256(now), // now == block.timestamp
            value: msg.value,
            balance: msg.value, 
            owner: msg.sender,
            state: DepositState.Deposited
        });
        
        depositList.push(depositTx);
        userDepositList[msg.sender].push(depositTx.id);
    }
    
    function totalDepositCount() public view returns (uint256) {
        return depositList.length;
    }
    
    function totalReturnedCount() public view returns (uint256) {
        // need to implement
        uint256 _depositCount = totalDepositCount();
        uint256 count;
        for (uint256 i=0; i < _depositCount; i++) {
            if ( depositList[i].state == DepositState.Returned ) {
                count++;
            }
        }
        return count;
    }
    
    function myDepositCount() public view returns (uint256) {
        return userDepositList[msg.sender].length;
    }
    
    function myReturnedCount() public view returns (uint256) {
        // need to implement
        uint256 _myDepositCount = myDepositCount();
        uint256 count;
        for (uint256 i=0; i < _myDepositCount; i++) {
            if ( depositList[userDepositList[msg.sender][i]].state == DepositState.Returned ) {
                count++;
            }
        }
        return count;
    }
    
    // Doposit 한 Account 가 자신의 Deposit 양을 리턴하는 view 함수
    function myDepositValue() public view returns(uint256) {
        uint256 count = myDepositCount();
        uint256 totalValue;
        for (uint256 i=0; i<count; i++) {
            totalValue = totalValue.add(depositList[userDepositList[msg.sender][i]].value);
        }
        return totalValue;
    }
    
    // Doposit 한 Account 가 자신의 Deposit 양을 리턴하는 view 함수
    function myDepositBalance() public view returns(uint256) {
        uint256 count = myDepositCount();
        uint256 totalValue;
        for (uint256 i=0; i<count; i++) {
            totalValue = totalValue.add(depositList[userDepositList[msg.sender][i]].balance);
        }
        return totalValue;
    }

    
    // 모든 Account 가 Deposit 한 총 ETH(Wei)의 양을 리턴하는 view 함수 
    function totalDepositBalance() public view returns(uint256) {
        // this.balance 사용 -> 0.4.21 부터 this 를 address 로 명시적 형변환 필요 address(this).*
        return address(this).balance;
    }
    
    function totalDepositValue() public view returns(uint256) {
        // need to implement
        uint256 _depositCount = totalDepositCount();
        uint256 totalValue;
        for (uint256 i=0; i < _depositCount; i++) {
            totalValue = totalValue.add(depositList[i].value);
        }
        return totalValue;
    }
    
    
    function myDepositList() public view returns (uint256[]) {
        return userDepositList[msg.sender];
    }
    
    modifier onlyOnwer(uint256 _deposit_id) {
        require(depositList[_deposit_id].owner == msg.sender);
        _;
    }
    
    function claim(uint256 _deposit_id) public onlyOnwer(_deposit_id) returns (bool) {
        require(depositList[_deposit_id].state == DepositState.Deposited
            && depositList[_deposit_id].balance > 0);
        
        uint256 claimValue = depositList[_deposit_id].balance;
        
        depositList[_deposit_id].balance = 0;
        depositList[_deposit_id].state = DepositState.Returned;
        
        bool result = msg.sender.send(claimValue);
        require(result);
        return result;
    }
    
    function claimPartially(uint256 _deposit_id, uint256 _value) public onlyOnwer(_deposit_id) returns (bool) {
        require(depositList[_deposit_id].state == DepositState.Deposited 
            && depositList[_deposit_id].balance >= _value);
        
        depositList[_deposit_id].balance = depositList[_deposit_id].balance.sub(_value);
        if ( depositList[_deposit_id].balance == 0) {
            depositList[_deposit_id].state = DepositState.Returned;  
        } 
        bool result = msg.sender.send(_value);
        require(result);
        return result;
    }

}