//SPDX-License-Identifier:MIT
pragma solidity ^0.8.26;

import {Bank} from "./Bank.sol";

contract Premium is Bank {
    error Premium__InvalidDetails();
    error Premium__InvalidLocktime();

    mapping(address => bool) private authorizedUser;

    event LockTimeSet(address indexed _user, uint256 _unlockTime);
    event UserAuthorized(address indexed _authorized);
    event AuthorizationRevoked(address indexed _revokedUser);

    function getBoxType() public pure override returns (DepositBoxType) {
        return DepositBoxType.Premium;
    }

    function setLockTime(uint256 _unlockTime) external override {
        if (msg.sender != depositBox[msg.sender].owner) {
            revert Premium__InvalidDetails();
        }

        if (_unlockTime <= block.timestamp || _unlockTime <= 0) {
            revert Premium__InvalidLocktime();
        }

        depositBox[msg.sender].unlockTime = _unlockTime;

        emit LockTimeSet(msg.sender, _unlockTime);
    }

    function authorizeUser(address _user) external {
        if (msg.sender != depositBox[msg.sender].owner) {
            revert Premium__InvalidDetails();
        }

        if (_user == address(0)) {
            revert Premium__InvalidDetails();
        }

        authorizedUser[_user] = true;

        emit UserAuthorized(_user);
    }

    function revokeAuthorization(address _user) external {
        if (msg.sender != depositBox[msg.sender].owner) {
            revert Premium__InvalidDetails();
        }

        if (_user == address(0)) {
            revert Premium__InvalidDetails();
        }

        delete authorizedUser[_user];

        emit AuthorizationRevoked(_user);
    }

    function isAuthorized(address _user) external view returns (bool) {
        return authorizedUser[_user];
    }
}
