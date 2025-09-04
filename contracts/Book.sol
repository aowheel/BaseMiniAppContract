// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract Book is ERC721URIStorage {
    uint256 private _nextBookId;

    constructor() ERC721("BookToken", "BOOK") ERC721URIStorage() {}

    event BookMinted(address to, uint256 bookId, string bookURI);

    function mint(address to, string memory bookURI) external {
        uint256 bookId = _nextBookId++;
        _mint(to, bookId);
        _setTokenURI(bookId, bookURI);
        emit BookMinted(to, bookId, bookURI);
    }
}
