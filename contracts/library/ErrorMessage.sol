// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.9;

library ErrorMessage{
    error ADDRESS_ZERO_ERROR();
    error  AMOUNT_TOO_LOW_ERROR_FOR_SWAP();
    error INSUFFICIENT_BALANCE();
    error UNABLE_TO_DISPENSE_TOKEN();
    error INSUFFICIENT_ALLOWANCE();
    error TRANSACTION_FAILED();


    function ADDRESS_ZERO_CHECKED(address _sender) internal pure{
           if(_sender == address(0)) {
                revert ErrorMessage.ADDRESS_ZERO_ERROR();
            }
    }

       function AMOUNT_TOO_LOW_FOR_SWAP(uint _tokenAmount, uint _minimumAmountToBeSwaped) internal pure{
         if(_tokenAmount < _minimumAmountToBeSwaped){
            revert ErrorMessage.AMOUNT_TOO_LOW_ERROR_FOR_SWAP();
         }
    }


  
         
}