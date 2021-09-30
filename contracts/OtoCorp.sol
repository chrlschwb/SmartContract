// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.0;

import "./utils/ISeries.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract OtoCorp is Ownable {

    ISeries internal seriesSource;
    mapping(address=>address[]) internal seriesOfMembers;

    event NewSeriesCreated(address _contract, address _owner, string _name);

    constructor(ISeries _source) {
        seriesSource = _source;
    }

    // TODO Require to be called from MasterRegistry
    function createSeries(string memory seriesName) external virtual {
        createSeries(msg.sender, seriesName);
    }

    // TODO Require to be called from MasterRegistry
    function createSeries(address owner, string memory seriesName) public virtual {
        ISeries newContract = ISeries(Clones.clone(address(seriesSource)));
        ISeries(newContract).initialize(owner, seriesName);
        seriesOfMembers[owner].push(address(newContract));
        emit NewSeriesCreated(address(newContract), owner, seriesName);
    }

    function updateSeriesSource(address _newSource) external onlyOwner {
        seriesSource = ISeries(_newSource);
    }

    function mySeries() public view returns (address[] memory) {
        return seriesOfMembers[msg.sender];
    }

}