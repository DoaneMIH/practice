// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.19;
pragma experimental ABIEncoderV2;
import "./UserManagement.sol";
// import "./MedicalCertificate.sol";
contract HealthSystem is UserManagement {
    // ───── Patient-specific ─────
    mapping(address => uint256) public patientBalance;
    mapping(address => string[]) private prescriptions;
    mapping(address => mapping(address => uint256)) public authorizedFee;
    mapping(address => mapping(address => bool)) public accessGranted;
        mapping(address => bool) public isPatient;

    // ───── Doctor-specific ─────
    mapping(address => uint256) public consultationFees;
    mapping(address => address[]) public doctorToPatients;
    mapping(address => address[]) patientToDoctors;
        mapping(address => bool) public isDoctor;
    mapping(address => mapping(address => uint256)) public accessTimestamps;
    // mapping(address => mapping(address => bytes32)) public accessTransactionHashes;
    mapping(address => address[]) public accessRequests;
    mapping(address => mapping(address => string[])) public patientRecords; // patient -> doctor -> list of IPFS hashes
    mapping(address => string) public doctorLicenses;
    // ───── Events ─────
    event UserRegistered(address indexed user, string name, string role);
    event RoleAdded(address indexed user, string role, string name);
    event DoctorAdded(address indexed userAddress, string name);
    event PatientAdded(address indexed patient, string name);
    event FeeUpdated(address indexed doctor, uint256 fee);
    event AccessGranted(address indexed patient, address indexed doctor);
    event AccessRevoked(address indexed patient, address indexed doctor);
    event RecordAdded(
        address indexed patient,
        address indexed doctor,
        string ipfsHash
    );

    // ───── User Management ─────
    function addDoctor(address user, string memory name) public {
        require(bytes(name).length > 0, "Name required");
        require(bytes(roles[user]).length == 0, "Already registered");

        roles[user] = "Doctor";
        names[user] = name;
        isDoctor[user] = true;
        isExists[user] = true;
        emit RoleAdded(user, "Doctor", name);
        emit DoctorAdded(user, name);
    }


    function addPatient(address user, string memory name) public {
        require(bytes(name).length > 0, "Name required");
        require(bytes(roles[user]).length == 0, "Already registered");

        roles[user] = "Patient";
        names[user] = name;
        isPatient[user] = true;
        isExists[user] = true;

        emit RoleAdded(user, "Patient", name);
        emit PatientAdded(user, name);
    }

    function signUp(
        address user,
        string memory name,
        string memory role,
        string memory license // <-- new parameter
    ) public {
        require(!isExists[user], "User already exists");
        require(bytes(name).length > 0, "Name cannot be empty");
        require(
            keccak256(abi.encodePacked(role)) == keccak256("Doctor") ||
                keccak256(abi.encodePacked(role)) == keccak256("Patient"),
            "Invalid role"
        );

        names[user] = name;
        roles[user] = role;
        isExists[user] = true;

        if (keccak256(abi.encodePacked(role)) == keccak256("Doctor")) {
            isDoctor[user] = true;
            doctorLicenses[user] = license; // Store license
        } else if (keccak256(abi.encodePacked(role)) == keccak256("Patient")) {
            isPatient[user] = true;
        }

        emit UserRegistered(user, name, role);
    }

    // ───── Doctor Functions ─────
    function updateFee(uint256 fee) public onlyDoctor {
        consultationFees[msg.sender] = fee;
        emit FeeUpdated(msg.sender, fee);
    }

    function getFee(address doctor) public view returns (uint256) {
        return consultationFees[doctor];
    }


    function getPatientsForDoctor(
    address doctor
)
    public
    view
    returns (address[] memory, string[] memory, uint256[] memory)
{
    address[] memory allPatients = doctorToPatients[doctor];
    uint count = 0;

    // Count valid patients who have granted access
    for (uint i = 0; i < allPatients.length; i++) {
        if (accessGranted[allPatients[i]][doctor]) {
            count++;
        }
    }

    // Initialize filtered arrays
    address[] memory patients = new address[](count);
    string[] memory patientNames = new string[](count);
    uint256[] memory timestamps = new uint256[](count);

    uint index = 0;
    for (uint i = 0; i < allPatients.length; i++) {
        if (accessGranted[allPatients[i]][doctor]) {
            // Ensure the patient exists and has granted access
            if (isPatient[allPatients[i]] && accessGranted[allPatients[i]][doctor]) {
                patients[index] = allPatients[i];
                patientNames[index] = names[allPatients[i]];
                timestamps[index] = accessTimestamps[allPatients[i]][doctor];
                index++;
            }
        }
    }

    // Return the filtered arrays
    return (patients, patientNames, timestamps);
}

    function requestAccess(address patient) public onlyDoctor {
        require(isPatient[patient], "Patient does not exist");

        address[] storage requests = accessRequests[patient];
        for (uint256 i = 0; i < requests.length; i++) {
            if (requests[i] == msg.sender) {
                revert("Access already requested");
            }
        }

        accessRequests[patient].push(msg.sender);
        accessTimestamps[patient][msg.sender] = block.timestamp; // ← Add this line
    }

    // ───── Patient Functions ─────

    function getAccessRequestsWithDetails(
        address patient
    )
        public
        view
        returns (address[] memory, string[] memory, uint256[] memory)
    {
        address[] memory doctors = accessRequests[patient];
        string[] memory names_ = new string[](doctors.length);
        uint256[] memory times = new uint256[](doctors.length);

        for (uint256 i = 0; i < doctors.length; i++) {
            names_[i] = names[doctors[i]];
            times[i] = accessTimestamps[patient][doctors[i]];
        }

        return (doctors, names_, times);
    }

    function viewPrescription(
        address patient
    ) external view returns (string[] memory) {
        return prescriptions[patient];
    }

    function setPrescription(
        string memory content,
        address patient
        // address payable doctor
    ) public {
        // require(authorizedFee[patient][doctor] > 0, "Not authorized");

        prescriptions[patient].push(content);

        // uint256 fee = authorizedFee[patient][doctor];
        // patientBalance[patient] -= fee;
        // authorizedFee[patient][doctor] = 0;
        // doctor.transfer(fee);
    }

    function payForPrescription(address doctor) public payable {
    uint256 fee = consultationFees[doctor];
    require(msg.value == fee, "Incorrect fee sent");
    authorizedFee[msg.sender][doctor] = msg.value;
}

    function grantAccess(address doctor) public onlyPatient {
        require(isExists[doctor], "Doctor does not exist");
        require(
            keccak256(abi.encodePacked(roles[doctor])) == keccak256("Doctor"),
            "Address is not a doctor"
        );
        require(!accessGranted[msg.sender][doctor], "Access already granted");

        accessGranted[msg.sender][doctor] = true;
        accessTimestamps[msg.sender][doctor] = block.timestamp;

        // Add to patientToDoctors if not already there
        bool doctorAlreadyAdded = false;
        for (uint256 i = 0; i < patientToDoctors[msg.sender].length; i++) {
            if (patientToDoctors[msg.sender][i] == doctor) {
                doctorAlreadyAdded = true;
                break;
            }
        }
        if (!doctorAlreadyAdded) {
            patientToDoctors[msg.sender].push(doctor);
        }

        // Add to doctorToPatients if not already there
        bool patientAlreadyAdded = false;
        for (uint256 i = 0; i < doctorToPatients[doctor].length; i++) {
            if (doctorToPatients[doctor][i] == msg.sender) {
                patientAlreadyAdded = true;
                break;
            }
        }
        if (!patientAlreadyAdded) {
            doctorToPatients[doctor].push(msg.sender);
        }

        // ✅ Remove doctor from accessRequests[msg.sender]
        address[] storage requests = accessRequests[msg.sender];
        for (uint256 i = 0; i < requests.length; i++) {
            if (requests[i] == doctor) {
                requests[i] = requests[requests.length - 1]; // Move last to current
                requests.pop(); // Remove last
                break;
            }
        }

        emit AccessGranted(msg.sender, doctor);
    }

    function revokeAccess(address doctor) public onlyPatient {
        require(accessGranted[msg.sender][doctor], "Access not granted");

        // Revoke access
        accessGranted[msg.sender][doctor] = false;

        // ── Remove patient from doctorToPatients[doctor]
        address[] storage patients = doctorToPatients[doctor];
        for (uint256 i = 0; i < patients.length; i++) {
            if (patients[i] == msg.sender) {
                patients[i] = patients[patients.length - 1]; // Replace with last
                patients.pop(); // Remove last
                break;
            }
        }

        // ── Remove doctor from patientToDoctors[patient]
        address[] storage doctors = patientToDoctors[msg.sender];
        for (uint256 i = 0; i < doctors.length; i++) {
            if (doctors[i] == doctor) {
                doctors[i] = doctors[doctors.length - 1]; // Replace with last
                doctors.pop(); // Remove last
                break;
            }
        }

        emit AccessRevoked(msg.sender, doctor);
    }

    function addRecord(
        address patient,
        string memory ipfsHash
    ) public onlyDoctor {
        require(
            accessGranted[patient][msg.sender],
            "Access not granted by patient"
        );

        patientRecords[patient][msg.sender].push(ipfsHash);

        emit RecordAdded(patient, msg.sender, ipfsHash);
    }

    // ───── Utility Getters ─────
    function getRecords(
        address patient,
        address doctor
    ) public view returns (string[] memory) {
        return patientRecords[patient][doctor];
    }


    function getGrantedDoctors(
        address patient
    )
        public
        view
        returns (address[] memory, string[] memory, uint256[] memory)
    {
        uint256 totalDoctors = patientToDoctors[patient].length;

        address[] memory tempDoctorAddresses = new address[](totalDoctors);
        string[] memory tempDoctorNames = new string[](totalDoctors);
        uint256[] memory tempTimestamps = new uint256[](totalDoctors);

        uint256 count = 0;

        for (uint256 i = 0; i < totalDoctors; i++) {
            address doc = patientToDoctors[patient][i];
            if (accessGranted[patient][doc]) {
                tempDoctorAddresses[count] = doc;
                tempDoctorNames[count] = names[doc];
                tempTimestamps[count] = accessTimestamps[patient][doc];
                count++;
            }
        }

        // Create final trimmed arrays
        address[] memory doctorAddresses = new address[](count);
        string[] memory doctorNames = new string[](count);
        uint256[] memory timestamps = new uint256[](count);

        for (uint256 i = 0; i < count; i++) {
            doctorAddresses[i] = tempDoctorAddresses[i];
            doctorNames[i] = tempDoctorNames[i];
            timestamps[i] = tempTimestamps[i];
        }

        return (doctorAddresses, doctorNames, timestamps);
    }
}