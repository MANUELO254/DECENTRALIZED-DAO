// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {TimeLock} from "../src/TimeLock.sol";
import {MyGovernor} from "../src/MyGovernor.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract SetupGovernance is Script {
    function run(TimeLock timeLock, MyGovernor governor) external {
        HelperConfig helperConfig = new HelperConfig();
        (, uint256 deployerKey) = helperConfig.activeConfig();

        address deployer = vm.addr(deployerKey);

        vm.startBroadcast(deployerKey);

        bytes32 proposerRole = timeLock.PROPOSER_ROLE();
        bytes32 executorRole = timeLock.EXECUTOR_ROLE();
        bytes32 adminRole    = timeLock.DEFAULT_ADMIN_ROLE();

        timeLock.grantRole(proposerRole, address(governor));
        timeLock.grantRole(executorRole, address(0));       // open execution
        timeLock.revokeRole(adminRole, deployer);           // revoke deployer admin

        vm.stopBroadcast();

        console.log("Proposer role granted to governor:", address(governor));
        console.log("Executor role opened to address(0)");
        console.log("Admin role revoked from deployer:", deployer);
    }
}
