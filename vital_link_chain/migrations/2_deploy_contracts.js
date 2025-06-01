
const HealthSystem = artifacts.require("HealthSystem");
const MedicalCertificate = artifacts.require("MedicalCertificate");
const MedicalExtension = artifacts.require("HealthGet");
module.exports = function (deployer) {
    deployer.deploy(HealthSystem)
    deployer.deploy(MedicalCertificate)
    deployer.deploy(MedicalExtension)
};