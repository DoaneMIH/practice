
const HealthSystem = artifacts.require("HealthSystem");
const MedicalCertificate = artifacts.require("MedicalCertificate");
module.exports = function (deployer) {
    deployer.deploy(HealthSystem)
    deployer.deploy(MedicalCertificate)
};