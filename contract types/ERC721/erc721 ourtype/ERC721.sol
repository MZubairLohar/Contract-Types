pragma solidity ^0.6.0;

import "./ERC165.sol";
//import "./SafeMath.sol";
import "./IERC721.sol";


 contract ERC721 is ERC165, IERC721{
  //   using SafeMath for uint256;
    
    
    
    
     
    //constructor
    
    constructor(string memory name,string memory symbol) public{
        _name = name;
        _symbol = symbol;
      
        _registerInterface(_INTERFACE_ID_ERC721);
    }
    
    
    //events
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
    
    
    
    
    //state variable
    
    string private _name;
    string private _symbol;
    uint256 private _totalSupply;
    bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
    
    
    
    
    
    
    
    //mapping
    
    mapping ( address => uint256[] ) private _ownerTokens;
    mapping ( uint256 => address ) private _tokenOwners;
    mapping ( address => mapping ( uint256 => uint256)) private _ownerTokenIndex;
    mapping ( uint256 => address ) private _tokenApprovals;
    mapping ( address => mapping(address => bool)) private _operatorApproval;
    
    
    
    
    
    //view function
     function name() public view returns(string memory){
         return _name;
     }
    
     function symbol() public view returns(string memory){
         return _symbol;
     }
    
    function totalSupply() public view returns(uint){
        return _totalSupply;
    }
    
    
    function balanceOf(address owner) public view override returns(uint256){
        require(owner != address(0), "invalid address");
        return _ownerTokens[owner].length;
    }
    
    function ownerOf( uint256 tokenId) public view override returns(address){
        address owner = _tokenOwners[tokenId];
        require(owner != address(0), "invalid address");
        return owner;
    }
    
    function indexOf(address owner,uint256 _tokenId) public view returns(uint256){
        require(owner != address(0), "invalid address");
        require(_tokenId > 0, "invalid token id");
        return _ownerTokenIndex[owner][_tokenId];
        
    }
    
    function tokenOwnderOfByIndex(address owner, uint256 index) public view returns(uint256){
        require(owner != address(0), "invalid address");
        return _ownerTokenIndex[owner][index];
    }
    
     function setApprovedForAll(address operator, bool approved) public view override returns(bool) {
        require( operator != msg.sender, " ");
        _operatorApproval[msg.sender][operator];
        emit ApprovalForAll(msg.sender, operator, approved );
    }
    
     function getApproved(uint256 tokenId) public view override returns(address){
        require(_exist(tokenId), "id doesnt exist");
        return _tokenApprovals[tokenId];
    }
    
    function _exist(uint256 tokenId) internal view returns(bool){
        require(tokenId > 0, " enter valid token Id");
        address owner = _tokenOwners[tokenId];
        if( owner != address(0)){
            return true;
        }
        return false;
    }
    
    
    function isApprovedForAll( address owner, address spender) internal view returns(bool){
         return _operatorApproval[owner][spender];
    } 
    
    function _isApproveOrOwner(address spender, uint256 tokenId) internal view returns(bool){
        require(_exist(tokenId),"invalid token ID");
        address owner = ownerOf[tokenId];
        return( spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
    }
    
    
    //trasnfer functions
    
    function approve(address to, uint256 tokenId) public virtual override{
        address owner = ownerOf[tokenId];
        require(owner != to, "approval to current owner");
        require(owner == msg.sender || isApprovedForAll(owner. msg.sender), "approve caller is not owner approve for all");
        _approve(to, tokenId);
    }
    
   
    function isApprovedForAll(address owner, address operator) public virtual override {
         return _operatorApproval[owner][operator];
    }
    
    function transfer(address to, uint256 tokenId) public virtual{
        require(_isApproveOrOwner(msg.sender,tokenId), "transfer caller is not owner");
        address from = msg.sender;
        _transfer(from, to, tokenId);
        
    }
    
    function transferFrom(address from, address to, uint256 tokenId) public virtual override{
        require(_isApproveOrOwner(from, tokenId), "approve caller is not owner");
        _transfer(from, to, tokenId);
    }
   
    
   
   
   
   
    // private or internal functions
    function _approve(address to,uint256 tokenId) private {
        _tokenApprovals[tokenId] = to;
        emit Approval(ownerOf(tokenId), to, tokenId);
    }
    
    
    function _mint(address to, uint256 tokenId) internal virtual{
        require( to != address(0), "Enter valid address");
        totalSupply = totalSupply.add(1);
        _addToken(to, tokenId);
        emit Transfer(address(0), to, tokenId);
    }
    
    
    function burn(uint256 tokenId) internal virtual{
        owner = ownerOf[tokenId];
        _approve(address(0),tokenId);
        if( bytes(_tokenURI[tokenId]).length != 0){
         delete _tokenURI[tokenId];
        }
        deleteToken (owner,tokenId);
        _totalSupply = _totalSupply.sub(1);
        
    }
    
    
    
    //safemath functions
        
    function add(uint256 a, uint256 b) internal pure returns(uint256){
        uint256 c = a + b;
        require ( c >= a , " SafeMath: addition overflow");
        return c;
    }
    
    function sub(uint256 a, uint256 b) internal pure returns(uint256){
        require ( b <= a , " SafeMath: subtraction overflow");
        uint256 c = a - b;
        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns(uint256){
        require(sub(a,b)," subtraction flow");
    }



 }