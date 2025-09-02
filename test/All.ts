import assert from "node:assert/strict";
import { describe, it } from "node:test";
import { network } from "hardhat";
import { encodePacked, keccak256 } from "viem";
import All from "../ignition/modules/All.js";

describe("All", async () => {
	const { viem } = await network.connect();
	const [operation, reviewer1, reviewer2, viewer1, viewer2] =
		await viem.getWalletClients();
	it("should pass integration tests", async () => {
		const { ignition } = await network.connect();
		const { book, review, like } = await ignition.deploy(All);
		// Mint a new book
		await book.write.mint([operation.account.address, "ipfs://book-example"], {
			account: reviewer1.account,
		});
		const bookURI = await book.read.tokenURI([0n]);
		assert.equal(bookURI, "ipfs://book-example");
		// Mint a new review
		await review.write.mint([0n, "ipfs://review-example1"], {
			account: reviewer1.account,
		});
		const reviewId1 = BigInt(
			keccak256(
				encodePacked(["address", "uint256"], [reviewer1.account.address, 0n]),
			),
		);
		const reviewURI1 = await review.read.tokenURI([reviewId1]);
		assert.equal(reviewURI1, "ipfs://review-example1");
		// Mint a new review
		await review.write.mint([0n, "ipfs://review-example2"], {
			account: reviewer2.account,
		});
		const reviewId2 = BigInt(
			keccak256(
				encodePacked(["address", "uint256"], [reviewer2.account.address, 0n]),
			),
		);
		const reviewURI2 = await review.read.tokenURI([reviewId2]);
		assert.equal(reviewURI2, "ipfs://review-example2");
		// Mint new likes and distribute
		await like.write.mint([viewer1.account.address, 100n]);
		await like.write.distribute(
			[
				0n,
				BigInt(
					keccak256(
						encodePacked(
							["address", "uint256"],
							[reviewer1.account.address, 0n],
						),
					),
				),
				50n,
			],
			{ account: viewer1.account },
		);
		// Mint new likes and distribute
		await like.write.mint([viewer2.account.address, 200n]);
		await like.write.distribute(
			[
				0n,
				BigInt(
					keccak256(
						encodePacked(
							["address", "uint256"],
							[reviewer2.account.address, 0n],
						),
					),
				),
				100n,
			],
			{ account: viewer2.account },
		);
	});
});
