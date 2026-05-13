// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {Box} from "../src/Box.sol";
import {TimeLock} from "../src/TimeLock.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployBox is Script {
    function run(TimeLock timeLock) external returns (Box) {
        HelperConfig helperConfig = new HelperConfig();
        (, uint256 deployerKey) = helperConfig.activeConfig();

        vm.startBroadcast(deployerKey);
        Box box = new Box();
        box.transferOwnership(address(timeLock));
        vm.stopBroadcast();

        console.log("Box deployed at:", address(box));
        console.log("Box owner (TimeLock):", address(timeLock));
        console.log("Chain ID:", block.chainid);
        return box;
    }
}
