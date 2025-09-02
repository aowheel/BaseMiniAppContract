// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {Book} from "./Book.sol";

contract Review is ERC721URIStorage {
    Book private _book;

    constructor(
        address bookAddress
    ) ERC721("ReviewToken", "REVIEW") ERC721URIStorage() {
        _book = Book(bookAddress);
    }

    function mint(uint256 bookId, string memory reviewURI) external {
        require(_book.ownerOf(bookId) != address(0), "Book does not exist");
        uint256 reviewId = uint256(
            keccak256(abi.encodePacked(msg.sender, bookId))
        );
        _mint(msg.sender, reviewId);
        _setTokenURI(reviewId, reviewURI);
    }

    function setBookURI(uint256 bookId, string memory bookURI) external {
        uint256 reviewId = uint256(
            keccak256(abi.encodePacked(msg.sender, bookId))
        );
        require(msg.sender == _ownerOf(reviewId), "Caller is not the owner");
        _setTokenURI(reviewId, bookURI);
    }
}
