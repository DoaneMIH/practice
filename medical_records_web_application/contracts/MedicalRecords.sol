// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract MedicalRecords {
    enum Role { None, Patient, Doctor }
    
    struct Record {
        string ipfsHash; // Store IPFS hash instead of data
        address creator;
        uint256 timestamp;
    }
    
    mapping(address => Role) public roles;
    mapping(address => Record[]) private patientRecords;
    mapping(address => mapping(address => bool)) private accessControl;

    address[] public patientsList;

    event PatientAdded(address patientAddress);
    event RoleAssigned(address indexed user, Role role);
    event AccessGranted(address indexed patient, address indexed doctor);
    event RecordAdded(address indexed creator, address indexed patient, string ipfsHash);
    event AccessRevoked(address indexed patient, address indexed doctor);

    modifier onlyRole(Role role) {
        require(roles[msg.sender] == role, "Unauthorized role");
        _;
    }
    
    function assignRole(Role role) external {
        require(roles[msg.sender] == Role.None, "Role already assigned");
        roles[msg.sender] = role;
        if(role == Role.Patient) {
            patientsList.push(msg.sender);
            emit PatientAdded(msg.sender);
        }
        emit RoleAssigned(msg.sender, role);
    }
    
    function addRecord(address patient, string memory ipfsHash) external onlyRole(Role.Doctor) {
        require(accessControl[patient][msg.sender], "No access to this patient");
        patientRecords[patient].push(Record(ipfsHash, msg.sender, block.timestamp));
        emit RecordAdded(msg.sender, patient, ipfsHash);
    }

    
    function grantAccess(address doctor) external onlyRole(Role.Patient) {
        require(roles[doctor] == Role.Doctor, "Not a valid doctor");
        accessControl[msg.sender][doctor] = true;
        emit AccessGranted(msg.sender, doctor);
    }

    function revokeAccess(address doctor) external onlyRole(Role.Patient) {
        require(accessControl[msg.sender][doctor], "Access not granted to this doctor");
        accessControl[msg.sender][doctor] = false;
        emit AccessRevoked(msg.sender, doctor);
    }
    
    function getMyRecords() external view onlyRole(Role.Patient) returns (Record[] memory) {
        return patientRecords[msg.sender];
    }
    
    function getPatientRecords(address patient) external view returns (Record[] memory) {
        return patientRecords[patient];
    }

    function getAccessiblePatients(address _doctor) public view returns (address[] memory) {
        address[] memory patients = new address[](patientsList.length);
        uint256 count = 0;
        for (uint256 i = 0; i < patientsList.length; i++) {
            if (accessControl[patientsList[i]][_doctor]) {
                patients[count] = patientsList[i];
                count++;
            }
        }
        assembly {
            mstore(patients, count) // Adjust the length of the array
        }
        return patients;
    }
    
    function checkAccess(address patient, address doctor) external view returns (bool) {
        return accessControl[patient][doctor];
    }
}
