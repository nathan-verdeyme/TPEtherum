// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "./Owner.sol";

/**
 * @title WhiteList
 * @dev Manage and check address whitelisting
 */
contract WhiteList is Owner {
    mapping(address => bool) public whitelist;
    event AddedBeneficiary(address indexed beneficiary);

    function isWhitelisted(address beneficiary) internal view returns (bool) {
        return whitelist[beneficiary];
    }

    function addToWhitelist(address[] calldata beneficiaries) public isOwner {
        for (uint256 i = 0; i < beneficiaries.length; i++) {
            whitelist[beneficiaries[i]] = true;
            emit AddedBeneficiary(beneficiaries[i]);
        }
    }

    function removeFromWhitelist(address beneficiary) public isOwner {
        whitelist[beneficiary] = false;
        emit AddedBeneficiary(beneficiary);  // Consider changing to a RemovedBeneficiary event
    }
}
