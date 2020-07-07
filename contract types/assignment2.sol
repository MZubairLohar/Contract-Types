pragma solidity ^0.6.0;

import "./Address.sol";
//import "./Context.sol";
import "./SafeMath.sol";

contract cappingOne{
    using Address for address;
    using SafeMath for uint256;
    

string internal name;
string internal symbol;
uint256 internal decimal;
uint256 internal totalSupply;

event Transfer (address sender, address recipient, uint256 amount);

mapping (address => uint256) _balance;


constructor (string memory _name, string memory _symbol, uint256 _decimal, uint256 _totalSupply) public {
    _name = name;
    _symbol = symbol;
    _decimal = decimal;
    _totalSupply = totalSupply;
}
    function update(string memory _name, string memory _symbol, uint256 _decimal, uint256 _totalSupply ) public {
        name = _name;
        symbol = _symbol;
        decimal = _decimal;
        totalSupply = _totalSupply;
    }
    function contractDetails()public view returns(string memory, string memory, uint256, uint256){
        return(name, symbol, decimal, totalSupply);
    
    }
    function balanceOf(address account) public view returns(uint256){
        return _balance[account];
    }
    function transfer( address recipient , uint256 amount) public returns (bool){
        _transfer(_msgSender(), recipient, amount);
        return true;
    }
    function _transfer(address sender, address recipient, uint256 amount) internal virtual{
        require(sender != address(0),"transfer from zero address");
        require(recipient != address(0),"transfer to address Zero");
      //  _beforeTokenTransfer(sender, recipient, amount);
        _balance[sender] = _balance[sender].sub(amount, "transfer amount exceeds balance");
        _balance[recipient] = _balance[recipient].add(amount);
        emit Transfer (sender , recipient, amount);
        
    }
    function _msgSender() internal view returns(address payable){
        this;
        return msg.sender;
        
    }
    function _msgData() internal view returns(bytes memory){
        this;
        return msg.data;
    }
} 
