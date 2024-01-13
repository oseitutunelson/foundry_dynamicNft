//SPDX-License-Identifier:MIT

pragma solidity ^0.8.18;

/**
 * @title MoodNft
 * @author Owusu Nelson Osei Tutu
 * @notice This contract is a dynamic nft -- mood svg or imoji that changes state based on certain conditions
 */

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721{
    error MoodNft__CanotFlip();

    uint256 private s_tokenCounter;
    string private s_sadSvgImageUri;
    string private s_happySvgImageUri;

    //mood enum
    enum Mood{
        HAPPY,
        SAD
    }

    //mapping of tokenid to mood
    mapping(uint256 => Mood) private s_tokenIdToMood;

    constructor(string memory sadSvgImageUri,string memory happySvgImageUri) ERC721("MoodNft","MNT"){
         s_tokenCounter = 0;
         s_happySvgImageUri = happySvgImageUri;
         s_sadSvgImageUri = sadSvgImageUri;
    }

    //function to mint nfts
    function mintNft() public{
        _safeMint(msg.sender,s_tokenCounter);
        s_tokenCounter++;
    }

    //flip mood of nft
    function flipMood(uint256 tokenId) public{
        if(getApproved(tokenId) != msg.sender && ownerOf(tokenId) != msg.sender){
            revert MoodNft__CanotFlip();
        }
         if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            s_tokenIdToMood[tokenId] = Mood.SAD;
        } else {
            s_tokenIdToMood[tokenId] = Mood.HAPPY;
        }
    }

    //function of baseURI
    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    //function of tokenURI
    function tokenURI(uint256 tokenId) override public view returns (string memory){
     string memory imageURI;
    if(s_tokenIdToMood[tokenId] == Mood.HAPPY){
        imageURI = s_happySvgImageUri;
    }else{
        imageURI = s_sadSvgImageUri;
    }

     
        return string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(
                    bytes( 
                        abi.encodePacked(
                            '{"name":"',
                            name(), 
                            '", "description":"An NFT that reflects the mood of the owner, 100% on Chain!", ',
                            '"attributes": [{"trait_type": "moodiness", "value": 100}], "image":"',
                            imageURI,
                            '"}'
                        )
                    )
                )
            ));
    }
}