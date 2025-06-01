const Doctor = artifacts.require("Doctor");
const Patient = artifacts.require("Patient");

module.exports = function (deployer) {
    deployer.deploy(Doctor);
    deployer.deploy(Patient);
};