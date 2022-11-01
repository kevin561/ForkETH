// // We require the Hardhat Runtime Environment explicitly here. This is optional
// // but useful for running the script in a standalone fashion through `node <script>`.
// //
// // When running the script with `npx hardhat run <script>` you'll find the Hardhat
// // Runtime Environment's members available in the global scope.
// const { ethers } = require("hardhat");

// async function main() {
//   // 定义变量，user部署Reentrance合约，hacker部署Attack合约
//   const provider = ethers.provider;
//   let Reentrance, reentrance, Attack, attack;
//   let user1;
//   let hacker;

//   const _blockNumber = await ethers.provider.getBlockNumber();
//   console.log("_blockNumber", _blockNumber);

//   const gasPrice = ethers.provider.getGasPrice;

//   console.log("gasPrice", gasPrice);

//   // 取得两个用户账户，分别模拟user1, hacker
//   [user1, hacker] = await ethers.getSigners();

//   console.log("user1 address:", user1.address);
//   console.log("hacker address:", hacker.address);

//   // 使用user1部署Reentrance合约
//   Reentrance = await hre.ethers.getContractFactory("Reentrance", user1);
//   reentrance = await Reentrance.deploy();
//   await reentrance.deployed();

//   // 使用hacker账户部署attack合约，在部署attack时，直接给attack充2个eth
//   let overrides = {
//     value: ethers.utils.parseEther("2"),
//   };
//   Attack = await hre.ethers.getContractFactory("Attack", hacker);
//   attack = await Attack.deploy(overrides);
//   await attack.deployed();

//   TestErc20 = await hre.ethers.getContractFactory("TestErc20", hacker);
//   testErc20 = await TestErc20.deploy(overrides);
//   await testErc20.deployed();

//   // 打印user和hacker的地址，以及部署的Reentrance合约的地址和Attack合约的地址
//   console.log("Contract Reentrance address:", reentrance.address);
//   console.log("Contract Attack address:", attack.address);
//   console.log("Contract testErc20 address:", testErc20.address);
//   console.log(
//     "attack balance:%s",
//     await ethers.utils.formatEther(await provider.getBalance(attack.address))
//   );
//   console.log(
//     "Contract testErc20 balance:",
//     await testErc20.connect(hacker).balanceOf(hacker.address)
//   );

//   await testErc20
//     .connect(hacker)
//     .transfer(
//       attack.address,
//       testErc20.connect(hacker).balanceOf(hacker.address)
//     );

//   let tx = {
//     from: await user1.getAddress(),
//     to: reentrance.address,
//     value: ethers.utils.parseEther("100"),
//   };
//   await user1.sendTransaction(tx);

//   console.log(
//     "reentrance balance:%s",
//     await ethers.utils.formatEther(
//       await provider.getBalance(reentrance.address)
//     )
//   );

//   console.log(
//     "---------模拟初始环境完成:--------\\n--------1. reentrance合约(%s)有 %s ETH \\n 2.hacker部署attack合约,hacker合约(%s)有 %s 个ETH\\n----------------------",
//     reentrance.address,
//     await ethers.utils.formatEther(
//       await provider.getBalance(reentrance.address)
//     ),
//     attack.address,
//     await ethers.utils.formatEther(await provider.getBalance(attack.address))
//   );

//   console.log("下面模拟攻击过程，调用attack的startAttack方法");

//   //   provider.getFeeData = async () => ({
//   //     gasPrice: ethParams.txGasPrice,
//   //   });

//   //   hacker.estimateGas = async (transaction) => {
//   //     return 20000000;
//   //   };

//   await attack.connect(hacker).setVictim(reentrance.address);
//   await attack
//     .connect(hacker)
//     .startAttack(await ethers.utils.parseEther("1"), testErc20.address);

//   console.log("******************攻击完成后，各账户的余额******************");
//   console.log(
//     "reentrance contract balance : %s",
//     await ethers.utils.formatEther(
//       await provider.getBalance(reentrance.address)
//     )
//   );
//   console.log(
//     "attack contract balance : %s",
//     await ethers.utils.formatEther(await provider.getBalance(attack.address))
//   );
//   console.log(
//     "attack contract ERC20 balance : %s",
//     await testErc20.connect(hacker).balanceOf(attack.address)
//   );

//   console.log(
//     "reentrance contract ERC20 balance : %s",
//     await testErc20.connect(hacker).balanceOf(reentrance.address)
//   );

//   console.log(
//     "TetsErc20 contract ERC20 balance : %s",
//     await testErc20.connect(hacker).balanceOf(testErc20.address)
//   );
// }

// main()
//   .then(() => process.exit(0))
//   .catch((error) => {
//     console.error(error);
//     process.exit(1);
//   });
