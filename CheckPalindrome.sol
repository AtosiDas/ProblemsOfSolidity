// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PalindromeChecker {
    
    //To check if a given string is palindrome or not
    function isPalindrome(string memory str) public pure returns(bool) {
        bytes memory buffer = bytes(str);
        uint8[] memory arr = new uint8[](buffer.length);
        uint j = 0;
        for(uint i ; i < buffer.length; i++){
            if(uint8(buffer[i]) >= 65 && uint8(buffer[i]) <= 90){
                arr[j]= uint8(buffer[i]) + 32;
                j++;
            }
            if(uint8(buffer[i]) >= 97 && uint8(buffer[i]) <= 122){
                arr[j]= uint8(buffer[i]);
                j++;
            }
        }
        uint8[] memory arr1 = new uint8[](j);
        if(j < buffer.length){
            for(uint k = 0; k < j; k++){
                arr1[k] = arr[k];
            }
        }
        else{
            arr1 = arr;
        }
        unchecked{
        for(uint i ; i < j / 2; i++){
            if(arr1[i] != arr1[j - 1 - i]){
                return false;
            }
        }
        return true;}
    }

}
