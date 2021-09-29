// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.0;

import '@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol';
import '@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol';
import "./utils/IMasterRegistry.sol";

interface IGnosisSafeProxyFactory {
    function createProxy(address singleton, bytes memory data) external returns (address proxy);
}

contract MultisigFactory is Initializable, OwnableUpgradeable {

    event MultisigCreated(address indexed series, address value);

    address private _gnosisMasterCopy;
    address private _registryContract;
    address private _gnosisProxyFactory;

    modifier onlySeriesOwner(address _series) {
        require(OwnableUpgradeable(_series).owner() == _msgSender(), "Error: Only Series Owner could deploy tokens");
        _;
    }

    function initialize(address masterCopy) external {
        __Ownable_init();
        _gnosisMasterCopy = masterCopy;
    }

    function updateGnosisMasterCopy(address newAddress) public onlyOwner {
        _gnosisMasterCopy = newAddress;
    }

    function updateRegistryContract(address newAddress) public onlyOwner {
        _registryContract = newAddress;
    }

    function createMultisig(address _series, bytes memory data) public onlySeriesOwner(_series) {
        address proxy = IGnosisSafeProxyFactory(_gnosisProxyFactory).createProxy(_gnosisMasterCopy, data);
        if (_registryContract != address(0)){
            IMasterRegistry(_registryContract).setRecord(_series, 2, address(proxy));
        }
        emit MultisigCreated(_series, address(proxy));
    }
}