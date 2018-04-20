pragma solidity ^0.4.21;

// http://solidity.readthedocs.io/en/latest/types.html#data-location

contract C {
    uint[] x; // the data location of x is storage
    event Logging(uint[]);
    // the data location of memoryArray is memory
    function f(uint[] memoryArray) public {  // when if input [0,1,2,3,4,5,6,7,8,9]
        x = memoryArray; // works, copies the whole array to storage
        uint[] y = x; // works, assigns a pointer, data location of y is storage
        uint[] storage z = x;
        y[7]; // fine, returns the 8th element
        emit Logging(x); // 
        emit Logging(y);
        emit Logging(z);
        z.length = 5; // fine, modifies x through y
        emit Logging(x);
        emit Logging(y);
        emit Logging(z);
        y.length = 2; // fine, modifies x through y
        emit Logging(x);
        emit Logging(y);
        emit Logging(z);
        delete x; // fine, clears the array, also modifies y
        emit Logging(x);
        emit Logging(y);
        emit Logging(z);
        // The following does not work; it would need to create a new temporary /
        // unnamed array in storage, but storage is "statically" allocated:
        // y = memoryArray;
        // This does not work either, since it would "reset" the pointer, but there
        // is no sensible location it could point to.
        // delete y;
        g(x); // calls g, handing over a reference to x
        h(x); // calls h and creates an independent, temporary copy in memory
    }

    function g(uint[] storage storageArray) internal {}
    function h(uint[] memoryArray) public {}
}