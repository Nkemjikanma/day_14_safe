//SPDX-License-Identifier:MIT
pragma solidity ^0.8.26;

import {Bank} from "./Bank.sol";

contract TimeLocked is Bank {
    error Timelocked__InvalidDetails();
    error Timelocked__InvalidLockTime();

    event LockTimeSet(address indexed _user, uint256 _unlockTime);

    function getBoxType() public pure override returns (DepositBoxType) {
        return DepositBoxType.TimeLocked;
    }

    function setLockTime(uint256 _unlockTime) external override {
        if (msg.sender == address(0) || msg.sender != depositBox[msg.sender].owner) {
            revert Timelocked__InvalidDetails();
        }

        if (_unlockTime <= block.timestamp) {
            revert Timelocked__InvalidLockTime();
        }

        depositBox[msg.sender].unlockTime = _unlockTime;

        emit LockTimeSet(msg.sender, _unlockTime);
    }

    function isLocked() external view returns (bool) {
        if (msg.sender == address(0) || msg.sender != depositBox[msg.sender].owner) {
            revert Timelocked__InvalidDetails();
        }

        return block.timestamp > depositBox[msg.sender].unlockTime;
    }

    function getRemainingLocktime() external view returns (uint256) {
        if (msg.sender == address(0) || msg.sender != depositBox[msg.sender].owner) {
            revert Timelocked__InvalidDetails();
        }

        return depositBox[msg.sender].unlockTime - block.timestamp;
    }
}
