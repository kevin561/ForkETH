require("@nomicfoundation/hardhat-toolbox");
require("@nomicfoundation/hardhat-chai-matchers");
require("@nomiclabs/hardhat-ethers");
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  contractSizer: {
    alphaSort: true,
    runOnCompile: true,
    disambiguatePaths: false,
  },
  networks: {
    hardhat: {
      forking: {
        url: "https://eth-mainnet.alchemyapi.io/v2/eUxjYYbTfHfcFG_1Zup8v6LUvq75P1hM",
        blockNumber: 15873419,
      },
    },
  },
  solidity: {
    compilers: [
      {
        version: "0.8.0",
      },
    ],
    overrides: {
      "contracts/Attacks.sol": {
        version: "0.6.12",
      },
      "@openzeppelin/contracts/utils/math/SafeMath.sol": {
        version: "0.8.0",
      },
      "hardhat/console.sol": {
        version: "0.6.12",
      },
    },
  },
  settings: {
    optimizer: {
      enabled: true,
      runs: 1000,
    },
    gasPrice: 1500000,
    gasLimit: 400_000_000,
  },
};
