
pragma solidity ^0.6.0;

import "../../GSN/Context.sol";
import "./ERC721.sol";

abstract contract ERC721Burnable is Context, ERC721 {
   
    function burn(uint256 tokenId) public virtual {
       
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
        _burn(tokenId);
    }
}