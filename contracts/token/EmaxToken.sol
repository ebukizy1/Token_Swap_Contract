// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.9;


import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EmaxToken is ERC20, Ownable {



    constructor()
        ERC20("EmaxToken", "EMX")
        Ownable(msg.sender)
    {
     mint(msg.sender, 300000000);

    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}