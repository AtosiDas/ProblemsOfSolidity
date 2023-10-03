// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract ScholarshipCreditContract {
    address private Owner;
    uint TotalCreits  = 1000000;
    constructor() {
        Owner = msg.sender;
    }
    address[] Students;
    address[] Merchants;
    mapping(address => bool) RegistrationDone;
    mapping(address => uint) Credits;
    mapping(address => bool) StudentDone;
    function OnlyOwner() private view{
        require(msg.sender == Owner);
    }

    //This function assigns credits to student getting the scholarship
    function grantScholarship(address studentAddress, uint credits) public{
        OnlyOwner();
        require(studentAddress != Owner);
        require(credits <= TotalCreits);
        for(uint i = 0; i < Merchants.length; i++){
            require(Merchants[i] != studentAddress);
        }
        Students.push(studentAddress);
        Credits[studentAddress] += credits;
        TotalCreits -= credits;
        StudentDone[studentAddress] = true;
    }

    //This function is used to register a new merchant who can receive credits from students
    function registerMerchantAddress(address merchantAddress) public {
        OnlyOwner();
        require(merchantAddress != Owner);
        for(uint i = 0; i < Students.length; i++){
            require(Students[i] != merchantAddress);
        }
        require(RegistrationDone[merchantAddress] == false);
        Merchants.push(merchantAddress);
        RegistrationDone[merchantAddress] = true;
    } 

    //This function is used to deregister an existing merchant
    function deregisterMerchantAddress(address merchantAddress) public {
        OnlyOwner();
        require(RegistrationDone[merchantAddress] == true);
        RegistrationDone[merchantAddress] = false;
        TotalCreits += Credits[merchantAddress];
        Credits[merchantAddress] = 0;
    }

    //This function is used to revoke the scholarship of a student
    function revokeScholarship(address studentAddress) public{
        OnlyOwner();
        require(StudentDone[studentAddress] == true);
        StudentDone[studentAddress] = false;
        TotalCreits += Credits[studentAddress];
        Credits[studentAddress] = 0;
    }

    //Students can use this function to transfer credits only to registered merchants
    function spend(address merchantAddress, uint amount) public{
        OnlyStudents();
        require(RegistrationDone[merchantAddress] == true);
        require(Credits[msg.sender] >= amount);
        Credits[msg.sender] -= amount;
        Credits[merchantAddress] += amount;        

    }
    function OnlyStudents() private view{
        bool flag;
        for(uint i = 0; i < Students.length; i++){
            if(msg.sender == Students[i]){
                flag = true;
            }
        }
        require(flag == true);
    }

    //This function is used to see the available credits assigned.
    function checkBalance() public view returns(uint) {
        if(msg.sender == Owner){
            return TotalCreits;}
        else if(StudentDone[msg.sender] == true || RegistrationDone[msg.sender] == true)
            {return Credits[msg.sender];}
        else revert();
    }
}
