let BN = web3.utils.BN;
const Void = artifacts.require("Void");
const Driger = artifacts.require("Driger");

module.exports = async function(deployer) {
  
  /** Deploys Driger.sol **/
  await deployer.deploy(Driger);
  const driger = await Driger.deployed();

  /** Deploys Void.sol **/
  await deployer.deploy(Void, driger.address);
  const voids = await Void.deployed();
  
  /** Allocates total supply of ERC20 Driger tokens to Void.sol  **/
  const amount = new BN('100000000000000000000000000');
  await driger.increaseAllowance(voids.address,amount);
  await voids.transferDrigersToContract(amount);

}