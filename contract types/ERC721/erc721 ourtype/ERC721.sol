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
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
    
    
    
    
    //state variable
    
    string private _name;
    string private _symbol;
    uint256 private _totalSupply;
    bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
    uint256 private tokenIdCounter;
    
    
    
    
    
    
    //mapping
    
    mapping ( address => uint256[] ) private _ownerTokens;
    mapping ( uint256 => address ) private _tokenOwners;
    mapping ( address => mapping ( uint256 => uint256)) private _ownerTokenIndex;
    mapping ( uint256 => address ) private _tokenApprovals;
    mapping ( address => mapping(address => bool)) private _operatorApprovals;
    mapping ( uint256 => string ) private _tokenURIs;
    
    
    
    
    
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
    
     function setApprovalForAll(address operator, bool approved) public virtual override {
        require( operator != msg.sender, " approve to caller");
        _operatorApprovals[msg.sender][operator];
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
    
    
    
    
    function _isApproveOrOwner(address spender, uint256 tokenId) internal view returns(bool){
        require(_exist(tokenId),"invalid token ID");
        address owner = ownerOf(tokenId);
        return( spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
    }
    
    
    
    
    
    
    
    
    //trasnfer functions
    
    function approve(address to, uint256 tokenId) public virtual override{
        address owner = ownerOf(tokenId);
        require(owner != to, "approval to current owner");
       // require(owner == msg.sender || isApprovedForAll(owner, msg.sender), "approve caller is not owner approve for all");
        _approve(to, tokenId);
    }
    
   
    function isApprovedForAll(address owner, address operator) public view override returns (bool){
         return _operatorApprovals[owner][operator];
    }
    
    function transfer(address to, uint256 tokenId) public virtual{
        require(_isApproveOrOwner(msg.sender,tokenId), "transfer caller is not owner");
        address from = msg.sender;
        _transfer(from, to, tokenId);
        
    }
    
    function transferFrom(address from, address to, uint256 tokenId) public override{
        require(_isApproveOrOwner(from, tokenId), "approve caller is not owner");
        _transfer(from, to, tokenId);
    }
   
    
   
   
   
   
    // private or internal functions
    
    
    
    
    function _approve(address to,uint256 tokenId) private {
        _tokenApprovals[tokenId] = to;
        emit Approval(ownerOf(tokenId), to, tokenId);
    }
    
    
    function _mint(address to, uint256 tokenId) internal {
        require( to != address(0), "Enter valid address");
       _totalSupply = _totalSupply.add(1);
        _addToken(to, tokenId);
        emit Transfer(address(0), to, tokenId);
    }
    
    
    function burn(uint256 tokenId) internal virtual{
        address owner = ownerOf(tokenId);
        _approve(address(0),tokenId);
        if( bytes(_tokenURIs[tokenId]).length != 0){
         delete _tokenURIs[tokenId];
        }
        _deleteToken(owner,tokenId);
        _totalSupply = _totalSupply.sub(1);
        emit Transfer(owner, address(0), tokenId);
    }
    
    function _transfer(address from, address to, uint256 tokenId) internal virtual{
        require(tokenId > 0, "invalid token Id");
        require(ownerOf(tokenId) == from, "non existing token");
        require(to != address(0), "invalid address");
        _approve(address(0), tokenId);
        _deleteToken(from, tokenId);
        _addToken(to, tokenId);
        emit Transfer(from, to, tokenId);
    }
    
    function _addToken(address owner, uint256 tokenId) internal virtual returns(bool success, uint256 newIndex){
        require(!_exist(tokenId),"token ID already exist");
        require(_tokenOwners[tokenId] != owner ,"already owner of this token");
        _tokenOwners[tokenId] = owner;
        _ownerTokens[owner].push(tokenId);
        newIndex = _ownerTokens[owner].length-1;
        _ownerTokenIndex[owner][tokenId] = newIndex;
        success = true;
    }
    
    
    function _deleteToken(address owner, uint256 tokenId) internal virtual returns(bool success, uint256 Index){
        require(_exist(tokenId),"token ID is non-existing");
        require(_tokenOwners[tokenId] == owner, "not correct owner of token");
         Index = _ownerTokenIndex[owner][tokenId];
        if( _ownerTokens[owner].length>1){
            uint256 lastToken = _ownerTokens[owner][_ownerTokens[owner].length-1] ; 
            _ownerTokens[owner][Index] = lastToken;
            _ownerTokenIndex[owner][lastToken] = Index;
        }
        _ownerTokens[owner].pop();
        delete _ownerTokenIndex[owner][tokenId];
        delete _tokenOwners[tokenId];
        success = true;
    }
    
    
    function _setTokenURI(uint256 tokenId,string memory _tokenURI ) internal virtual{
        require(_exist(tokenId),"non-existing token");
        _tokenURIs[tokenId] = _tokenURI;
    }
    
    
    // main logic for real state
    
    function registerProperty(string memory PlotNo) public {
        tokenIdCounter = tokenIdCounter.add(1);
        _mint(msg.sender, tokenIdCounter);
        _setTokenURI(tokenIdCounter,PlotNo);
        
    }
    


 }