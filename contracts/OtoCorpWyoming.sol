// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.0;

import "./OtoCorp.sol";

contract OtoCorpWyoming is OtoCorp {

    uint private seriesIndex = 1;

    constructor(ISeries _source) OtoCorp(_source){}

    function createSeries(address owner, string memory seriesName) public override {
        ISeries newContract = ISeries(Clones.clone(address(seriesSource)));
        string memory newSeriesName = string(abi.encodePacked(seriesName, ' - Series ', getIndex()));
        ISeries(newContract).initialize(owner, newSeriesName);
        seriesIndex++;
        seriesOfMembers[owner].push(address(newContract));
        emit NewSeriesCreated(address(newContract), newContract.owner(), newContract.getName());
    }

    function getIndex() public view returns (string memory) {
        return uintToStr(seriesIndex);
    }

    function uintToStr(uint x) private pure returns (string memory) {
        if (x > 0) {
            string memory str;
            uint y = x;
            while (y > 0) {
                str = string(abi.encodePacked(uint8(y % 16 + (y % 16 < 10 ? 48 : 87)), str));
                y /= 16;
            }
            return str;
        }
        return "0";
    }

}