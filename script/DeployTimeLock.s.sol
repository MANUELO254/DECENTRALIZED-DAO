// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {TimeLock} from "../src/TimeLock.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployTimeLock is Script {
    function run() external returns (TimeLock, HelperConfig) {
        HelperConfig helperConfig = new HelperConfig();
        (uint256 minDelay, uint256 deployerKey) = helperConfig.activeConfig(); // ✅ single destructure

        address[] memory proposers = new address[](0);
        address[] memory executors = new address[](0);

        vm.startBroadcast(deployerKey);
        TimeLock timeLock = new TimeLock(minDelay, proposers, executors);
        vm.stopBroadcast();

        console.log("TimeLock deployed at:", address(timeLock));
        console.log("Min delay:", minDelay);
        console.log("Chain ID:", block.chainid);
        return (timeLock, helperConfig);
    }
}