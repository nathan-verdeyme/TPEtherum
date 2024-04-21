// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "./WhiteList.sol";

/**
 * @title Product Tracking
 * @dev Tracks the registration and ownership of product lots
 */
contract ProductTracking is WhiteList {
    struct Lot {
        uint256 id;
        string manufacturer;
        uint256 productCount;
        string productName;
        address currentOwner;
        uint256 dateOfPurchase;
    }

    uint256 private lotCounter;
    mapping(uint256 => Lot) public lots;

    event LotRegistered(uint256 lotId, string manufacturer, string productName);
    event OwnershipTransferred(uint256 lotId, address indexed previousOwner, address indexed newOwner);

    constructor() {
        lotCounter = 0;
    }

    function registerLot(string memory manufacturer, uint256 productCount, string memory productName) public isOwner {
        lotCounter++;
        uint256 newLotId = lotCounter;

        lots[newLotId] = Lot({
            id: newLotId,
            manufacturer: manufacturer,
            productCount: productCount,
            productName: productName,
            currentOwner: msg.sender,
            dateOfPurchase: block.timestamp
        });

        emit LotRegistered(newLotId, manufacturer, productName);
    }

    function transferLotOwnership(uint256 lotId, address newOwner) public {
        require(isWhitelisted(newOwner), "New owner is not whitelisted");
        Lot storage lot = lots[lotId];
        require(msg.sender == lot.currentOwner, "Only current owner can transfer the lot");

        address previousOwner = lot.currentOwner;
        lot.currentOwner = newOwner;
        lot.dateOfPurchase = block.timestamp;

        emit OwnershipTransferred(lotId, previousOwner, newOwner);
    }

    function getLotDetails(uint256 lotId) public view returns (uint256, string memory, uint256, string memory, address, uint256) {
        Lot memory lot = lots[lotId];
        return (lot.id, lot.manufacturer, lot.productCount, lot.productName, lot.currentOwner, lot.dateOfPurchase);
    }
}
