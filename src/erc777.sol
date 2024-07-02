// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;
import {Math} from "lib/openzeppelin-contracts/contracts/utils/math/Math.sol";



contract ERC777 {
    using Math for uint256;

    // EVENTS 
    event Sent(address operator, address from, address to, uint256 amount, bytes data, bytes operatorData);
    event Burnt(address operator, address tokenHolder, uint256 amount, bytes data, bytes operatorData);
    event AuthorizedOperator(address operator, address from);
    event RevokedOperator(address operator, address from);

    string internal mName;
    string internal mSymbol;
    uint256 internal mGranularity;
    uint256 internal mTotalSupply;

    mapping(address => uint256) internal mBalances;

    address[] internal mDefaultOperators;
    mapping(address => bool) internal mIsDefaultOperators;
    mapping(address=> mapping(address => bool)) internal mRevokeDefaultOperator;
    mapping(address=> mapping(address => bool)) internal mAuthorizedOperators;

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

    function name() public view returns(string memory) {
        return mName;
    }

    function symbol() public view returns(string memory) {
        return mSymbol;
    }

    function granularity() public view returns (uint256) {
        return mGranularity;
    }
    
    function totalSupply() public view returns (uint256) {
        return mTotalSupply;
    }

    function balanceOf(address _tokenHolder) public view returns(uint256) {
        return mBalances[_tokenHolder];
    }

    function defaultOperators() public view returns (address[] memory) {
        return mDefaultOperators;
    }

    function send(address _to, uint256 _amount, bytes calldata _data) external {
        doSend(msg.sender, msg.sender, _to, _amount, _data, "");
    }

    function authorizeOperator(address _operator) external {
        require(_operator != msg.sender, "Cannout authorize yourself as an operator");
        if (mIsDefaultOperators[_operator]){
            mRevokeDefaultOperator[_operator][msg.sender] = false;
        } else {
            mAuthorizedOperators[_operator][msg.sender] = true;
        }

        emit AuthorizedOperator(_operator, msg.sender);
    }

    function revokeOperator(address _operator) external {
        require(_operator != msg.sender, "Cannout authorize yourself as an operator");
        if (mIsDefaultOperators[_operator]) {
            mRevokeDefaultOperator[_operator][msg.sender] = true;
        } else {
            mAuthorizedOperators[_operator][msg.sender] = false;
        }

        emit RevokedOperator(_operator, msg.sender);
    }

    function isOperatorFor(address _operator, address _tokenHolder) public view returns (bool) {
        return (_operator == _tokenHolder || mAuthorizedOperators[_operator][_tokenHolder] || (mIsDefaultOperators[_operator] && !mRevokeDefaultOperator[_operator][_tokenHolder]));
    }

    function operatorSend(
        address _from, 
        address _to, 
        uint256 _amount, 
        bytes calldata _data,
        bytes calldata _operatorData
    ) external {
        require(isOperatorFor(msg.sender, _from), "Not an operator");
        doSend(msg.sender, _from, _to, _amount, _data, _operatorData);
    }

    function burn(uint256 _amount, bytes calldata _data) external {
        doBurn(msg.sender, msg.sender, _amount, _data, "");
    }

    function doSend(
        address _operator,
        address _from,
        address _to,
        uint256 _amount,
        bytes memory _data,
        bytes memory _operatorData
    ) internal {

        require(_to != address(0), "Cannot send to 0x0");
        require(mBalances[_from] >= _amount, "Not enought funds");

        mBalances[_from] = mBalances[_from] - _amount;
        mBalances[_to] = mBalances[_to] + _amount;

        emit Sent(_operator, _from, _to, _amount, _data, _operatorData);
    }

    function doBurn(
        address _operator,
        address _tokenHolder,
        uint256 _amount,
        bytes memory _data,
        bytes memory _operatorData
    ) internal {
        requireMultiple(_amount);
        require(balanceOf(_tokenHolder) >= _amount, "Not enough funds");

        mBalances[_tokenHolder] = mBalances[_tokenHolder] - _amount;
        mTotalSupply = mTotalSupply - _amount;

        emit Burnt(_operator, _tokenHolder, _amount, _data, _operatorData);
    }

    function requireMultiple(uint256 _amount) internal view {
        require(_amount % mGranularity == 0, "Amount is not a multiple of granularity");
    }

}
