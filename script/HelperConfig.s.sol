// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script {
    struct NetworkConfig {
        uint256 minDelay;
        uint256 deployerKey;
    }

    uint256 public constant ANVIL_PRIVATE_KEY =
        0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80; // default anvil key

    NetworkConfig public activeConfig;

    constructor() {
        if (block.chainid == 11155111) {
            activeConfig = getSepoliaConfig();
        } else if (block.chainid == 11155420) {
            activeConfig = getOpSepoliaConfig();
        } else {
            activeConfig = getAnvilConfig();
        }
    }

    function getSepoliaConfig() public view returns (NetworkConfig memory) {
        return NetworkConfig({
            minDelay: 3600,
            deployerKey: vm.envUint("PRIVATE_KEY")
        });
    }

    function getOpSepoliaConfig() public view returns (NetworkConfig memory) {
        return NetworkConfig({
            minDelay: 3600,
            deployerKey: vm.envUint("PRIVATE_KEY")
        });
    }

    function getAnvilConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({
            minDelay: 3600,
            deployerKey: ANVIL_PRIVATE_KEY
        });
    }
}