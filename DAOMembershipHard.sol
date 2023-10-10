// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DAOMembership {
    address Owner;
    address[] Members;
    constructor() {
        Owner = msg.sender;
        Members.push(Owner);
        DAOEligibality[Owner] = 1;
        TotalNoOfMembers++;
    }
    mapping(address => bool) RequestDone;
    address[] RequestForMembers;
    mapping(address => uint) ApprovedVotes;
    mapping(address => uint) DisApprovedVotes;
    mapping(address => uint) DAOEligibality;
    mapping(address => uint) RemovalVotes;
    struct Entry {
        address[] Approvers;
        address[] DisApprovers;
    }
    mapping(address => Entry) Details;
    uint TotalNoOfMembers;
    function NonMembers(address _addr) private view{
        for(uint i = 0; i < Members.length; i++){
            require(Members[i] != _addr);
        }
    }
    function OnlyMembers(address _addr) private view{
        require(DAOEligibality[_addr] == 1);
    }

    //To apply for membership of DAO
    function applyForEntry() public {
        require(TotalNoOfMembers > 0);
        NonMembers(msg.sender);
        require(RequestDone[msg.sender] == false);
        RequestForMembers.push(msg.sender);
        RequestDone[msg.sender] = true;
    }
    
    //To approve the applicant for membership of DAO
    function approveEntry(address _applicant) public {
        require(TotalNoOfMembers > 0);
        OnlyMembers(msg.sender);
        require(RequestDone[_applicant] == true);
        NonMembers(_applicant);
        for(uint i = 0; i < Details[_applicant].Approvers.length; i++){
            require(Details[_applicant].Approvers[i] != msg.sender);
        }
        require(DAOEligibality[_applicant] == 0);
        Details[_applicant].Approvers.push(msg.sender);
        ApprovedVotes[_applicant]++;
        if(ApprovedVotes[_applicant] > (30*TotalNoOfMembers)/100){
            Members.push(_applicant);
            TotalNoOfMembers++;
            DAOEligibality[_applicant] = 1;
        }
    }

    //To disapprove the applicant for membership of DAO
    function disapproveEntry(address _applicant) public{
        require(TotalNoOfMembers > 0);
        OnlyMembers(msg.sender);
        require(RequestDone[_applicant] == true);
        for(uint i = 0; i < Details[_applicant].DisApprovers.length; i++){
            require(Details[_applicant].DisApprovers[i] != msg.sender);
        }
        Details[_applicant].DisApprovers.push(msg.sender);
        DisApprovedVotes[_applicant]++;
        if(DisApprovedVotes[_applicant] > (70*TotalNoOfMembers)/100){
            DAOEligibality[_applicant] = 2;
        }
    }

    //To remove a member from DAO
    function removeMember(address _memberToRemove) public {
        require(TotalNoOfMembers > 0);
        OnlyMembers(msg.sender);
        require(DAOEligibality[_memberToRemove] == 1);
        require(msg.sender != _memberToRemove);
        RemovalVotes[_memberToRemove]++;
        if(RemovalVotes[_memberToRemove] >= (70*TotalNoOfMembers)/100){
            DAOEligibality[_memberToRemove] = 2;
            TotalNoOfMembers--;
        }
    }

    //To leave DAO
    function leave() public {
        require(TotalNoOfMembers > 0);
        OnlyMembers(msg.sender);
        DAOEligibality[msg.sender] = 2;
        TotalNoOfMembers--;
    }

    //To check membership of DAO
    function isMember(address _user) public view returns (bool) {
        require(TotalNoOfMembers > 0);
        OnlyMembers(msg.sender);
        if(DAOEligibality[_user] == 1){
            return true;
        }
        return false;
    }

    //To check total number of members of the DAO
    function totalMembers() public view returns (uint256) {
        require(TotalNoOfMembers > 0);
        OnlyMembers(msg.sender);
        return TotalNoOfMembers;
    }
}
