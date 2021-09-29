// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract SeriesToken is Initializable, ERC20 {

    string private _name;
    string private _symbol;

    constructor() ERC20("Source Token", "TOK") { }

    function initialize(string memory name_, string memory symbol_, uint256 _supply, address creator) public initializer {
        _name = name_;
        _symbol = symbol_;
        _mint(creator, _supply);
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view override returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view override returns (string memory) {
        return _symbol;
    }
}