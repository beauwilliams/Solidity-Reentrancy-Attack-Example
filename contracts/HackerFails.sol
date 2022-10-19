
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./EscrowSecure.sol"

contract Hacker {
    EscrowSecure public secureEscrowContract;

    constructor(address escrowAddress) {
        secureEscrowContract = EscrowSecure(escrowAddress);
    }

    function attack() external payable {
        require(msg.value >= 1 ether);
        secureEscrowContract.deposit{value: 1 ether}();
        secureEscrowContract.withdraw();
    }

    /*
    The hacker will attempt to exploit our contract and fail
    because it implemented check effects interaction pattern
    */
    receive() external payable {
        if (address(secureEscrowContract).balance >= 1 ether) {
            secureEscrowContract.withdraw();
        }
    }

    function getBalance() external view returns (uint) {
        return address(this).balance;
    }
}
