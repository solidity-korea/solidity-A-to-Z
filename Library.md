# Solidity Library

### Library 특징
- No state variables
- Cannot inherit nor be inherited
- Cannot receive Ether
- 선언 
    - **library** *Name* { code }
- 사용
    - `using Name for uint256;` // type
    - `using Name for *;`  // wildcard type
- https://solidity.readthedocs.io/en/v0.4.24/contracts.html#libraries


### Library 예제
- safeMath  https://github.com/solidity-korea/solidity-A-to-Z/blob/master/contracts/OverflowUnderflow.sol
    - **internal, private** function 으로 구성된 Library 는 통합 배포됨
- MathUtils 올림, 내림, 반올림 Library 예제
    - https://github.com/solidity-korea/solidity-A-to-Z/blob/master/contracts/LibTest.sol
    - **public, external** function 으로 구성된 Library 는 통합 별도 배포, link 필요


### Library Deploy, Verify
- [remix](http://remix.ethereum.org), [MetaMask](http://metamask.io), [Etherscan](http://ropsten.etherscan.io)
- [solc](https://solidity.readthedocs.io/en/v0.4.24/installing-solidity.html), [myCrypto](http://mycrypto.com), [MEW](http://myetherwallet.com) 를 통한 배포
    - solc 설치 https://solidity.readthedocs.io/en/v0.4.24/installing-solidity.html#binary-packages

### Library Link using solc
- `solc --bin LibTest.sol`
- `solc --bin LibTest.sol | solc --link --libraries LibTest.sol:MathUtils:0x95816bd09ce1ac416f2d07a7e2d2dbbbf17b9337`
- `solc --bin LibTest.sol --libraries LibTest.sol:MathUtils:0x95816bd09ce1ac416f2d07a7e2d2dbbbf17b9337`
- https://solidity.readthedocs.io/en/v0.4.24/using-the-compiler.html

### usages
- https://solidity.readthedocs.io/en/v0.4.24/contracts.html#libraries
