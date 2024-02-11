// SPDX-License-Identifier: default
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Roulette is ERC20 {
    address owner;
    uint256 public SpinWheelResult;
    bool SpinWheelDone;
    mapping(uint => address[]) public betDetails; //for particular number, who bets
    //mapping(string => address[]) public bets; //for "even", "odd", "onDigit", who bets
    address[] EvenPublic;
    address[] OddPublic;
    address[] OnDigitPublic;
    mapping(address => uint256) NumberDigit; //In which digit they bet
    mapping(address => uint256) TokenAmount; //How much amount of tokens is being used for bets.
    //mapping(address => uint256) public TokensPlayers;
    constructor() ERC20("Roulette", "RLT") {
        owner = msg.sender;
    }

    function setSpinWheelResult(uint256 key) public {
        SpinWheelResult = key;
    }

    function buyTokens() public payable{
        require(msg.value > 0);
        uint value = (msg.value * 1000) / 1000000000000000000;
        _mint(msg.sender, value);
        //_mint(owner,value);
        emit Transfer(owner,msg.sender, value);
        //emit Transfer(owner, owner, value);
    }

    function placeBetEven(uint256 betAmount) public {
        require(balanceOf(msg.sender) >= betAmount,"You have not enough tokens to bet.");
        _burn(msg.sender, betAmount);
        //uint amount = (betAmount * 1000000000000000000) / 1000;
        //payable(address(this)).transfer(amount);
        emit Transfer(msg.sender, 0x0000000000000000000000000000000000000000, betAmount);
        EvenPublic.push(msg.sender);
       
        
        TokenAmount[msg.sender] = betAmount;
    }

    function placeBetOdd(uint256 betAmount) public {
        require(balanceOf(msg.sender) >= betAmount,"You have not enough tokens to bet.");
        _burn(msg.sender, betAmount);
        
        emit Transfer(msg.sender, 0x0000000000000000000000000000000000000000, betAmount);
        
        OddPublic.push(msg.sender);
        TokenAmount[msg.sender] = betAmount;
    }

    function placeBetOnNumber(uint256 betAmount, uint256 number) public {
        require(balanceOf(msg.sender) >= betAmount,"You have not enough tokens to bet.");
        _burn(msg.sender, betAmount);
       
        emit Transfer(msg.sender, 0x0000000000000000000000000000000000000000, betAmount);
        
        betDetails[number].push(msg.sender);
        OnDigitPublic.push(msg.sender);
        NumberDigit[msg.sender] = number;
        TokenAmount[msg.sender] = betAmount;
    }

    function spinWheel() public {
        require(msg.sender == owner, "Permission denied");
        SpinWheelResult = uint256(keccak256(abi.encodePacked(block.timestamp))) %  36;
        SpinWheelDone = true;
    }

    function sellTokens(uint256 tokenAmount) public payable{
        require(balanceOf(msg.sender) >= tokenAmount,"You have not enough tokens.");
        uint amount = (tokenAmount * 1000000000000000000) / 1000;
        _burn(msg.sender, tokenAmount);
       
        emit Transfer(msg.sender, 0x0000000000000000000000000000000000000000, tokenAmount);
        
        payable (msg.sender).transfer(amount);
    }

    function transferWinnings() public{
        require(msg.sender == owner,"Permission Denied.");
        require(SpinWheelDone == true,"Winner is not being choosen.");
        uint value;
        for(uint i = 0; i < OnDigitPublic.length; i++){
            if(NumberDigit[OnDigitPublic[i]] == SpinWheelResult){
                value = TokenAmount[OnDigitPublic[i]] + (TokenAmount[OnDigitPublic[i]]*1800)/100;
                _mint(OnDigitPublic[i], value);
                emit Transfer(0x0000000000000000000000000000000000000000, OnDigitPublic[i], value);
                
            }
        }
        if(SpinWheelResult % 2 == 0){
            for(uint i = 0; i < EvenPublic.length; i++){
                value = TokenAmount[EvenPublic[i]] + (TokenAmount[EvenPublic[i]]*80)/100;
                _mint(EvenPublic[i], value);
                emit Transfer(0x0000000000000000000000000000000000000000, EvenPublic[i], value);
                
            }
        }
        else{
            for(uint i = 0; i < OddPublic.length; i++){
                value = TokenAmount[OddPublic[i]] + (TokenAmount[OddPublic[i]]*80)/100;
                _mint(OddPublic[i], value);
                emit Transfer(0x0000000000000000000000000000000000000000, OddPublic[i], value);
                
            }
        }
    }

    function checkBalance() public view returns (uint256) {
        return balanceOf(msg.sender);
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
        for(uint i = 0; i < EvenPublic.length; i++){
            arr[index] = TokenAmount[EvenPublic[i]];
            index++;
        }
        return (EvenPublic,arr);
    }

    function checkBetsOnOdd()
        public
        view
        returns (address[] memory, uint256[] memory)
    {
        uint[] memory arr;
        uint index;
        for(uint i = 0; i < OddPublic.length; i++){
            arr[index] = TokenAmount[OddPublic[i]];
            index++;
        }
        return (OddPublic,arr);
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
        for(uint i = 0; i < OnDigitPublic.length; i++){
            arr[index] = NumberDigit[OnDigitPublic[i]];
            index++;
        }
        uint[] memory arr1;
        uint index1;
        for(uint i = 0; i < OnDigitPublic.length; i++){
            arr1[index1] = TokenAmount[OnDigitPublic[i]];
            index1++;
        }
        return (OnDigitPublic,arr,arr1);
    }
}