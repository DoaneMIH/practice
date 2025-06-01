// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.19;

contract UserManagement {
    mapping(address => string) public roles;
    mapping(address => string) public names;
    mapping(address => bool) public isExists;

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
}