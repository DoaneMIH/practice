// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.19;
import './UserManagement.sol';
contract HealthGet is UserManagement{
    address[] public allPatients;
    address[] public allDoctors;
    mapping(address => bool) public isDoctor;
    mapping(address => bool) public isPatient;

    function addDoctor(address user, string memory name) public {
    names[user] = name;
    roles[user] = "Doctor";
    isDoctor[user] = true;
    allDoctors.push(user);
    }

      function getAllDoctors() public view returns (address[] memory, string[] memory) {
        uint256 count = allDoctors.length;
        string[] memory doctorNames = new string[](count);
        for (uint256 i = 0; i < count; i++) {
            doctorNames[i] = names[allDoctors[i]];
        }
        return (allDoctors, doctorNames);
    }

    function addPatient(address user, string memory name) public {
    names[user] = name;
    roles[user] = "Patient";
    isPatient[user] = true;
    allPatients.push(user);
    }

      function getAllPatient() public view returns (address[] memory, string[] memory) {
        uint256 count = allPatients.length;
        string[] memory patientNames = new string[](count);
        for (uint256 i = 0; i < count; i++) {
            patientNames[i] = names[allPatients[i]];
        }
        return (allPatients, patientNames);
    }
}