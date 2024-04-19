// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimplePaymentChannel {
    address owner;
    address recipiantAddress;
    uint256[] paymentList;
    mapping(address => uint256) depositedAmount;
    mapping(address => uint256) listedAmount;
    constructor(address _recipientAddress) {
        owner = msg.sender;
        recipiantAddress = _recipientAddress;
    }

    function deposit() public payable {
        require(msg.value > 0, "Please enter a valid amount.");
        depositedAmount[msg.sender] = msg.value;
    }

    function listPayment(uint256 amount) public {
        require(depositedAmount[msg.sender] >= amount, "You have limited amount.");
        listedAmount[msg.sender] += amount;
        depositedAmount[msg.sender] -= amount;
        paymentList.push(amount);
    }

    function closeChannel() public {
        require(msg.sender == recipiantAddress || msg.sender == owner, "You are not allowed.");
        payable(owner).transfer(listedAmount[recipiantAddress]);
        payable(recipiantAddress).transfer(depositedAmount[recipiantAddress]);
        
    }

    function checkBalance() public view returns (uint256) {
        return depositedAmount[msg.sender];
    }

    function getAllPayments() public view returns (uint256[] memory) {
        return paymentList;
    }
}