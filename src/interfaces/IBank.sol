//SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// Interface
interface IBank {
    enum DepositBoxType {
        Basic,
        Premium,
        TimeLocked
    }

    struct DepositBox {
        address owner;
        string secret;
        DepositBoxType boxType;
        uint256 unlockTime;
        bool isPremium;
    }

    function storeSecret(string memory _secret) external;

    function getSecret() external view returns (string memory);

    function transferOwnership(address _newOwner) external;

    function getOwner() external view returns (address);

    function getBoxType() external returns (DepositBoxType);

    function setLockTime(uint256 _unlockTime) external;
}
