// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {GovToken} from "../src/GovToken.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployGovToken is Script {
    function run() external returns (GovToken, HelperConfig) {
        HelperConfig helperConfig = new HelperConfig();
        (uint256 minDelay, uint256 deployerKey) = helperConfig.activeConfig();
        // minDelay unused here but kept for consistent config access pattern

        vm.startBroadcast(deployerKey);
        GovToken govToken = new GovToken();
        vm.stopBroadcast();

        console.log("GovToken deployed at:", address(govToken));
        console.log("Chain ID:", block.chainid);
        return (govToken, helperConfig);
    }
}
