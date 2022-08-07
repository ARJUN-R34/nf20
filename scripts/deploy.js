const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  const Token = await ethers.getContractFactory("CultNFT");
  const token = await Token.deploy();
  console.log("Deployed NFT with address:", token.address);

  const Fractionalizer = await ethers.getContractFactory("Fractionalizer");
  const fractionalizer = await Fractionalizer.deploy();
  console.log("Deployed Fractionalizer with address:", fractionalizer.address);
}

main()
  .then(() => process.exit(0))
  .catch((err) => {
    console.log(err);
    process.exit(1);
  });

// Deployed NFT with address: 0xFF2C1cf1f92AA823A9bBfA9CDd15E2529ea51fFf
// FractionalizerDeployed Fractionalizer with address: 0x800449D010C28e9B58969042Cc7588760b524A14
