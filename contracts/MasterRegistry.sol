// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.6.0;

import "@openzeppelin/contracts-ethereum-package/contracts/access/Ownable.sol";

interface Ownable {
    function owner() external view returns (address);
}

/**
 * Master Registry Contract.
 */
contract MasterRegistry is OwnableUpgradeSafe {

    event RecordChanged(address indexed series, uint8 indexed key, address value);
    event ContentChanged(address indexed series, uint8 indexed key, string value);

    // Mapping PluginID => Pluggin contract address
    mapping(uint8=>address) private plugins;
    // Mapping Series Address => PluginID => Deployd Contract Address 
    mapping(address=>mapping(uint8=>address)) private records;
    // Mapping Series Address => PluginID => Content
    mapping(address=>mapping(uint8=>string)) private contents;

    /**
     * Modifier that only allow the following entities change content:
     * - Series owners
     * - Plugin itself in case of empty series record
     * - Current module itself addressed by record
     * @param _series The plugin index to update.
     * @param _key The new address where remains the plugin.
     */
    modifier authorizedRecord(address _series, uint8 _key) {
        require(isSeriesOwner(_series) ||
        isRecordItself(_series, _key) || 
        isRecordPlugin(_series, _key), "Not authorized");
        _;
    }
    
    /**
     * Modifier to allow only series owners to change content.
     * @param _series The plugin index to update.
     * @param _key The new address where remains the plugin.
     */
    modifier onlySeriesOwner(address _series, uint8 _key) {
        require(isSeriesOwner(_series), "Not authorized");
        _;
    }

    function initialize() public {
        require(owner() == address(0x0), "Already initialized.");
        OwnableUpgradeSafe.__Ownable_init();
    }

    /**
     * Sets the module contract associated with an Series and record.
     * May only be called by the owner of that series, module itself or record plugin itself.
     * @param series The series to update.
     * @param key The key to set.
     * @param value The text data value to set.
     */
    function setRecord(address series, uint8 key, address value) public authorizedRecord(series, key) {
        records[series][key] = value;
        emit RecordChanged(series, key, value);
    }

    /**
     * Returns the data associated with an record Series and Key.
     * @param series The series node to query.
     * @param key The text data key to query.
     * @return The associated text data.
     */
    function getRecord(address series, uint8 key) public view returns (address) {
        return records[series][key];
    }

    /**
     * Sets the content data associated with an Series and key.
     * May only be called by the owner of that series.
     * @param series The series to update.
     * @param key The key to set.
     * @param value The text data value to set.
     */
    function setContent(address series, uint8 key, string memory value) public onlySeriesOwner(series, key) {
        contents[series][key] = value;
        emit ContentChanged(series, key, value);
    }

    /**
     * Returns the content associated with an content Series and Key.
     * @param series The series node to query.
     * @param key The text data key to query.
     * @return The associated text data.
     */
    function getContent(address series, uint8 key) public view returns (string memory) {
        return contents[series][key];
    }

    /**
     * Sets the plugin that controls specific entry on records.
     * Only owner of this contract has permission.
     * @param pluginID The plugin index to update.
     * @param pluginAddress The new address where remains the plugin.
     */
    function setPluginController(uint8 pluginID, address pluginAddress) public onlyOwner {
        plugins[pluginID] = pluginAddress;
    }

    function isSeriesOwner(address _series) private view returns (bool) {
        return Ownable(_series).owner() == _msgSender();
    }

    function isRecordItself(address _series, uint8 _key) private view returns (bool) {
        return records[_series][_key] == _msgSender();
    }

    function isRecordPlugin(address _series, uint8 _key) private view returns (bool) {
        return _msgSender() == plugins[_key] && records[_series][_key] == address(0);
    }
}