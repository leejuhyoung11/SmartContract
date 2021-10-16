// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";

import "../contracts/HEX0924.sol";
import "../contracts/smartContract.sol";

contract TestHEX0924 {

    HEX0924 hex0924 = HEX0924(DeployedAddresses.HEX0924());

}

contract TestHEX0924_logic {
    HEX0924 hex0924 = HEX0924(DeployedAddresses.HEX0924());
    HEX0924_logic logic = HEX0924_logic(DeployedAddresses.HEX0924_logic());

    function beforeEach() public {
        Assert.isTrue(hex0924.upgradeTo(DeployedAddresses.HEX0924_logic()), "UpgradeTo function success");
    }

    function testbalanceOf() public {
        uint expected = 10**20;
        
        Assert.equal(logic.balanceOf(tx.origin), expected, "Owner should have 10**20 initially");
    }

}