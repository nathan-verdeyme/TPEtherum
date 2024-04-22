// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

/**
 * @title AccessList
 * @dev Manages role-based access control for different actors within the product tracking system.
 */
contract AccessList {
    address public owner;

    mapping(address => bool) private admins; // Addresses that can grant or revoke any roles
    mapping(address => bytes32) private roles; // Tracks assigned roles for each address
    
    // Define roles with unique identifiers
    bytes32 public constant MANUFACTURER_ROLE = keccak256("MANUFACTURER_ROLE");
    bytes32 public constant LOGISTICS_ROLE = keccak256("LOGISTICS_ROLE");
    bytes32 public constant RETAILER_ROLE = keccak256("RETAILER_ROLE");

    // Event emitted when a new role is granted
    event RoleGranted(bytes32 indexed role, address indexed account, address indexed admin);
    // Event emitted when a role is revoked
    event RoleRevoked(bytes32 indexed role, address indexed account, address indexed admin);

    modifier onlyOwner() {
        require(msg.sender == owner, "AccessList: caller is not the owner");
        _;
    }

    modifier onlyAdmin() {
        require(admins[msg.sender], "AccessList: caller is not an admin");
        _;
    }

    constructor() {
        owner = msg.sender;
        admins[owner] = true; // The owner is the first admin
    }

    function grantAdmin(address account) public onlyOwner {
        admins[account] = true;
    }

    function revokeAdmin(address account) public onlyOwner {
        require(account != msg.sender, "AccessList: cannot revoke self");
        admins[account] = false;
    }

    function grantRole(bytes32 role, address account) public onlyAdmin {
        require(roles[account] == 0, "AccessList: account already has a role");
        roles[account] = role;
        emit RoleGranted(role, account, msg.sender);
    }

    function revokeRole(bytes32 role, address account) public onlyAdmin {
        require(roles[account] == role, "AccessList: account does not have the role");
        roles[account] = 0;
        emit RoleRevoked(role, account, msg.sender);
    }

    function getRole(address account) public view returns (bytes32) {
        return roles[account];
    }

    function isAdmin(address account) public view returns (bool) {
        return admins[account];
    }

    function hasRole(bytes32 role, address account) public view returns (bool) {
        return roles[account] == role;
    }

    // Additional helper functions to check for specific roles
    function isManufacturer(address account) public view returns (bool) {
        return hasRole(MANUFACTURER_ROLE, account);
    }

    function isLogistics(address account) public view returns (bool) {
        return hasRole(LOGISTICS_ROLE, account);
    }

    function isRetailer(address account) public view returns (bool) {
        return hasRole(RETAILER_ROLE, account);
    }
}
