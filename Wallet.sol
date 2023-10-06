//SPDX-License-Identifier:MIT

pragma solidity >= 0.7.0 <= 0.9.0;

contract Wallet {
    address private owner;
    constructor() {
        owner = msg.sender;
    }
    function OnlyOwner() private view {
        require(msg.sender == owner);
    }
    address[] public WinningTeam;
    uint WiningPrize;
    bool IsExecuted;
    uint TotalNoOfRequest;
    struct Request {
        address Sender;
        uint RequestAmount;
        uint TotalApprover;
        uint TotalRejector;
        address[] Approvers;
        address[] Rejectors;
        string status;
    }
    mapping(uint => Request) RequestDetails;
    uint TotalFailed;
    uint TotalPending;
    uint TotalDebited;
    function setWallet(address[] memory members, uint credit) public {
        OnlyOwner();
        require(IsExecuted == false);
        require(members.length >= 1);
        require(credit > 0);
        Check(members,owner);
        WinningTeam = members;
        WiningPrize = credit;
        IsExecuted = true;
    }  
    function Check(address[] memory members, address addr) private pure {
        for(uint i = 0; i < members.length; i++){
            require(members[i] != addr);
        }
    }
    function spend(uint amount) public {
        require(OnlyMembers(WinningTeam, msg.sender) == true);
        require(amount > 0);
        TotalNoOfRequest++;
        RequestDetails[TotalNoOfRequest].Sender = msg.sender;
        RequestDetails[TotalNoOfRequest].RequestAmount = amount;
        RequestDetails[TotalNoOfRequest].TotalApprover++;
        RequestDetails[TotalNoOfRequest].Approvers.push(msg.sender);
        if(amount > WiningPrize){
            RequestDetails[TotalNoOfRequest].status = "failed";
            TotalFailed++;
        }
        else{
            RequestDetails[TotalNoOfRequest].status = "pending";
            TotalPending++;
        }
        if(WinningTeam.length == 1){
            if(RequestDetails[TotalNoOfRequest].RequestAmount > WiningPrize){
                RequestDetails[TotalNoOfRequest].status = "failed";
                TotalFailed++;
            }else{
                WiningPrize -= RequestDetails[TotalNoOfRequest].RequestAmount;
                RequestDetails[TotalNoOfRequest].status = "debited";
                TotalDebited++;
                TotalPending--;
            }
        }
    }
    function OnlyMembers(address[] memory members,address addr) private pure returns(bool) {
        for(uint i = 0; i < members.length; i++){
            if(members[i] == addr)
                return true;
        }
        return false;
    }
    function approve(uint n) public {
        require(OnlyMembers(WinningTeam, msg.sender) == true);
        require(keccak256(abi.encodePacked(RequestDetails[n].status)) == keccak256(abi.encodePacked("pending")));
        require(keccak256(abi.encodePacked(RequestDetails[n].status)) != keccak256(abi.encodePacked("debited")));
        require(keccak256(abi.encodePacked(RequestDetails[n].status)) != keccak256(abi.encodePacked("failed")));
        for(uint i = 0; i < RequestDetails[n].Approvers.length; i++){
            require(RequestDetails[n].Approvers[i] != msg.sender);
        }
        for(uint i = 0; i < RequestDetails[n].Rejectors.length; i++){
            require(RequestDetails[n].Rejectors[i] != msg.sender);
        }
        RequestDetails[n].Approvers.push(msg.sender);
        RequestDetails[n].TotalApprover++;
        if(RequestDetails[n].TotalApprover > (7*WinningTeam.length)/10){
            WiningPrize -= RequestDetails[n].RequestAmount;
            RequestDetails[n].status = "debited";
            TotalDebited++;
            TotalPending--;
        }
    }
    function reject(uint n) public {
        require(OnlyMembers(WinningTeam, msg.sender) == true);
        require(keccak256(abi.encodePacked(RequestDetails[n].status)) == keccak256(abi.encodePacked("pending")));
        require(keccak256(abi.encodePacked(RequestDetails[n].status)) != keccak256(abi.encodePacked("debited")));
        require(keccak256(abi.encodePacked(RequestDetails[n].status)) != keccak256(abi.encodePacked("failed")));
        for(uint i = 0; i < RequestDetails[n].Approvers.length; i++){
            require(RequestDetails[n].Approvers[i] != msg.sender);
        }
        for(uint i = 0; i < RequestDetails[n].Rejectors.length; i++){
            require(RequestDetails[n].Rejectors[i] != msg.sender);
        }
        RequestDetails[n].Rejectors.push(msg.sender);
        RequestDetails[n].TotalRejector++;
        if(RequestDetails[n].TotalRejector > (3*WinningTeam.length)/10){
            RequestDetails[n].status = "failed";
            TotalFailed++;
            TotalPending--;
        }
    }
    function credits() public view returns (uint) {
        require(OnlyMembers(WinningTeam, msg.sender) == true);
        return WiningPrize;
    }
    function viewTransaction(uint n) public view returns (uint amount,string memory status) {
        require(OnlyMembers(WinningTeam, msg.sender) == true);
        require(TotalNoOfRequest > 0);
        return (RequestDetails[n].RequestAmount,RequestDetails[n].status);
    }
    function transactionStats() public view returns (uint debitedCount,uint pendingCount,uint failedCount) {
        require(OnlyMembers(WinningTeam, msg.sender) == true);
        return (TotalDebited,TotalPending,TotalFailed);
    }

}
