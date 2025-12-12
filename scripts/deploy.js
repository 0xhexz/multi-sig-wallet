async function main() {
  const [owner1, owner2, owner3] = await ethers.getSigners();

  const MultiSig = await ethers.getContractFactory("MultiSigWallet");
  const wallet = await MultiSig.deploy(
    [owner1.address, owner2.address, owner3.address],
    2  // 2 approvals required
  );

  await wallet.deployed();
  console.log("MultiSig deployed at:", wallet.address);
}

main().catch(console.error);
