pragma solidity ^0.4.24;

contract Matches{
    struct aMatch{
        string team1;
        string team2;
        int startDateTime;
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
        string accntName;
        string win;
    }
    aBet[] allBets;
    
    struct anAccount{
        string accntName;
        int purse;
    }
    anAccount[] allAccounts;
    
    function chkMatch(string teamHome, string teamAway, uint phase) public returns (bool){
        uint i;
        for(i=0;i<allMatches.length;i++){
            if(compareStrings(allMatches[i].team1,teamHome) && compareStrings(allMatches[i].team2,teamAway) && allMatches[i].phase==phase){
                return true;
            }
        }
        return false;
    }
    
    function addMatch(string teamHome, string teamAway, uint phase, int matchStartDateTime, uint minimumBet) public returns (bool){
        if(!chkMatch(teamHome,teamAway,phase)){
            allMatches.push(aMatch(teamHome,teamAway,matchStartDateTime,minimumBet,phase));
            return true;
        }
        return false;
    }
    
    function getAllMatchsCount() public returns (uint){
        return allMatches.length;
    }
    
    function getMatchDetails(uint i) public returns (string,string,uint,int,uint){
        //Team 1, Team 2, isKnockOut, startDateTime, minimum Bet
        return(allMatches[i].team1,allMatches[i].team2,allMatches[i].phase,allMatches[i].startDateTime,allMatches[i].minBet);
    }
    
    function deleteMatch(uint i) public{
        delete allMatches[i];
    }
    
    function updateMatch(string teamHome, string teamAway, uint phase, int matchStartDateTime, uint minimumBet) public{
        //Only startdatetime & minimum bet can be updated
        uint i;
        for(i=0;i<allMatches.length;i++){
            if(compareStrings(allMatches[i].team1,teamHome) && compareStrings(allMatches[i].team2,teamAway) && allMatches[i].phase==phase){
                allMatches[i].startDateTime=matchStartDateTime;
                allMatches[i].minBet=minimumBet;
            }
        }
    }
    
    function setBet(string team1, string team2, uint phase, uint team1Score, uint team2Score, uint betAmount, string accntName) public returns (bool){
        
        uint j;
        string memory winTeam;
        if(team1Score>team2Score){
            winTeam=team1;
        }
        if(team1Score<team2Score){
            winTeam=team2;
        }
        if(team1Score==team2Score){
            winTeam="draw";
        }
        //Create
        for(j=0;j<allBets.length;j++){
            if(!(compareStrings(allBets[i].team1,team1) && compareStrings(allBets[i].team2,team2) && allBets[i].phase==phase && compareStrings(allBets[i].accntName,accntName))){
                allBets.push(aBet(team1,team2,phase,team1Score,team2Score,betAmount,accntName,winTeam));
                return true;
            }    
        }
        //Update
        uint i;
        for(i=0;i<allBets.length;i++){
            if(compareStrings(allBets[i].team1,team1) && compareStrings(allBets[i].team2,team2) && allBets[i].phase==phase && compareStrings(allBets[i].accntName,accntName)){
                allBets[i].team1Score=team1Score;
                allBets[i].team2Score=team2Score;
                allBets[i].betAmount=betAmount;
                allBets[i].win=winTeam;
                return true;
            }
        }
        return false;
    }
    
    function deleteBet(string team1, string team2, uint phase, string accntName) public returns (bool){
        uint i;
        for(i=0;i<allBets.length;i++){
            if(compareStrings(allBets[i].team1,team1) && compareStrings(allBets[i].team2,team2) && allBets[i].phase==phase && compareStrings(allBets[i].accntName,accntName)){
                delete allBets[i];
                return true;
            }
        }
        return false;
    }
    
    function getBetFor(string team1, string team2, uint phase, string accntName) public returns (uint){
        uint i;
        for(i=0;i<allBets.length;i++){
            if(compareStrings(allBets[i].team1,team1) && compareStrings(allBets[i].team2,team2) && allBets[i].phase==phase && compareStrings(allBets[i].accntName,accntName)){
                return allBets[i].betAmount;
            }
        }
        return 0;
    }
    
    //Collation of all bets per account
    function accountMaster(string accntName, int amt, bool isCredit){
        uint i;
        bool flag=false;
        for(i=0;i<=allAccounts.length;i++){
            if(compareStrings(allAccounts[i].accntName,accntName)){
                flag=true;
            }
        }
        if(flag==false){
            allAccounts.push(anAccount(accntName,0));
        }
        
        for(i=0;i<=allAccounts.length;i++){
            if(compareStrings(allAccounts[i].accntName,accntName)){
                if(isCredit){
                    allAccounts[i].purse=allAccounts[i].purse+amt;
                }
                else{
                    allAccounts[i].purse=allAccounts[i].purse-amt;
                }
            }
        }
    }
    
    function getPurseFor(string accntName) public returns (int){
        uint i;
        for(i=0;i<=allAccounts.length;i++){
            if(compareStrings(allAccounts[i].accntName,accntName)){
                return allAccounts[i].purse;
                break;
            }
        }
    }
    
    function payout(string team1, string team2, uint phase, uint team1Score, uint team2Score) returns (bool){
        uint i;
        string memory winTeam;
        string[] winner;
        bool flag=false;
        uint totalPot;
        uint winAmount;
        
        if(team1Score>team2Score){
            winTeam=team1;
        }
        if(team1Score<team2Score){
            winTeam=team2;
        }
        if(team1Score==team2Score){
            winTeam="draw";
        }
        
        if(!chkMatch(team1,team2,phase)){
            return false;
        }
        
        //calculate Total Pot and remove bet amount from purse
        for(i=0;i<=allBets.length;i++){
            if(compareStrings(allBets[i].team1,team1) && compareStrings(allBets[i].team2,team2) && allBets[i].phase==phase){
                accountMaster(allBets[i].accntName,int(allBets[i].betAmount),false);
                totalPot=totalPot+allBets[i].betAmount;
            }
        }
        //perfect score
        for(i=0;i<=allBets.length;i++){
            if(compareStrings(allBets[i].team1,team1) && compareStrings(allBets[i].team2,team2) && allBets[i].phase==phase){
                if(allBets[i].team1Score==team1Score && allBets[i].team2Score==team2Score){
                    winner.push(allBets[i].accntName);
                    flag=true;
                }
            }
        }
        
        //for correct outcome
        if(flag==false){
            for(i=0;i<=allBets.length;i++){
                if(compareStrings(allBets[i].team1,team1) && compareStrings(allBets[i].team2,team2) && allBets[i].phase==phase){
                    if(compareStrings(allBets[i].win,winTeam)){
                        winner.push(allBets[i].accntName);
                        flag=true;
                    }
                }
            }
        }
        
        if(winner.length>0){
            winAmount=totalPot/winner.length;
            for(i=0;i<=winner.length;i++){
                accountMaster(winner[i],int(winAmount),true);
            }
        }
        return flag;
    }

    //General functions
    function compareStrings (string a, string b) public returns (bool){
       return keccak256(a) == keccak256(b);
    }
}