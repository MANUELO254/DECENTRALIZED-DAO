// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {MyGovernor} from "../src/MyGovernor.sol";
import {GovToken} from "../src/GovToken.sol";
import {TimeLock} from "../src/TimeLock.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployGovernor is Script {
    function run(
        GovToken govToken,
        TimeLock timeLock
    ) external returns (MyGovernor) {
        HelperConfig helperConfig = new HelperConfig();
        (, uint256 deployerKey) = helperConfig.activeConfig();

        vm.startBroadcast(deployerKey);
        MyGovernor governor = new MyGovernor(govToken, timeLock);
        vm.stopBroadcast();

        console.log("MyGovernor deployed at:", address(governor));
        console.log("Chain ID:", block.chainid);
        return governor;
    }
}
