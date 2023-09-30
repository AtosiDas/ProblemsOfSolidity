// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract DWGotTalent {
    address private owner;
    constructor() {
        owner = msg.sender;
    }
    function onlyOwner() private view{
        require(msg.sender == owner);
    }
    address[] Judges;
    uint WeightageOfJudge;
    uint WeightageOfAudience; 
    address[] Finalists;
    bool JudgeListdone;
    bool FinalistsDone;
    bool WeightageADone;
    bool WeightageJDOne;
    bool votingStart;
    bool votingEnd;
    address[] winners;
    struct winner {
        uint VotesFromJudges;
        uint VotesFromAudience;
        // address[] JudgesVote;
        // address[] AudienceVote;
    }
    struct Vote {
        address candidate;
        bool voting;
    }
    mapping(address => winner) Details;
    mapping(address => Vote) voteDone;  //for judges

    //this function defines the addresses of accounts of judges
    function selectJudges(address[] memory arrayOfAddresses) public {
        require(votingStart == false);
        require(arrayOfAddresses.length > 0);
        onlyOwner();
        for(uint i = 0; i < arrayOfAddresses.length; i++){
            require(owner != arrayOfAddresses[i]);
        }
        for(uint i = 0; i < Finalists.length; i++){
            for(uint j = 0; j < arrayOfAddresses.length; j++){
                require(Finalists[i] != arrayOfAddresses[j]);
            }
        }
        Judges = arrayOfAddresses;
        JudgeListdone = true;
    }

    //this function adds the weightage for judges and audiences
    function inputWeightage(uint judgeWeightage, uint audienceWeightage) public {
        require(votingStart == false);
        require(judgeWeightage > 0 || audienceWeightage > 0);
        onlyOwner();
        WeightageOfJudge = judgeWeightage;
        WeightageOfAudience = audienceWeightage;
        WeightageJDOne = true;
        WeightageADone = true;
    }

    //this function defines the addresses of finalists
    function selectFinalists(address[] memory arrayOfAddresses) public {
        require(votingStart == false);
        require(arrayOfAddresses.length > 1);
        onlyOwner();
        for(uint i = 0; i < Judges.length; i++){
            for(uint j = 0; j < arrayOfAddresses.length; j++){
                require(Judges[i] != arrayOfAddresses[j]);
            }
        }
        Finalists = arrayOfAddresses;
        FinalistsDone = true;
    }

    //this function strats the voting process
    function startVoting() public {
        require(JudgeListdone == true);
        require(FinalistsDone == true);
        require(WeightageJDOne == true);
        require(WeightageADone == true);
        require(FinalistsDone == true);
        onlyOwner();
        votingStart = true;
    }

    //this function is used to cast the vote 
    function castVote(address finalistAddress) public {
        require(votingStart == true);
        require(votingEnd == false);
        Check(finalistAddress);
        bool flag1;
        for(uint i = 0; i < Judges.length; i++){
            if(msg.sender == Judges[i]){
                if(voteDone[msg.sender].voting == true){
                    Details[voteDone[msg.sender].candidate].VotesFromJudges--;
                }
                Details[finalistAddress].VotesFromJudges++;
                voteDone[msg.sender].candidate = finalistAddress;
                voteDone[msg.sender].voting = true;
                flag1 = true;
            }
        }
        if(flag1 == false){
            if(voteDone[msg.sender].voting == true){
                Details[voteDone[msg.sender].candidate].VotesFromAudience--;
            }
            Details[finalistAddress].VotesFromAudience++;
            voteDone[msg.sender].candidate = finalistAddress;
            voteDone[msg.sender].voting = true;
        } 
    }

    function Check(address finalistAddress) private view{
        bool flag;
        for(uint i = 0; i < Finalists.length; i++){
            if(Finalists[i] == finalistAddress)
                flag = true;
        }
        require(flag == true);
    }

    //this function ends the process of voting
    function endVoting() public {
        onlyOwner();
        require(votingStart == true);
        votingEnd = true;
    }

    //this function returns the winner/winners
    function showResult() public view returns (address[] memory) {
        require(votingEnd == true);
        address[] memory winnerList = new address[](Finalists.length);

        uint[] memory points = new uint[](Finalists.length);
        for(uint i = 0; i < Finalists.length; i++){
            points[i] = Details[Finalists[i]].VotesFromJudges*WeightageOfJudge + Details[Finalists[i]].VotesFromAudience*WeightageOfAudience;
        }
        uint max = points[0];
        for(uint i = 1; i < Finalists.length; i++){
            if(max < points[i]){
                max = points[i];
                //winnerList = Finalists[i];
            } 
        }
        uint count = 0;
        for(uint i = 0; i < Finalists.length; i++){    
            if(max == points[i]){
                winnerList[count] = Finalists[i];
                count++;
            }
        }
        address[] memory Result = new address[](count);
        for(uint j = 0; j < count ; j++){
            Result[j] = winnerList[j];
        }
        return Result;

    }

}
