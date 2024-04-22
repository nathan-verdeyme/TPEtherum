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
        bool isActive;
    }

    uint256 private lotCounter;
    mapping(uint256 => Lot) public getLotsDetails;

    event LotRegistered(uint256 lotId, string manufacturer, string productName);
    event OwnershipTransferred(uint256 lotId, address indexed previousOwner, address indexed newOwner);
    event LotRemoved(uint256 lotId);    

    constructor() {
        lotCounter = 0;
    }

    function registerLot(string memory manufacturer, uint256 productCount, string memory productName) public isOwner {
        lotCounter++;
        uint256 newLotId = lotCounter;

        getLotsDetails[newLotId] = Lot({
            id: newLotId,
            manufacturer: manufacturer,
            productCount: productCount,
            productName: productName,
            currentOwner: msg.sender,
            dateOfPurchase: block.timestamp,
            isActive : true
        });

        emit LotRegistered(newLotId, manufacturer, productName);
    }

    function transferLotOwnership(uint256 lotId, address newOwner) public {
        require(isWhitelisted(newOwner), "New owner is not whitelisted");
        Lot storage lot = getLotsDetails[lotId];
        require(lot.isActive, "Lot is not active");
        require(msg.sender == lot.currentOwner, "Only current owner can transfer the lot");

        address previousOwner = lot.currentOwner;
        lot.currentOwner = newOwner;
        lot.dateOfPurchase = block.timestamp;

        emit OwnershipTransferred(lotId, previousOwner, newOwner);
    }


    function removeLot(uint256 lotId) public isOwner {
        require(getLotsDetails[lotId].isActive, "Lot already removed or does not exist");

        getLotsDetails[lotId].isActive = false;
        emit LotRemoved(lotId); 
    }


}
