// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract CalculateArea {

    //this function returns area of square
    function squareArea(uint a) public pure returns(uint){
        require(a>0);
        return a*a;
    }

    //this function returns area of rectangle
    function rectangleArea(uint a, uint b) public pure returns(uint) {
        require(a>0 && b>0);
        return a*b;
    }
    
}
