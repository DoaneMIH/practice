// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.19;
pragma experimental ABIEncoderV2;

contract Patient {
    mapping(address => uint256) patientBalance;
    mapping(address => bool) isExists;
    mapping(address => string[]) prescriptions;
    mapping(address => mapping(address => uint256)) authorized; // Stores access with fee
    address[] public patientsList; // Stores all patients
    mapping(address => mapping(address => bool)) public isAuthorized1;
    mapping(address => address[]) public authorizedPatients;

    event AccessRevoked(address indexed patient, address indexed doctor);
    event AccessGranted(address indexed patient, address indexed doctor, uint256 fee);

    modifier checkExistence(address pat) {
        require(isExists[pat], "Patient does not exist");
        _;
    }
    function isAuthorized(address doc, address pat) public view returns (bool) {
        return authorized[pat][doc] > 0;
    }

    function addPatient(address pat) public {
        require(!isExists[pat], "Patient already exists");
        patientBalance[pat] = 0;
        isExists[pat] = true;
        patientsList.push(pat);
    }

    // ✅ Grant access to a doctor with a fee
    function grantAccess(address doctor, uint256 fee) public payable {
        require(authorized[msg.sender][doctor] == 0, "Doctor already authorized.");
        require(msg.value >= fee, "Amount not sufficient");

        patientBalance[msg.sender] += msg.value;
        authorized[msg.sender][doctor] = fee;
        emit AccessGranted(msg.sender, doctor, fee);
    }

    // ✅ Alternative way to grant access (same as grantAccess)
    function addAuthorization(address doc, address pat, uint256 fee) external payable {
        require(authorized[pat][doc] == 0, "Doctor already authorized.");
        require(msg.value >= fee, "Amount not sufficient");

        patientBalance[pat] += msg.value;
        authorized[pat][doc] = fee;
        emit AccessGranted(pat, doc, fee);
    }

    function viewPrescription(address pat) public view returns (string[] memory) {
        return prescriptions[pat];
    }

    function setPrescription(string memory presc, address pat, address payable doc) public {
        require(authorized[pat][doc] > 0, "Doctor is not authorized.");
        
        prescriptions[pat].push(presc);
        
        uint256 charges = authorized[pat][doc];
        patientBalance[pat] -= charges;
        authorized[pat][doc] = 0; // Reset access after prescription (if intended)
        doc.transfer(charges);
    }


    function isPatient(address pat) public view returns (bool) {
        return isExists[pat];
    }

    // ✅ Revoke access for a doctor
    function revokeAccess(address doctor) external {
        require(authorized[msg.sender][doctor] > 0, "Access not granted.");
        
        delete authorized[msg.sender][doctor]; // Remove access
        emit AccessRevoked(msg.sender, doctor);
    }
    
    function getAuthorizedPatients(address doctor) public view returns (address[] memory) {
    uint256 count = 0;

    // Count how many patients have authorized this doctor
    for (uint256 i = 0; i < patientsList.length; i++) {
        if (authorized[patientsList[i]][doctor] > 0) {
            count++;
        }
    }

    address[] memory patients = new address[](count);
    uint256 index = 0;

    // Store authorized patients in the array
    for (uint256 i = 0; i < patientsList.length; i++) {
        if (authorized[patientsList[i]][doctor] > 0) {
            patients[index] = patientsList[i];
            index++;
        }
    }

    return patients;
}

    // ✅ Get list of patients who have granted access to a doctor
    function getAccessiblePatients(address _doctor) public view returns (address[] memory) {
        uint256 count = 0;

        for (uint256 i = 0; i < patientsList.length; i++) {
            if (authorized[patientsList[i]][_doctor] > 0) {
                count++;
            }
        }

        address[] memory patients = new address[](count);
        uint256 index = 0;
        for (uint256 i = 0; i < patientsList.length; i++) {
            if (authorized[patientsList[i]][_doctor] > 0) {
                patients[index] = patientsList[i];
                index++;
            }
        }

        return patients;
    }

    // ✅ Check if a doctor has access to a specific patient's records
    function checkAccess(address patient, address doctor) external view returns (bool) {
        return authorized[patient][doctor] > 0;
    }


    function revokeAuthorization(address doctor) public {
    require(isAuthorized1[doctor][msg.sender], "Authorization does not exist");
    isAuthorized1[doctor][msg.sender] = false;

    // Remove the patient from the doctor's authorized list
    for (uint i = 0; i < authorizedPatients[doctor].length; i++) {
        if (authorizedPatients[doctor][i] == msg.sender) {
            authorizedPatients[doctor][i] = authorizedPatients[doctor][authorizedPatients[doctor].length - 1];
            authorizedPatients[doctor].pop();
            break;
        }
    }
}
}

contract Doctor {
    mapping(address => uint256) fee;
    mapping(address => bool) isExists;

    function addDoctor(address doc) public {
        require(!isExists[doc], "Doctor already exists");
        fee[doc] = 0;
        isExists[doc] = true;
    }

    function updateFee(address doc, uint256 amount) public {
        fee[doc] = amount;
    }

    function getFee(address doc) public view returns (uint256) {
        return fee[doc];
    }

    function isDoctor(address doc) public view returns (bool) {
        return isExists[doc];
    }
}
