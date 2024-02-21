// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.9;

import "../interface/IERC20.sol";
import "../library/Calculator.sol";
import "../library/ErrorMessage.sol";

contract SwappedToken {
    using Calculator for *;
    using ErrorMessage for *;

    address public emaxToken;
    address public manoToken;
    uint public rateToken1ToToken2 = 1000;
    uint public rateDecimals = 18;
    uint minimumTokenToSwap = 500;
    uint public cal;
    address private owner;

    constructor(address _token1, address _token2) {
        emaxToken = _token1;
        manoToken = _token2;
        owner = msg.sender;
        // rateToken1ToToken2 = _rateToken1ToToken2;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "you are not the owner");
        _;
    }

    mapping(address => uint) balance;

    function manoTokenToEmaxToken(uint256 _manoTokenAmount) external {
        ErrorMessage.ADDRESS_ZERO_CHECKED(msg.sender);
        ErrorMessage.AMOUNT_TOO_LOW_FOR_SWAP( _manoTokenAmount, minimumTokenToSwap );

        if (_manoTokenAmount > IERC20(manoToken).balanceOf(msg.sender)) {
            revert ErrorMessage.INSUFFICIENT_BALANCE();
        }
        // Transfer MANO tokens from the sender to the contract
        if ( !IERC20(manoToken).transferFrom(  msg.sender,address(this),_manoTokenAmount ) ) {
            revert ErrorMessage.TRANSACTION_FAILED();
        }

        uint _amountTokenToBeTransferred = Calculator.calculateExchangeRateOfToken(rateToken1ToToken2,_manoTokenAmount, rateDecimals  );

        if ( _amountTokenToBeTransferred >   IERC20(emaxToken).balanceOf(address(this)) ) {
            revert ErrorMessage.UNABLE_TO_DISPENSE_TOKEN();
        }
        // Transfer EMAX tokens to the user
        if ( !IERC20(emaxToken).transfer(msg.sender, _amountTokenToBeTransferred)  ) {
            revert ErrorMessage.TRANSACTION_FAILED();
        }
    }



    function transferEmaxFundToContract(uint256 _amount) external onlyOwner {
        IERC20(emaxToken).transferFrom(msg.sender, address(this), _amount);
    }



    function updateRate(uint256 _newRateToken1ToToken2) external onlyOwner {
        rateToken1ToToken2 = _newRateToken1ToToken2;
    }


    function checkWalletBalanceManoToken(address _addres) external onlyOwner view returns (uint256) {
        return (IERC20(manoToken).balanceOf(_addres));
    }

      function checkWalletBalanceEmaxToken(address _addres) external onlyOwner view returns (uint256) {
        return (IERC20(manoToken).balanceOf(_addres));
    }

}
    // function transferFundToContract() private {
    //     IERC20(emaxToken).transfer(address(this), 3000000);
    // }