pragma solidity ^0.4.7;
import "./Product.sol";

contract Order{
    Product[] private productsList;

    function AddProduct(Product _toAdd) public
    {
        productsList.push(_toAdd);
    }
}