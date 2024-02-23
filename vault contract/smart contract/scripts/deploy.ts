import { ethers } from "hardhat";

async function main() {

  const Vault = await ethers.getContractFactory("Vault");

  const vault = await Vault.deploy();

  await vault.waitForDeployment();

  console.log("Vault deployed to:", vault.target);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
