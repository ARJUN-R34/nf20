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

// Deployed NFT with address: 0x5edCa6f4Fb19cBEaEd19DD263d24C10bab6aAcC7
// FractionalizerDeployed Fractionalizer with address: 0xA1eFBff756330cC18bDA927A01Cd00E75a385423
