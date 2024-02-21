// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.9;

library Calculator {

function calculateExchangeRateOfToken(uint rateToken1ToToken2, uint _amountToken1, uint rateDecimals) internal pure returns (uint) {
    // Adjust the amount using the rate and decimals directly
    uint256 amountToken2 = (_amountToken1 * rateToken1ToToken2) / (10 ** rateDecimals);
    return amountToken2;
}


}