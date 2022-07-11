const { expect } = require("chai");
const { ethers } = require("hardhat");
const { signWhitelist } = require("../scripts/utility");
describe("NFT PROJECT", function () {
  let nft;
  let owner, user1, user2;
  let price = ethers.utils.parseEther("0.085");
  let whitelistPrice = ethers.utils.parseEther("0.075");
  let wlSignature;
  beforeEach(async function () {
    [owner, user1, user2] = await ethers.getSigners();
    const NFtProjectFirst = await ethers.getContractFactory("NFTProject");
    nft = await NFtProjectFirst.deploy("CodeGiantNFT", "CGN");
    await nft.deployed();
    wlSignature = await signWhitelist(owner, nft.address, owner.address, 2);
    // wlSignatureUser1 = await signWhitelist(
    //   owner,
    //   nft.address,
    //   user1.address,
    //   2
    // );
  });
  it("Check if contract is paused", async function () {
    expect(await nft.paused()).equal(false);
  });
  it("check for currentTokenCount", async function () {
    expect(await nft.currentTokenCount()).equal(0);
  });
  it("whitList Mint", async function () {
    expect(await nft.publicSaleActive()).equal(false);
    // await expect(nft.tokenURI(1)).to.be.revertedWith("NFT not existed");
    await nft.whiteListMint(2, 2, wlSignature, {
      value: whitelistPrice.mul(3),
    });
    expect(await nft.currentTokenCount()).equal(3);
    expect(await nft.whitelistClaimed(owner.address)).equal(true);
  });

  it("public mint", async function () {
    await nft.setPublicSaleActive(true);
    expect(await nft.publicSaleActive()).equal(true);
    await nft.mint(1, { value: price });
    expect(await nft.currentTokenCount()).equal(4);
  });
});
