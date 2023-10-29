// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LotteryPool {
    address private Owner;
    address winner;
    address[] Players;
    constructor() {
        Owner = msg.sender;
    }
    mapping(address => uint) Isplayer;
    mapping(address => uint) CountWinning;
    mapping(address => uint) balance;
    
    // For participants to enter the pool
    function enter() public payable {
        check1();
        require(Isplayer[msg.sender] == 0 && Owner != msg.sender);
        uint entryFee;
        uint index;
        entryFee = msg.value / 10;
        payable(Owner).transfer(entryFee);
        balance[Owner] += entryFee;
        Isplayer[msg.sender] = 1;
        balance[msg.sender] = msg.value - entryFee;
        Players.push(msg.sender);
        unchecked{
        if(Players.length == 5){
            index  = uint(keccak256(abi.encodePacked(block.timestamp,Players.length))) % Players.length;
            winner = Players[index];
            Isplayer[winner] = 0;
            CountWinning[winner]++;
            payable(winner).transfer(address(this).balance);
            Players = new address[](0);
        }
        }
    }

    function check1() internal view {
        require(msg.value == (0.1 ether + CountWinning[msg.sender] * 0.01 ether));
    }
    function check2() internal view {
        bool flag;
        for(uint i = 0; i < Players.length; i++){
            if(Players[i] == msg.sender)
                flag = true;
        }
        require(flag == true);
    }
    // For participants to withdraw from the pool
    function withdraw() public {
        check2();
        require(Players.length < 5);
        payable(msg.sender).transfer(balance[msg.sender]);
        balance[msg.sender] = 0;
        Isplayer[msg.sender] = 0;
        unchecked{
        for(uint i = 0; i < Players.length; i++){
            if(Players[i] == msg.sender){
                for(uint j = i; j < Players.length - 1; j++){
                    Players[j] = Players[j+1];
                }
                Players.pop();
            }
        }}
    }

    // To view participants in current pool
    function viewParticipants() public view returns (address[]  memory, uint) {
        unchecked{return (Players,Players.length);}
    }

    // To view winner of last lottery
    function viewPreviousWinner() public view returns (address) {
        unchecked{require(winner != 0x0000000000000000000000000000000000000000);
        return winner;}
    }

    // To view the amount earned by Gavin
    function viewEarnings() public view returns (uint256) {
        require(msg.sender == Owner);
        unchecked{return balance[Owner];}
    }

    // To view the amount in the pool
    function viewPoolBalance() public view returns (uint256) {
        unchecked{return address(this).balance;}
    }
}
