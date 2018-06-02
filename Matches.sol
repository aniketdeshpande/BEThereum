pragma solidity ^0.4.24;

contract Matches{
    struct aMatch{
        string team1;
        string team2;
        uint startDateTime;
        uint minBet;
        uint phase;
    }
    aMatch[] allMatches;
    
    struct aBet{
        string team1;
        string team2;
        uint phase;
        uint team1Score;
        uint team2Score;
        uint betAmount;
        address accntName;
    }
    aBet[] allBets;
    
    function chkMatch(string teamHome, string teamAway, uint phase) public returns (bool){
        uint i;
        for(i=0;i<allMatches.length;i++){
            if(compareStrings(allMatches[i].team1,teamHome) && compareStrings(allMatches[i].team2,teamAway) && allMatches[i].phase==phase){
                return true;
            }
        }
        return false;
    }
    
    function addMatch(string teamHome, string teamAway, uint phase, uint matchStartDateTime, uint minimumBet) public returns (bool){
        if(!chkMatch(teamHome,teamAway,phase)){
            allMatches.push(aMatch(teamHome,teamAway,matchStartDateTime,minimumBet,phase));
            return true;
        }
        return false;
    }
    
    function getAllMatchsCount() public returns (uint){
        return allMatches.length;
    }
    
    function getMatchDetails(uint i) public returns (string,string,uint,uint,uint){
        //Team 1, Team 2, isKnockOut, startDateTime, minimum Bet
        return(allMatches[i].team1,allMatches[i].team2,allMatches[i].phase,allMatches[i].startDateTime,allMatches[i].minBet);
    }
    
    function deleteMatch(uint i) public{
        delete allMatches[i];
    }
    
    function updateMatch(string teamHome, string teamAway, uint phase, uint matchStartDateTime, uint minimumBet) public{
        //Only startdatetime & minimum bet can be updated
        uint i;
        for(i=0;i<allMatches.length;i++){
            if(compareStrings(allMatches[i].team1,teamHome) && compareStrings(allMatches[i].team2,teamAway) && allMatches[i].phase==phase){
                allMatches[i].startDateTime=matchStartDateTime;
                allMatches[i].minBet=minimumBet;
            }
        }
    }
    
    function setBet(string team1, string team2, uint phase, uint team1Score, uint team2Score, uint betAmount, address accntName) public returns (bool){
        //Create
        uint j;
        for(j=0;j<allBets.length;j++){
            if(!(compareStrings(allBets[i].team1,team1) && compareStrings(allBets[i].team2,team2) && allBets[i].phase==phase && allBets[i].accntName==accntName)){
                allBets.push(aBet(team1,team2,phase,team1Score,team2Score,betAmount,accntName));
                return true;
            }    
        }
        //Update
        uint i;
        for(i=0;i<allBets.length;i++){
            if(compareStrings(allBets[i].team1,team1) && compareStrings(allBets[i].team2,team2) && allBets[i].phase==phase && allBets[i].accntName==accntName){
                allBets[i].team1Score=team1Score;
                allBets[i].team2Score=team2Score;
                allBets[i].betAmount=betAmount;
                return true;
            }
        }
        return false;
    }
    
    function deleteBet(string team1, string team2, uint phase, address accntName) public returns (bool){
        uint i;
        for(i=0;i<allBets.length;i++){
            if(compareStrings(allBets[i].team1,team1) && compareStrings(allBets[i].team2,team2) && allBets[i].phase==phase && allBets[i].accntName==accntName){
                delete allBets[i];
                return true;
            }
        }
        return false;
    }
    
    //General functions
    function compareStrings (string a, string b) public returns (bool){
       return keccak256(a) == keccak256(b);
    }
}