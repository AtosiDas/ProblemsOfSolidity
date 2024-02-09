// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RemoveVowels {

    function removeVowels(string memory _input) public pure returns (string memory){
        bytes memory newInput = bytes(_input);
        bytes memory newInput1 = new bytes(newInput.length);
        uint result;
        for(uint i = 0; i < newInput.length; i++){
            if(newInput[i] != 0x61 && newInput[i] != 0x65 && newInput[i] != 0x69 && newInput[i] != 0x6f && newInput[i] != 0x75 && newInput[i] != 0x41 && newInput[i] != 0x45 && newInput[i] != 0x49 && newInput[i] != 0x4f && newInput[i] != 0x55){
                newInput1[result] = newInput[i];
                result++;
            }
        }
        bytes memory newInput2 = new bytes(result);
        for(uint i = 0; i < result; i++){
            newInput2[i] = newInput1[i];
        }
        return string(newInput2);
    }
}