// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IBank} from "./interfaces/IBank.sol";

// Abstract contract
abstract contract Bank is IBank {
    error Bank__NotAuthorized();
    error Bank__StillLocked();
    error Bank__InvalidAddress();

    address private owner;
    string private secret;
    uint256 private depositTime;
    mapping(address => DepositBox) public depositBox;

    modifier onlyOwner() {
        if (msg.sender != depositBox[msg.sender].owner) {
            revert Bank__NotAuthorized();
        }

        _;
    }

    modifier notLocked() {
        if (depositBox[msg.sender].boxType == DepositBoxType.TimeLocked) {
            if (depositBox[msg.sender].unlockTime > block.timestamp) {
                revert Bank__StillLocked();
            }
        }
        _;
    }

    event SecretStored(address indexed _user);
    event OwnershipTransfered(address indexed _old, address indexed _new);

    constructor() {
        depositTime = block.timestamp;
    }

    function transferOwnership(address _newOwner) external onlyOwner {
        if (_newOwner == address(0)) {
            revert Bank__InvalidAddress();
        }

        address oldOwner = depositBox[msg.sender].owner;
        depositBox[msg.sender].owner = _newOwner;

        delete depositBox[msg.sender];

        emit OwnershipTransfered(oldOwner, _newOwner);
    }

    function storeSecret(string memory _secret) external override onlyOwner {
        depositBox[msg.sender].secret = _secret;

        emit SecretStored(msg.sender);
    }

    function getSecret() external view override onlyOwner notLocked returns (string memory) {
        return depositBox[msg.sender].secret;
    }

    function getOwner() external view override returns (address) {
        return depositBox[msg.sender].owner;
    }

    function getLockTime() external view returns (uint256) {
        return depositBox[msg.sender].unlockTime;
    }

    // Abstract functions that derived contracts must implement
    function getBoxType() public view virtual override returns (DepositBoxType);

    function setLockTime(uint256 _unlockTime) external virtual override;
}
