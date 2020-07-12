pragma solidity ^0.6.0;

import "./ERC165.sol";
import "./SafeMath.sol";
import "./IERC721.sol";


 contract ERC721 is ERC165, IERC721{
     using SafeMath for uint256;
    
    
    
    
     
    //constructor
    
    constructor(string memory name,string memory symbol) public{
        _name = name;
        _symbol = symbol;
      
        _registerInterface(_INTERFACE_ID_ERC721);
    }
    
    
    //events
    
    
    
    
    
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
    
   
   
   
   
   
    // private functions
    function _approve(address to,uint256 tokenId) private {
        _tokenApprovals[tokenId] = to;
        emit Approval(ownerOf(tokenId), to, tokenId);
    }
    
    
    
    
    
    //safemath functions
 }