pragma solidity ^0.4.7;

contract Owned {
    address public owner;

    constructor() public{
        owner = msg.sender;
    }

    modifier onlyOwner {
        assert(msg.sender == owner);
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        owner = newOwner;
    }
}