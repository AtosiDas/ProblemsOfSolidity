// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LotteryPool {
    address[] players;
    address winner;
    // For participants to enter the pool
    function enter() public payable {
        uint index;
        require(msg.value == 1 ether/10);
        check();
        players.push(msg.sender);
        unchecked{
        if(players.length == 5){
            index  = uint(keccak256(abi.encodePacked(block.timestamp,players.length))) % players.length;
            winner = players[index];
            payable(winner).transfer(address(this).balance);
            players = new address[](0);
        }
        }
    }

    function check() internal view {
        bool flag;
        unchecked{
        for(uint i = 0; i < players.length; i++){
            if(players[i] == msg.sender)
                flag = true;
        }
        require(flag == false);}
    }
    // To view participants in current pool
    function viewParticipants() public view returns (address[] memory, uint) {
        unchecked{return (players,players.length);}
    }

    // To view winner of last lottery
    function viewPreviousWinner() public view returns (address) {
        unchecked{require(winner != 0x0000000000000000000000000000000000000000);
        return winner;}
    }
}
