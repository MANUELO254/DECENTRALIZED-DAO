//SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract Box is Ownable{

    uint256 public s_number;

    event NumberChanged(uint256);

    //constructor() Ownable(msg.sender);

    function store (uint256 newNumber) public {
        s_number = newNumber;
        emit NumberChanged(newNumber);
    }

    function getNumber() public returns (uint256){
        s_number;
    }
    
}