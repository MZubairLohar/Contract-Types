pragma solidity ^0.6.0;

contract project{
    
    string private name;
    string private symbol;
    uint8 private decimal;
    uint256 private totalSupply;
    address payable _admin;
    
    modifier adminOnly(address admin){
        if(admin == msg.sender){
            _;
        }
    }
    mapping(address => uint256) public balanceOF;
    
    constructor () public{
        name = "ZubToken";
        symbol = "Z";
        decimal = 10;
       totalSupply = 100000;
    }
    
    function TotalSupply( ) public view returns(uint256){
            //_amount = totalSupply;
            return(totalSupply);
    }
    
    function nameSymbolDecimalSupply() public view returns(string memory,string memory, uint8, uint256){
        return (name, symbol, decimal, totalSupply);
        
    }
    // function balance(address _check) public view returns(uint256){
    //     return uint256(_check);
    // }
    
    function _burn(uint256 amount) internal virtual{
        totalSupply = totalSupply - amount;
         
    }
    
}

contract burnAbable is project{
    
    function burn(uint256 amount) public{
        _burn( amount);
    }
    
}