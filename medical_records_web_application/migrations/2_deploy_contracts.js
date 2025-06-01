const MedicalRecords = artifacts.require("MedicalRecords");

module.exports = async function (deployer) {
  await deployer.deploy(MedicalRecords);
};
