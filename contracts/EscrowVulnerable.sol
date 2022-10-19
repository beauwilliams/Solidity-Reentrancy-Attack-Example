pragma solidity ^0.8.0;

contract EscrowVulnerable {
    mapping(address => uint) public balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() external {
        uint balance = balances[msg.sender];
        if (balance <= 0) {
            revert("You have no deposited funds to withdraw");
        }

        /*
        Here is our state change. This is performed before a transfer.
        Preventing an attacker to use a receive() function to drain the funds.
        Using check effects interaction pattern we can move this line above the msg.sender.call()
        This technique can avoid risk of reentrancy, aside from using a modifier to lock the fn.
        */
        balances[msg.sender] = 0;
        (bool sent, ) = msg.sender.call{value: balance}("");

        if (!sent){
            revert("Ether withdrawal failed");
        }
    }

    function getBalance() external view returns (uint) {
        return address(this).balance;
    }
}
