var async = require('async');
var chaiAsPromised = require('chai-as-promised');
var chai = require('chai');
var mochaLogger = require('mocha-logger');
var mlog = mochaLogger.mlog;
var expect = chai.expect; // we are using the "expect" style of Chai
chai.use(chaiAsPromised);
var Web3 = require('web3');
var web3 = new Web3();
web3.setProvider(new web3.providers.HttpProvider('http://localhost:8545'));

var accounts = web3.eth.accounts;

var database;
var productFactory;

var productABI = require('../build/contracts/Product.json').abi;
var productContract = web3.eth.contract(productABI);
var additionalInformation = "Additional Information";

async.series([
    function(callback) {
      describe('Deploy Database Contract.', function() {
        it('Contract address should not be undefined', function(done) {
            var databaseJson = require('../build/contracts/Database.json');
            var databaseABI = databaseJson.abi;
            var databaseBytecode = databaseJson.bytecode;
            var databaseContract = web3.eth.contract(databaseABI);
            database = databaseContract.new(
            {
                from: accounts[0],
                data: databaseBytecode,
                gas: '4700000'
            },
            function (e, contract){
                if (typeof contract.address !== 'undefined') {
                    done();
                    callback();
                }
            });
        });
      });
    },
    function(callback) {
      describe('Deploy productFactory Contract.', function() {
        it('Contract address should not be undefined', function(done) {
            var productFactoryJson = require('../build/contracts/ProductFactory.json');
            var productFactoryABI = productFactoryJson.abi;
            var productFactoryBytecode = productFactoryJson.bytecode;
            var productFactoryContract = web3.eth.contract(productFactoryABI);
            productFactory = productFactoryContract.new(
            {
                from: accounts[0],
                data: productFactoryBytecode,
                gas: '4700000'
            },
            function (e, contract){
                if (typeof contract.address !== 'undefined') {
                    done();
                    callback();
                }
            });
           
        });
      });
    },
    function(callback) {
      describe('Add Handler to Database.', function() {
        it('Transaction Hash should not be undefined', function(done) {
          database.addHandler(
            accounts[0],
            "Demo Handler",
            "This is an unreal Handler for demo purposes",
           {
             from: accounts[0],
             gas: '4700000'
           },
           function (e, txHash){
              done();
              callback();
           });
        });
        it('Handler must appear in the database.', function(done) {
          expect(database.addressToHandler(accounts[0])[0]).to.equal('Demo Handler');
          done();
        });
      });
    },
    function(callback) {
        describe('Create a product successfully.', function() {
        var product;
        var productName = "Test Product 1";
        let ts=  Date.now();
        let lon = 39.952583 * 10^10;
        let lat = -75.165222 * 10^10;
        let price=1;
        var prodId=1;
        
        it('Contract address should not be undefined', function(done) {
            productFactory.createProduct(
                prodId,
                productName,
                additionalInformation,
                ts,
                price,
                lon,
                lat,
                database.address,
                {
                    from: accounts[0],
                    gas: '4700000'
                },
                function (e, txHash){
                    if (typeof txHash !== 'undefined') {
                    done();
                    callback();
                    }
            });
        });
        it('Contract must appear in the database.', function(done) {
            product = productContract.at(database.items(0));
            expect(product.DATABASE_CONTRACT()).to.equal(database.address);
            done();
        });
        it('Product\'s first action should be "Product creation".', function(done) {
            let firstAction = product.actions(0);
            expect(web3.toAscii(firstAction[1]).replace(/[^\w\s]/gi, '')).to.equal("Product creation");
            done();
        });
        it('We should be able to get the product name.', function(done) {
            expect(web3.toAscii(product.name()).replace(/[^\w\s]/gi, '')).to.equal(productName);
            done();
        });
        
        });
        describe('Create an other product successfully.', function() {
        productName = "Test Product 2";
        prodId=2;
        price=2;
        let ts = Time.now();
        let lon = 39.952583 * 10^10;
        let lat = -75.165222 * 10^10;
        it('Contract address should not be undefined', function(done) {
            productFactory.createProduct(
                prodId,
                productName,
                additionalInformation,
                ts,
                price,
                lon,
                lat,
            database.address,
            {
            from: accounts[0],
            gas: '4700000'
            },
            function (e, txHash){
                if (typeof txHash !== 'undefined') {
                done();
                callback();
                }
            });
        });
        it('Contract must appear in the database.', function(done) {
            product = productContract.at(database.items(1));
            expect(product.DATABASE_CONTRACT()).to.equal(database.address);
            done();
        });
        it('Product\'s first action should be "Product creation".', function(done) {
            let firstAction = product.actions(0);
            expect(web3.toAscii(firstAction[1]).replace(/[^\w\s]/gi, '')).to.equal("Product creation");
            done();
        });
        it('We should be able to get the product name.', function(done) {
            expect(web3.toAscii(product.name()).replace(/[^\w\s]/gi, '')).to.equal(productName);
            done();
        });
        });
        mlog.log("Product adding tested.");
        callback();
    },
])

