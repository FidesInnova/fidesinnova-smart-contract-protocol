// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;


import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Context.sol";

import "./SignIdentity.sol";
import "./DeviceNFT.sol";
import "./DeviceManagement.sol";
import "./ServiceManagement.sol";
import "./CommitmentStorage.sol";
import "./ZKPStorage.sol";

// //////////////////////////////////////////////////////////
// //////////////////////////////////////////////////////////
// The main contract which inherits from the other contracts.
// /////////////////////////////////////////////////////////
// //////////////////////////////////////////////////////////

/*************************************************************
 * @title Protocol
 * @dev A master contract to deploy and manage all other contracts in the protocol.
 */
contract Protocol {
    // Addresses of deployed contracts
    address public signIdentityAddress;
    address public deviceNFTAddress;
    address public deviceManagementAddress;
    address public serviceManagementAddress;
    address public commitmentStorageAddress;
    address public zkpStorageAddress;

    // Owner of the protocol
    address public owner;

    // Events
    event ContractDeployed(string contractName, address contractAddress);

    constructor() {
        owner = msg.sender;
    }

    /**
     * @dev Deploys all contracts and stores their addresses.
     */
    function deployContracts() external {
        require(msg.sender == owner, "Only the owner can deploy contracts");

        // Deploy SignIdentity
        SignIdentity signIdentity = new SignIdentity();
        signIdentityAddress = address(signIdentity);
        emit ContractDeployed("SignIdentity", signIdentityAddress);

        // Deploy DeviceNFT
        DeviceNFT deviceNFT = new DeviceNFT();
        deviceNFTAddress = address(deviceNFT);
        emit ContractDeployed("DeviceNFT", deviceNFTAddress);

        // Deploy DeviceManagement
        DeviceManagement deviceManagement = new DeviceManagement(signIdentityAddress);
        deviceManagementAddress = address(deviceManagement);
        emit ContractDeployed("DeviceManagement", deviceManagementAddress);

        // Deploy ServiceManagement
        ServiceManagement serviceManagement = new ServiceManagement(deviceManagementAddress);
        serviceManagementAddress = address(serviceManagement);
        emit ContractDeployed("ServiceManagement", serviceManagementAddress);

        // Deploy CommitmentStorage
        CommitmentStorage commitmentStorage = new CommitmentStorage();
        commitmentStorageAddress = address(commitmentStorage);
        emit ContractDeployed("CommitmentStorage", commitmentStorageAddress);

        // Deploy ZKPStorage
        ZKPStorage zkpStorage = new ZKPStorage();
        zkpStorageAddress = address(zkpStorage);
        emit ContractDeployed("ZKPStorage", zkpStorageAddress);
    }

    /**
     * @dev Returns the address of a deployed contract by name.
     * @param contractName: The name of the contract (e.g., "SignIdentity").
     * @return The address of the deployed contract.
     */
    function getContractAddress(string memory contractName) external view returns (address) {
        if (keccak256(abi.encodePacked(contractName)) == keccak256(abi.encodePacked("SignIdentity"))) {
            return signIdentityAddress;
        } else if (keccak256(abi.encodePacked(contractName)) == keccak256(abi.encodePacked("DeviceNFT"))) {
            return deviceNFTAddress;
        } else if (keccak256(abi.encodePacked(contractName)) == keccak256(abi.encodePacked("DeviceManagement"))) {
            return deviceManagementAddress;
        } else if (keccak256(abi.encodePacked(contractName)) == keccak256(abi.encodePacked("ServiceManagement"))) {
            return serviceManagementAddress;
        } else if (keccak256(abi.encodePacked(contractName)) == keccak256(abi.encodePacked("CommitmentStorage"))) {
            return commitmentStorageAddress;
        } else if (keccak256(abi.encodePacked(contractName)) == keccak256(abi.encodePacked("ZKPStorage"))) {
            return zkpStorageAddress;
        } else {
            revert("Contract not found");
        }
    }
}