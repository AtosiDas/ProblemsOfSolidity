// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract MyContract {
    address[] Members;
    function join() public payable{
        require(msg.value == 1 ether);
        Members.push(msg.sender);
    }
    
    function join_referrer(address payable _addr) public payable {
        bool flag;
        for(uint i = 0; i< Members.length;i++){
            if(_addr == Members[i])
                flag = true;
        }
        require(flag == true);
        require(msg.value == 1 ether);
        _addr.transfer(1 ether/10);
        Members.push(msg.sender);
    }
    function get_members() public view returns(address[] memory){
        return Members;
    }
}
