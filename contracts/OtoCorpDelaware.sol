// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.0;

import "./OtoCorp.sol";

contract OtoCorpDelaware is OtoCorp {

    constructor(ISeries _source) OtoCorp(_source){}

    function createSeriesWithOwner(address owner, string memory seriesName) public onlyRegistry override {
        ISeries newContract = ISeries(Clones.clone(address(seriesSource)));
        string memory newSeriesName = string(abi.encodePacked(seriesName, ' LLC'));
        ISeries(newContract).initialize(owner, newSeriesName);
        seriesOfMembers[owner].push(address(newContract));
        emit NewSeriesCreated(address(newContract), owner, newSeriesName);
    }

}