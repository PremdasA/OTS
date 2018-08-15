 pragma solidity ^0.4.7;

// import "contracts/Database.sol";
// import "contracts/Order.sol";


// /* @title Shipment Contract
//    @author Ido Kamma based on David Riudor
//    @dev This contract represents a Shipment to be tracked in the TODO put name of platform **
//    platform. This Shipment lets the handlers to register products on it or even combine
//    it with other shipments. */

//  /* @dev Constructor for a Product */
// contract Shipment {
//     // @dev Reference to its database contract.
//     address public DATABASE_CONTRACT;
//     // @dev Reference to its product factory.
//     address public SHIPMENT_FACTORY;

//     // @dev This struct represents an action realized by a handler on the product.
//     struct Action {
//         //@dev address of the individual or the organization who realizes the action.
//         address handler;
//         //@dev description of the action.
//         bytes32 description;

//         // @dev Longitude x10^10 where the Action is done.
//         int lon;
//         // @dev Latitude x10^10 where the Action is done.
//         int lat;

//         // @dev Instant of time when the Action is done.
//         uint timestamp;
//         // @dev Block when the Action is done.
//         uint blockNumber;
//     }

  
//     // @dev addresses of the products which are built by this Product.
//     address[] public orders;

//     // @dev indicates the shipment status.
//     enum ShipmentStatus {Created,Waiting,Ready,Deliver,Finished}

//     ShipmentStatus status;

//     // @dev indicates the name of a shipment.
//     bytes32 public name;

//     // @dev Additional information about the Shipment, generally as a JSON object
//     bytes32 public additionalInformation;

//     // @dev all the actions which have been applied to the Shipment.
//     Action[] public actions;

//         /////////////////
//     // Constructor //
//     /////////////////

//     /* @notice Constructor to create a Shipment
//         @param _name The name of the Product
//         @param _additionalInformation Additional information about the Shipment,
//                 generally as a JSON object.
//         @param _orders Addresses of the orders of the Shipment.
//         @param _lon Longitude x10^10 where the Shipment is created.
//         @param _lat Latitude x10^10 where the Shipment is created.
//         @param _timeStamp current UNIXTIME of creation.
//         @param _DATABASE_CONTRACT Reference to its database contract
//         @param _SHIPMENT_FACTORY Reference to its shipment factory */
//     constructor(bytes32 _name, bytes32 _additionalInformation, address[] _orders,
//      int _lon, int _lat, uint _timeStamp, address _DATABASE_CONTRACT, address _PRODUCT_FACTORY) public{
//         name = _name;
//         isConsumed = false;
//         orders = _orders;
//         additionalInformation = _additionalInformation;
//         status = ShipmentStatus.Created;

//         DATABASE_CONTRACT = _DATABASE_CONTRACT;
//         SHIPMENT_FACTORY = _SHIPMENT_FACTORY;

//         Action memory creation;
//         creation.handler = msg.sender;
//         creation.description = "SHIPMENT creation";
//         creation.lon = _lon;
//         creation.lat = _lat;
//         creation.timestamp = _timeStamp;
//         creation.blockNumber = block.number;

//         actions.push(creation);

//         Database database = Database(DATABASE_CONTRACT);
//         database.storeShipmentReference(this);
//     }

//     function () public{
//         // If anyone wants to send Ether to this contract, the transaction gets rejected
//         revert();
//     }

//         /* @notice Function to add an Action to the shipment.
//         @param _description The description of the Action.
//         @param _lon Longitude x10^10 where the Action is done.
//         @param _lat Latitude x10^10 where the Action is done.
//         @param _newProductNames In case that this Action creates more products from
//                 this Product, the names of the new products should be provided here.
//         @param _newProductsAdditionalInformation In case that this Action creates more products from
//                 this Product, the additional information of the new products should be provided here.
//         @param _consumed True if the product becomes consumed after the action. */
//     function addAction(
//         bytes32 _description, int _lon, int _lat,uint _timeStamp, bytes32[] _newProductsNames,
//         bytes32[] _newProductsAdditionalInformation, bool _consumed) public notConsumed {
//         assert(_newProductsNames.length == _newProductsAdditionalInformation.length);

//         Action memory action;
//         action.handler = msg.sender;
//         action.description = _description;
//         action.lon = _lon;
//         action.lat = _lat;
//         action.timestamp = _timeStamp;
//         action.blockNumber = block.number;

//         actions.push(action);

//         ProductFactory productFactory = ProductFactory(PRODUCT_FACTORY);

//         for (uint i = 0; i < _newProductsNames.length; ++i) {
//             address[] memory parentProduct = new address[](1);
//             parentProducts[0] = this;
//             productFactory.createProduct(_newProductsNames[i], _newProductsAdditionalInformation[i],
//             parentProduct, _lon, _lat, _timeStamp, DATABASE_CONTRACT);
//         }

//         isConsumed = _consumed;
//     }

//     /* @notice Function to merge some products to build a new one.
//      @param otherProducts addresses of the other products to be merged.
//      @param newProductsName Name of the new product resulting of the merge.
//      @param newProductAdditionalInformation Additional information of the new product resulting of the merge.
//      @param _lon Longitude x10^10 where the merge is done.
//      @param _lat Latitude x10^10 where the merge is done. */
//     function merge(
//         address[] _otherProducts, bytes32 _newProductName, bytes32 _newProductAdditionalInformation,
//         int _lon, int _lat, uint _timeStamp) public notConsumed {
//         ProductFactory productFactory = ProductFactory(PRODUCT_FACTORY);
//         address newProduct = productFactory.createProduct(_newProductName, 
//         _newProductAdditionalInformation, _otherProducts, _lon, _lat, _timeStamp, DATABASE_CONTRACT);

//         this.collaborateInMerge(newProduct, _lon, _lat, _timeStamp);
//         for (uint i = 0; i < _otherProducts.length; ++i) {
//             Product prod = Product(_otherProducts[i]);
//             prod.collaborateInMerge(newProduct, _lon, _lat, _timeStamp);
//         }
//     }

//     /* @notice Function to collaborate in a merge with some products to build a new one.
//     @param newProductsAddress Address of the new product resulting of the merge. */
//     function collaborateInMerge(address newProductAddress, int lon, int lat, uint _timeStamp) public notConsumed {
//         childProducts.push(newProductAddress);

//         Action memory action;
//         action.handler = this;
//         action.description = "Collaborate in merge";
//         action.lon = lon;
//         action.lat = lat;
//         action.timestamp = _timeStamp;
//         action.blockNumber = block.number;

//         actions.push(action);

//         this.consume();
//     }

//     /* @notice Function to consume the Product */
//     function consume() public notConsumed {
//         isConsumed = true;
//     }
// }

// /* @title Product Factory Contract
//    @author Andreu Rodíguez i Donaire
//    @dev This contract represents a product factory which represents products to be tracked in
//    the TODO put name of platform ** platform. This product lets the handlers to register actions
//    on it or even combine it with other products. */
// contract ProductFactory {

//       /////////////////
//      // Constructor //
//     /////////////////

//     /* @notice Constructor to create a Product Factory */
//     constructor() public {}

//     function () public {
//         // If anyone wants to send Ether to this contract, the transaction gets rejected
//         revert();
//     }

//     /* @notice Function to create a Product
//        @param _name The name of the Product
//        @param _additionalInformation Additional information about the Product,
//               generally as a JSON object.
//        @param _parentProducts Addresses of the parent products of the Product.
//        @param _lon Longitude x10^10 where the Product is created.
//        @param _lat Latitude x10^10 where the Product is created.
//        @param _timeStamp the UNIXTIME of creation
//        @param _DATABASE_CONTRACT Reference to its database contract */
//     function createProduct(
//         bytes32 _name, bytes32 _additionalInformation, address[] _parentProducts, 
//         int _lon, int _lat,uint _timeStamp, address DATABASE_CONTRACT) public returns(address) {
//         return new Product(_name, _additionalInformation, _parentProducts, _lon, _lat, _timeStamp, DATABASE_CONTRACT, this);
//     }
// }
