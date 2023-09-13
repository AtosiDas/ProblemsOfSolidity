// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract MyContract {
    function Greater(uint[] memory arr) public pure returns(uint){
        uint max = arr[0];
        for(uint i =1;i < arr.length; i++){
            if(max <arr[i])
                max = arr[i];
        }
        return max;
    }
}
