const { assert } = require("console");
const { ETIME } = require("constants");

const HEX0924 = artifacts.require("HEX0924");
const smartContract = artifacts.require("HEX0924_logic");
const safeMath = artifacts.require("safeMath");

contract("HEX0924 test", async (accounts) => {
    
    it ('Deploy HEX0924 Contract', async() => {
        const instance = await HEX0924.deployed();
        const logic = await smartContract.deployed();

        assert(instance.address !== '');
    });

    it ("UpgradeTo New Implement", async () => {
        const instance = await HEX0924.deployed();
        const logic = await smartContract.deployed();
        await instance.upgradeTo(logic.address);
        
        const result = await instance.getImplementation();
        
        assert(result === logic.address);
        
    });

    it ("Transfer token", async () => {
        const instance = await HEX0924.deployed();
        const logic = await smartContract.deployed();

        const reciever = '0x896790C671Dbb216f17352daBb11f3F475FABF77';
        const owner = await instance.getOwner();

        
        var reciever_balance = await logic.balanceOf(reciever);
        var owner_balance = await logic.balanceOf(owner);

        var value = 10000;

        await logic.transfer(reciever, value);
        
        var reciever_balance_after = await logic.balanceOf(reciever);
        var owner_balance_after = await logic.balanceOf(owner);
        
        assert(reciever_balance.toNumber()+value === reciever_balance_after.toNumber() &&
         owner_balance.toNumber()-value === owner_balance_after.toNumber());

    });

    it ("check sen ether logic", async() => {
        const instance = await HEX0924.deployed();
        const logic = await smartContract.deployed();
        const owner = await instance.getOwner();

        const account = '0x10eBa6dcF7d6946F747B7aD55De8aDE500d1C910';

        await web3.eth.sendTransaction(owner, instance, web3.utils.toWei('10', 'ether'));
        console.log(logic.balanceOf(account).toNumber());

    });



});
