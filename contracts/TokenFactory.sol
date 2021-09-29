// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.0;

import "@openzeppelin/contracts/proxy/Clones.sol";
import '@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol';
import '@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol';
import "./utils/IMasterRegistry.sol";

interface ISeriesToken {
    function initialize(string memory name_, string memory symbol_, uint256 _supply, address creator) external;
}

contract TokenFactory is Initializable, OwnableUpgradeable {

    event TokenCreated(address indexed series, address value);

    address private _tokenContract;
    address private _registryContract;

    modifier onlySeriesOwner(address _series) {
        require(OwnableUpgradeable(_series).owner() == _msgSender(), "Error: Only Series Owner could deploy tokens");
        _;
    }

    function initialize(address token, address[] calldata previousSeries, address[] calldata previousTokens) external {
        require(previousSeries.length == previousTokens.length, 'Previous series size different than previous tokens size.');
        __Ownable_init();
        _tokenContract = token;
        for (uint i = 0; i < previousSeries.length; i++ ) {
            emit TokenCreated(previousSeries[i], previousTokens[i]);
        }
    }

    function updateTokenContract(address newAddress) public onlyOwner {
        _tokenContract = newAddress;
    }

    function updateRegistryContract(address newAddress) public onlyOwner {
        _registryContract = newAddress;
    }

    function createERC20(uint256 _supply, string memory _name, string memory _symbol, address _series) onlySeriesOwner(_series) public {
        ISeriesToken newToken = ISeriesToken(Clones.clone(_tokenContract));
        newToken.initialize(_name, _symbol, _supply, msg.sender);
        if (_registryContract != address(0)){
            IMasterRegistry(_registryContract).setRecord(_series, 1, address(newToken));
        }
        emit TokenCreated(_series, address(newToken));
    }
}