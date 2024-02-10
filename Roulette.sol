// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Roulette is ERC20 {
    address owner;
    uint256 public SpinWheelResult;
    bool SpinWheelDone;
    mapping(uint => address[]) betDetails;
    mapping(string => address[]) bets;
    mapping(address => uint256) NumberDigit;
    mapping(address => uint256) TokenAmount;
    mapping(address => uint256) public TokensPlayers;
    constructor() ERC20("Roulette", "RLT") {
        owner = msg.sender;
    }

    function setSpinWheelResult(uint256 key) public {}

    function buyTokens() public payable{
        require(msg.value > 0);
        uint value = (msg.value * 1000) / 1000000000000000000;
        _mint(msg.sender, value);
        TokensPlayers[msg.sender] = value;
        
    }

    function placeBetEven(uint256 betAmount) public {
        require(TokensPlayers[msg.sender] >= betAmount,"You have not enough tokens to bet.");
        _burn(msg.sender, betAmount);
        TokensPlayers[msg.sender] -= betAmount;
        bets["even"].push(msg.sender);
        TokenAmount[msg.sender] = betAmount;
    }

    function placeBetOdd(uint256 betAmount) public {
        require(TokensPlayers[msg.sender] >= betAmount,"You have not enough tokens to bet.");
        _burn(msg.sender, betAmount);
        TokensPlayers[msg.sender] -= betAmount;
        bets["odd"].push(msg.sender);
        TokenAmount[msg.sender] = betAmount;
    }

    function placeBetOnNumber(uint256 betAmount, uint256 number) public {
        require(TokensPlayers[msg.sender] >= betAmount,"You have not enough tokens to bet.");
        _burn(msg.sender, betAmount);
        TokensPlayers[msg.sender] -= betAmount;
        betDetails[number].push(msg.sender);
        bets["onDigit"].push(msg.sender);
        NumberDigit[msg.sender] = number;
        TokenAmount[msg.sender] = betAmount;
    }

    function spinWheel() public {
        require(msg.sender == owner, "Permission denied");
        SpinWheelResult = uint256(keccak256(abi.encodePacked(block.timestamp))) %  36;
        SpinWheelDone = true;
    }

    function sellTokens(uint256 tokenAmount) public payable{
        require(TokensPlayers[msg.sender] >= tokenAmount,"You have not enough tokens.");
        uint amount = (tokenAmount * 1000000000000000000) / 1000;
        TokensPlayers[msg.sender] -= tokenAmount;
        payable (msg.sender).transfer(amount);
    }

    function transferWinnings() public{
        require(msg.sender == owner,"Permission Denied.");
        require(SpinWheelDone == true,"Winner is not being choosen.");
        uint value;
        for(uint i = 0; i < bets["onDigit"].length; i++){
            if(NumberDigit[bets["onDigit"][i]] == SpinWheelResult){
                value = TokenAmount[bets["onDigit"][i]] + (TokenAmount[bets["onDigit"][i]]*1800)/100;
                _mint(owner, value);
                TokensPlayers[bets["onDigit"][i]] += value;
            }
        }
        if(SpinWheelResult % 2 == 0){
            for(uint i = 0; i < bets["even"].length; i++){
                value = TokenAmount[bets["even"][i]] + (TokenAmount[bets["even"][i]]*80)/100;
                _mint(owner, value);
                TokensPlayers[bets["even"][i]] += value;
            }
        }
        else{
            for(uint i = 0; i < bets["odd"].length; i++){
                value = TokenAmount[bets["odd"][i]] + (TokenAmount[bets["odd"][i]]*80)/100;
                _mint(owner, value);
                TokensPlayers[bets["odd"][i]] += value;
            }
        }
    }

    function checkBalance() public view returns (uint256) {
        return TokensPlayers[msg.sender];
    }

    function checkWinningNumber() public view returns (uint256) {
        return SpinWheelResult;
    }

    function checkBetsOnEven()
        public
        view
        returns (address[] memory, uint256[] memory)
    {
        uint[] memory arr;
        uint index;
        for(uint i = 0; i < bets["even"].length; i++){
            arr[index] = TokenAmount[bets["even"][i]];
            index++;
        }
        return (bets["even"],arr);
    }

    function checkBetsOnOdd()
        public
        view
        returns (address[] memory, uint256[] memory)
    {
        uint[] memory arr;
        uint index;
        for(uint i = 0; i < bets["odd"].length; i++){
            arr[index] = TokenAmount[bets["odd"][i]];
            index++;
        }
        return (bets["odd"],arr);
    }

    function checkBetsOnDigits()
        public
        view
        returns (
            address[] memory,
            uint256[] memory,
            uint256[] memory
        )
    {
        uint[] memory arr;
        uint index;
        for(uint i = 0; i < bets["onDigit"].length; i++){
            arr[index] = NumberDigit[bets["onDigit"][i]];
            index++;
        }
        uint[] memory arr1;
        uint index1;
        for(uint i = 0; i < bets["onDigit"].length; i++){
            arr1[index1] = TokenAmount[bets["onDigit"][i]];
            index1++;
        }
        return (bets["onDigit"],arr,arr1);
    }
}
