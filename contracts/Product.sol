pragma solidity ^0.4.23;
import "./Item.sol";

/*
    Copyright 2018, Premdas

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

/* @title Product Contract
   @author Premdas 
   @dev This contract represents a product in the OTS
   platform. This product lets the handlers to register actions on it or even combine
   it with other products. */
contract Product is Item{
   
    
    
    bytes32 private description;
    uint private creationTime;

    uint private price;
    enum ProductStatus{Created,InStock,InShipment,Deliverd}
    ProductStatus private status;
    // @dev all the actions which have been applied to the Product.
   

    constructor(uint _id, bytes32 _name, bytes32 _description,uint _creationTime, uint _price, int _lon, int _lat, address
     _DATABASE_CONTRACT, address _PRODUCT_FACTORY) public
    {
        id = _id;
        name = _name;
        description = _description;
        price = _price;
        creationTime = _creationTime;
        status = ProductStatus.Created;

        DATABASE_CONTRACT = _DATABASE_CONTRACT;
        ITEM_FACTORY = _PRODUCT_FACTORY;

        addAction("Product creation", _lon, _lat, _creationTime);
        Database database = Database(DATABASE_CONTRACT);
        database.storeItemReference(this);
    }
 
    function () public{
        // If anyone wants to send Ether to this contract, the transaction gets rejected
        revert();
    }

    
}

contract ProductFactory {

      /////////////////
     // Constructor //
    /////////////////

    /* @notice Constructor to create a Product Factory */
    constructor() public {}

    function () public {
        // If anyone wants to send Ether to this contract, the transaction gets rejected
        revert();
    }

    /* @notice Function to create a Product
       @param _id The id of the Product
       @param _name The name of the Product
       @param _description about the Product,
              generally as a JSON object.
       @param _timeStamp the UNIXTIME of creation */
    function createProduct( 
        uint _id, bytes32 _name, bytes32 _description,uint _creationTime, 
        uint _price, int _lon, int _lat, address DATABASE_CONTRACT) public returns(address) {
        return new Product(_id, _name, _description, _creationTime, _price, _lon, _lat, DATABASE_CONTRACT, this);
    }
}