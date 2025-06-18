//SPDX-License-Identifier:MIT
pragma solidity ^0.8.26;

import {Bank} from "./Bank.sol";

contract Basic is Bank {
    error Basic__NoSetLockForBasicBoxes();
    error Basic__InvalidDetails();

    function getBoxType() public pure override returns (DepositBoxType) {
        return DepositBoxType.Basic;
    }

    function setLockTime(uint256 _unlockTime) external pure override {
        revert Basic__NoSetLockForBasicBoxes();
    }

    function getDepositDetails() external view returns (address, string memory) {
        if (msg.sender == address(0) || msg.sender != depositBox[msg.sender].owner) {
            revert Basic__InvalidDetails();
        }

        return (depositBox[msg.sender].owner, depositBox[msg.sender].secret);
    }
}
