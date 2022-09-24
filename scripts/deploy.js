const hre = require("hardhat");

async function main() {
  const NFT = await hre.ethers.getContractFactory("LittleAngels");
  const nft = await NFT.deploy("LittleAngels", "LAS");

  await nft.deployed();

  console.log("NFT deployed to:", nft.address);
}


main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

// Noraml NFT 0x9eDC1B6aAd9E36E4eb56061eF0875508c4047682
