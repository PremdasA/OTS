pragma solidity ^0.4.7;

import "./Database.sol";

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

/* @title item Contract
   @author Premdas 
   @dev This contract represents a basic item in the OTS
   platform. This item lets the handlers to register actions on it or even combine
   it with other items. */
contract Item {
     // @dev Reference to its database contract.
    address public DATABASE_CONTRACT;

    // @dev Reference to its item factory.
    address public ITEM_FACTORY;

    uint public id;
    bytes32 public name; 

    Action[] public actions;

    // @dev This struct represents an action realized by a handler on the product.
    struct Action {
        //@dev address of the individual or the organization who realizes the action.
        address handler;
        //@dev description of the action.
        bytes32 description;

        // @dev Longitude x10^10 where the Action is done.
        int lon;
        // @dev Latitude x10^10 where the Action is done.
        int lat;

        // @dev Instant of time when the Action is done.
        uint timestamp;
        // @dev Block when the Action is done.
        uint blockNumber;
    }

    
        /* @notice Function to add an Action to the item.
        @param _description The description of the Action.
        @param _lon Longitude x10^10 where the Action is done.
        @param _lat Latitude x10^10 where the Action is done.
        */
    function addAction(
        bytes32 _description, int _lon, int _lat,uint _timeStamp) public{
        Action memory action;
        action.handler = msg.sender;
        action.description = _description;
        action.lon = _lon;
        action.lat = _lat;
        action.timestamp = _timeStamp;
        action.blockNumber = block.number;
        actions.push(action);

    
    }
}