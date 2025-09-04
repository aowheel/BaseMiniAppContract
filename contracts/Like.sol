// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Book} from "./Book.sol";
import {Review} from "./Review.sol";

contract Like is ERC20 {
    Book private _book;
    Review private _review;
    uint256 private _share;

    constructor(
        address bookAddress,
        address reviewAddress,
        uint256 share
    ) ERC20("LikeToken", "LIKE") {
        _book = Book(bookAddress);
        _review = Review(reviewAddress);
        _share = share;
    }

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }

    event LikeDistributed(
        address from,
        uint256 bookId,
        uint256 reviewId,
        uint256 amount
    );

    function distribute(
        uint256 bookId,
        uint256 reviewId,
        uint256 amount
    ) public {
        address bookOwner = _book.ownerOf(bookId);
        require(bookOwner != address(0), "Book does not exist");
        address reviewOwner = _review.ownerOf(reviewId);
        require(reviewOwner != address(0), "Review does not exist");
        uint256 bookShare = (amount * _share) / 100;
        uint256 reviewShare = amount - bookShare;
        _transfer(msg.sender, bookOwner, bookShare);
        _transfer(msg.sender, reviewOwner, reviewShare);
        emit LikeDistributed(msg.sender, bookId, reviewId, amount);
    }

    function batchDistribute(
        uint256[] calldata bookIds,
        uint256[] calldata reviewIds,
        uint256[] calldata amounts
    ) external {
        require(
            bookIds.length == reviewIds.length &&
                bookIds.length == amounts.length,
            "Array length mismatch"
        );
        for (uint256 i = 0; i < bookIds.length; i++) {
            distribute(bookIds[i], reviewIds[i], amounts[i]);
        }
    }
}
