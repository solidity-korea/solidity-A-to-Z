pragma solidity ^0.4.21;

import "github.com/OpenZeppelin/zeppelin-solidity/contracts/math/SafeMath.sol";

// 기존 Deposit 을 오늘 수업 중 다룬  Array, Struct 이용하여 확장 구현
// 기존 버전은 Transaction 단위 없이 ( 입금, 출금 ) 잔액 정보만 존재했음,
// 이를 struct 를 사용하여 deposit_id, 시간, deposit 양, 상태(deposit, return) 정보를 함께 하나의 단위로 저장
// 각 유저는 여러번 deposit 하여 여러 deposit_id 를 가질 수 있고, 각 단위에 대해 deposit_id 를 통해 claim 할 수 있도록 구현

contract Deposit {
    using SafeMath for uint256;

    enum DepositState { Deposited, Returned }  // 유저가 선언하는 열거형 자료형, 내부적으로  0, 1, 2.. 순으로 인덱스돼어 uint8 로 저장됨
    // https://solidity.readthedocs.io/en/develop/types.html#enums
    
    struct DepositTx {
        uint256 id;  // deposit id, claim, view 등에 사용
        uint256 time;  // deposit 한 시간(block)의 unix timestamp
        uint256 value; // deposit 한 값
        uint256 balance;  // depsoit 한 값에서 일부 찾아가고 남은 값
        address owner;  // deposit 한 msg.sender
        DepositState state;  // enum DepositState, Deposited 혹은 Reterned 를 저장 ( 0, 1 )
    }

    // 위 struct 에 대한 list
    DepositTx[] public depositList;

    // account 별로 어떤 depoistTx 들을 가지고있는지 deposit_id 저장용 int mapping
    mapping (address => uint256[]) public userDepositList;

  
    // callback 함수로서 payable 하여 Account가 ETH 를 전송하면 Deposit 를 호출하여 Deposit 수행
    function() public payable {
        deposit();
    }
    
    function deposit() public payable returns (uint256 _depositTxId) {
        // 전송한 ETH(Wei) 양이 0 보다 커야 하는 조건
        // payable 을 통해 받은 ETH(Wei) 를 balances 에 저장 ( 각 account 별로 따로 )
        require(msg.value > 0);

        // struct, array, mapping 를 local에 선언하려면 memory 에 저장하겠다고 명시적 표기가 필요
        DepositTx memory depositTx = DepositTx({
            id: depositList.length,  // depositList 의 length 를 통해 id 지정
            time: uint256(now), // now == block.timestamp
            value: msg.value, // deposit 값(고정),
            balance: msg.value,  // 남은 잔액 둘다 우선 msg.value 로 할당
            owner: msg.sender,
            state: DepositState.Deposited  // enum 할당
        });
        
        depositList.push(depositTx);  // 로컬에서 메모리에 임시 선언된 struct 를 list 에 추가
        userDepositList[msg.sender].push(depositTx.id);  // 해당  유저의 mapping List 에 depositTx.id 만을 따로  저장
        return depositTx.id;  // fallback 함수에서는 return 이 안되니, deposit 함수를 별도 분리해서 추후 dapp 등에서 결과 받을 수 있도록 구현
    }

    // 총 deposit 갯수
    function totalDepositCount() public view returns (uint256) {
        return depositList.length;
    }

    // 자기의 deposit 갯수
    function myDepositCount() public view returns (uint256) {
        return userDepositList[msg.sender].length;
    }

    // 자기의 deposit 들에 대한 deposit id list 리턴
    function myDepositList() public view returns (uint256[]) {
        return userDepositList[msg.sender];
    }

    // 모든 Account 가 Deposit 하고, 찾아가고, contract 에 남아있는 총 ETH(Wei)의 양을 리턴하는 view 함수
    function totalDepositBalance() public view returns (uint256) {
        // this.balance 사용 -> 0.4.21 부터 this 를 address 로 명시적 형변환 필요 address(this).*
        return address(this).balance;
    }


    // 해당 deposit 의 owner 만 claim 할 수 있도록하는 _deposit_id 를 인자로 받는 modifier
    modifier onlyOnwer(uint256 _deposit_id) {
        require(depositList[_deposit_id].owner == msg.sender);
        _;
    }


    // deposit id 를 받아 deposit 잔액 전체를 claim 을 진행하는 함수
    function claim(uint256 _deposit_id) public onlyOnwer(_deposit_id) returns (bool) {
        require(depositList[_deposit_id].state == DepositState.Deposited  // returned 상태가아니라 deposit 상태인지 확인
        && depositList[_deposit_id].balance > 0);  // AND 논리 연산, 잔액이 0 보다 큰지 확인

        uint256 claimValue = depositList[_deposit_id].balance;

        depositList[_deposit_id].balance = 0;  // 잔액 전체를 claim 하므로 0으로 세팅
        depositList[_deposit_id].state = DepositState.Returned;  // state 를 returned 로 세팅

        bool result = msg.sender.send(claimValue);  // ETH 전송,
        require(result);  // 결과 return 을 위해 result 임시 변수에 담아서 require 수행
        return result;
    }

    // deposit_id 와, 해당 deposit 의 잔액에서 일부만 claim 하기위한 value 값을 인자로 받는 부분 claim 함수
    function claimPartially(uint256 _deposit_id, uint256 _value) public onlyOnwer(_deposit_id) returns (bool) {
        require(depositList[_deposit_id].state == DepositState.Deposited  // returned 상태가아니라 deposit 상태인지 확인
        && depositList[_deposit_id].balance >= _value);   // AND 논리 연산, 잔액이 _value 보다 같거나 큰지 확인

        depositList[_deposit_id].balance = depositList[_deposit_id].balance.sub(_value);  // safe math
        if ( depositList[_deposit_id].balance == 0) {  // 잔액이 0 이 되었을때만 조건부로 state를 returned 로 설정
            depositList[_deposit_id].state = DepositState.Returned;
        }
        bool result = msg.sender.send(_value);
        require(result);
        return result;
    }


    // 모든 Account 가 Deposit 했던 총 양을 for문을 통해 계산 후 return 하는 view 함수
    function totalDepositValue() public view returns (uint256) {
        // need to implement
        uint256 _depositCount = totalDepositCount();
        uint256 totalValue;
        for (uint256 i=0; i < _depositCount; i++) {
            totalValue = totalValue.add(depositList[i].value);
        }
        return totalValue;
    }

    // Doposit 한 Account 가 자신의 총 Deposit 했던 양을 리턴하는 view 함수 ( .value 사용 )
    function myDepositValue() public view returns (uint256) {
        uint256 count = myDepositCount();
        uint256 totalValue;
        for (uint256 i=0; i<count; i++) {
            totalValue = totalValue.add(depositList[userDepositList[msg.sender][i]].value);
        }
        return totalValue;
    }


    // Doposit 한 Account 가 자신의 Deposit 들의 남은 잔액을 리턴하는 view 함수 ( .balance 사용 )
    function myDepositBalance() public view returns (uint256) {
        uint256 count = myDepositCount();
        uint256 totalValue;
        for (uint256 i=0; i<count; i++) {
            totalValue = totalValue.add(depositList[userDepositList[msg.sender][i]].balance);
        }
        return totalValue;
    }

    // 전체 deposit 중, returned 된 deposit 의 갯수를 반환하는 함수
    function totalReturnedCount() public view returns (uint256) {
        // 실습
    }

    // 자신의 deplist 중 returned 된 deposit 의 갯수를 반환하는 함수
    function myReturnedCount() public view returns (uint256) {
        // 실습
    }

}