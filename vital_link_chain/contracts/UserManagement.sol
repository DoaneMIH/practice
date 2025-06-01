// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.19;

contract UserManagement {
    mapping(address => string) public roles;
    mapping(address => string) public names;
    mapping(address => bool) public isExists;
    // mapping(address => bool) public isDoctor;
    //     // address[] public allDoctors;



    // event RoleAdded(address indexed user, string role, string name);
    // event DoctorAdded(address indexed userAddress, string name);
    // event PatientAdded(address indexed patient, string name);
    

 // ───── Modifiers ─────
    modifier onlyDoctor() {
        require(
            keccak256(abi.encodePacked(roles[msg.sender])) ==
                keccak256("Doctor"),
            "Caller is not a doctor"
        );
        _;
    }

    modifier onlyPatient() {
        require(
            keccak256(abi.encodePacked(roles[msg.sender])) ==
                keccak256("Patient"),
            "Caller is not a patient"
        );
        _;
    }
    
    function getRole(address userAddress) public view returns (string memory) {
        return roles[userAddress];
    }

    function getName(address userAddress) public view returns (string memory) {
        return names[userAddress];
    }

    function checkExists(address user) public view returns (bool) {
        return isExists[user];
    }

    
    
    // function getAllDoctors() public view returns (address[] memory, string[] memory) {
    //     uint256 count = allDoctors.length;
    //     string[] memory doctorNames = new string[](count);
    //     for (uint256 i = 0; i < count; i++) {
    //         doctorNames[i] = names[allDoctors[i]];
    //     }
    //     return (allDoctors, doctorNames);
    // }
    
}