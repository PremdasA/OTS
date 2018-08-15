pragma solidity ^0.4.7;
import "./Product.sol";
import "./Order.sol";

contract Customer{
    uint private id;
    string private fname;
    string private lname;
    address private custAddress;

    constructor (uint _id, string _fname, string _lname) public
    {
        id = _id;
        fname = _fname;
        lname = _lname;
        custAddress = this;
    }
}


