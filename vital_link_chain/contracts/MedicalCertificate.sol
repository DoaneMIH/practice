// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.19;
// import "./HealthSystem.sol";
import "./UserManagement.sol";


contract MedicalCertificate is UserManagement{
    mapping(address => string[]) public certificates;
    mapping(address => uint256) public certificateFees;
    mapping(address => mapping(address => uint256)) public authorizedCertificateFee;
    mapping(address => bool) public isDoctor;

    event CertificateIssued(address indexed patient, address indexed doctor, string content);
    event CertificateFeeUpdated(address indexed doctor, uint256 fee);

function addDoctor(address user, string memory name) public {
    names[user] = name;
    roles[user] = "Doctor";
    isDoctor[user] = true;
}

 function setCertificateFee(uint256 fee) public onlyDoctor {
    certificateFees[msg.sender] = fee;
    emit CertificateFeeUpdated(msg.sender, fee);
}


// Get the fee for a doctor's certificate
function getCertificateFee(address doctor) public view returns (uint256) {
    return certificateFees[doctor];
}

// Patient pays for certificate issuance
function payForCertificate(address doctor) public payable {
    uint256 fee = certificateFees[doctor];
    require(fee > 0, "not set");
    require(msg.value == fee, "Incorrect fee sent");
    authorizedCertificateFee[msg.sender][doctor] = msg.value;
}

function issueCertificate(string memory content, address patient) public onlyDoctor {
    // require(authorizedCertificateFee[patient][msg.sender] > 0, "Certificate not paid");
    certificates[patient].push(content);
    // uint256 fee = authorizedCertificateFee[patient][msg.sender];
    // authorizedCertificateFee[patient][msg.sender] = 0;
    // payable(msg.sender).transfer(fee);
    emit CertificateIssued(patient, msg.sender, content);
}

// View all certificates for a patient
function viewCertificates(address patient) public view returns (string[] memory) {
    return certificates[patient];
}
}