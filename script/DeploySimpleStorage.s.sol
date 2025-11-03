// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { Script } from "forge-std/Script.sol";
import { SimpleStorage } from "../src/SimpleStorage.sol";

contract DeploySimpleStorage is Script {
    function run() external returns (SimpleStorage) {
        vm.startBroadcast();
        // we can also send value like this
        // SimpleStorage simpleStorage = new SimpleStorage{value: 1 ether}();
        SimpleStorage simpleStorage = new SimpleStorage(); // the simpleStorage stores the address of the deployed
        // contract
        vm.stopBroadcast();
        return simpleStorage;
    }
}

