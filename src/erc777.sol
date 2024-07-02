// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;


contract ERC777 {

    string internal mName;
    string internal mSymbol;
    uint256 internal mGranularity;
    uint256 internal mTotalSupply;

    address[] internal mDefaultOperators;
    mapping(address => bool) internal mIsDefaultOperators;

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _granularity,
        address [] memory _defaultOperators
    ) {
        mName = _name;
        mSymbol = _symbol;
        mTotalSupply = 0;
        require(_granularity >= 1, "Granularity must be > 1");
        mGranularity = _granularity;

        mDefaultOperators = _defaultOperators;

        for (uint256 i =0; i< mDefaultOperators.length; i++) {
            mIsDefaultOperators[mDefaultOperators[i]] = true;
        }
    }


}
