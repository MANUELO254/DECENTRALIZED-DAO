// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {DeployGovToken} from "./DeployGovToken.s.sol";
import {DeployTimeLock} from "./DeployTimeLock.s.sol";
import {DeployGovernor} from "./DeployGovernor.s.sol";
import {DeployBox} from "./DeployBox.s.sol";
import {SetupGovernance} from "./SetupGovernance.s.sol";
import {GovToken} from "../src/GovToken.sol";
import {TimeLock} from "../src/TimeLock.sol";
import {MyGovernor} from "../src/MyGovernor.sol";
import {Box} from "../src/Box.sol";

contract DeployAll is Script {
    function run() external returns (
        GovToken govToken,
        TimeLock timeLock,
        MyGovernor governor,
        Box box
    ) {
        (govToken,)  = new DeployGovToken().run();
        (timeLock,)  = new DeployTimeLock().run();
        governor     = new DeployGovernor().run(govToken, timeLock);
        box          = new DeployBox().run(timeLock);
        new SetupGovernance().run(timeLock, governor);

        console.log("=== Full Deployment Complete ===");
        console.log("GovToken:  ", address(govToken));
        console.log("TimeLock:  ", address(timeLock));
        console.log("MyGovernor:", address(governor));
        console.log("Box:       ", address(box));
        console.log("Chain ID:  ", block.chainid);
    }
}
