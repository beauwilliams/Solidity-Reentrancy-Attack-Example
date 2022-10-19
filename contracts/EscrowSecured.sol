// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EscrowSecure {
    mapping(address => uint) public balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

        //@dev: Here we have applied check effects interaction to secure this fn
    function withdraw() external {
        uint balance = balances[msg.sender];
        //CHECK
        if (balance <= 0) {
            revert("You have no deposited funds to withdraw");
        }

        //EFFECTS
        balances[msg.sender] = 0;

        //INTERACTION
        (bool sent, ) = msg.sender.call{value: balance}("");

        if (!sent){
            revert("Ether withdrawal failed");
        }
    }

    function getBalance() external view returns (uint) {
        return address(this).balance;
    }
}
