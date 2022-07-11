const hre = require("hardhat");

async function main() {
  const NFT = await hre.ethers.getContractFactory("NFTProject");
  const SelectedMintNFT = await hre.ethers.getContractFactory(
    "NFTSelectiveMint"
  );
  const nft = await NFT.deploy("CodeGiantNFT", "CGN");
  const selectedMintNft = await SelectedMintNFT.deploy(
    "CodeGiantNFTWithId",
    "CGNWID"
  );

  await nft.deployed();
  await selectedMintNft.deployed();

  console.log("NFT deployed to:", nft.address);
  console.log("selectedMintNft deployed to:", selectedMintNft.address);
}


main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

// Noraml NFT 0xddDF453957b6588C7508993d5c2d009120eCBA9D
// selectedId NFT  0x52Bc577ABE9FC56945479083D983B89B2374986C
