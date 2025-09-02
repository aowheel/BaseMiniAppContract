import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("All", (m) => {
	const book = m.contract("Book");
	const review = m.contract("Review", [book]);
	const like = m.contract("Like", [book, review, 50]);
	return { book, review, like };
});
