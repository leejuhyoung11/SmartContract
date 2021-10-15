const HEX0924 = artifacts.require("HEX0924.sol");
const smartContract = artifacts.require("HEX0924_logic");
const safeMath = artifacts.require("safeMath");

module.exports = function (deployer) {
  deployer.deploy(HEX0924);
  deployer.deploy(smartContract);
  deployer.deploy(safeMath);
};
