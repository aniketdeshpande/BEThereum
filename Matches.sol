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
        uint i;
        for(i=0;i<allMatches.length;i++){
            if(compareStrings(allMatches[i].team1,teamHome) && compareStrings(allMatches[i].team2,teamAway) && allMatches[i].phase==phase){
                allMatches[i].startDateTime=matchStartDateTime;
                allMatches[i].minBet=minimumBet;
            }
        }
    }
    
    
    //General functions
    function compareStrings (string a, string b) public returns (bool){
       return keccak256(a) == keccak256(b);
    }
}