// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Vault {

    struct Beneficiary {
        address beneficiaryAddress;
        uint amount;
        uint releaseTime;
        bool claimed;
    }

    mapping(address => Beneficiary[]) public beneficiaries;
    
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function deposit(address _beneficiary, uint _amount, uint _releaseTime) public payable {
        require(msg.value == _amount, "Deposit amount mismatch");
        require(_releaseTime > block.timestamp, "Release time must be in future");
        
        beneficiaries[msg.sender].push(Beneficiary({
            beneficiaryAddress: _beneficiary,
            amount: _amount,
            releaseTime: block.timestamp + _releaseTime, 
            claimed: false  
        }));
    }

    function withdraw(uint _index) public {
        require(msg.sender == owner, "Only owner can withdraw");
        Beneficiary[] storage deposits = beneficiaries[msg.sender];
        
        require(_index < deposits.length, "Invalid index");
        Beneficiary memory b = deposits[_index];
        
        payable(msg.sender).transfer(b.amount);
    } 

    function claim() public {
         Beneficiary[] storage deposits = beneficiaries[msg.sender];
        for(uint i = 0; i < deposits.length; i++) {
            Beneficiary storage b = deposits[i];
            require(block.timestamp >= b.releaseTime, "Funds not yet released");
            require(!b.claimed, "Already claimed");

            b.claimed = true;
            payable(msg.sender).transfer(b.amount);
    }
}
}