// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DAOMembership {
    address public Owner;
    address[] public members;
    uint NoOfMembers;

    constructor() {
        Owner = msg.sender;
        members.push(Owner);
        NoOfMembers++;
    }
    
    modifier NoMembers {
        for(uint i = 0; i< NoOfMembers; i++){
            require(msg.sender != members[i]);   
        }
        _;
    }
 
    modifier Onlymembers{
        bool flag = false;
        for(uint i = 0 ;i < NoOfMembers; i++){
            if(msg.sender == members[i])
                flag = true;
        }
        require(flag == true);
        _;
    }

    struct Applier {
        bool isApplied;
        uint NoOfApprovedVotes;
        address[] Approvers;
    }

    mapping(address => Applier) details;
 
    //To apply for membership of DAO
    function applyForEntry() public NoMembers {
        Applier storage NewApplier = details[msg.sender];
        require(NewApplier.isApplied == false);
        NewApplier.isApplied = true;
    }
    
    //To approve the applicant for membership of DAO
    function approveEntry(address _applicant) public Onlymembers{
        Applier storage NewApplier = details[_applicant];
        require(NewApplier.isApplied == true);
        for(uint i = 0; i< NoOfMembers; i++){
            require(_applicant != members[i]);
        }
        for(uint i = 0; i< NewApplier.Approvers.length;i++){
            require(msg.sender != NewApplier.Approvers[i]);
        }
        NewApplier.NoOfApprovedVotes++;
        NewApplier.Approvers.push(msg.sender);
        if(NewApplier.NoOfApprovedVotes > ((NoOfMembers*30)/100)){
            members.push(_applicant);
            NoOfMembers++;
        }
    }

    //To check membership of DAO
    function isMember(address _user) public view Onlymembers returns (bool) {
        for(uint i=0; i<NoOfMembers;i++){
            if(members[i]==_user)
                return true;
        }
        return false;
    }

    //To check total number of members of the DAO
    function totalMembers() public view Onlymembers returns (uint256) {
        return NoOfMembers;
    }
}
