// SPDX-FileCopyrightText: 2025 P2P Validator <info@p2p.org>
// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import {Script} from "forge-std/Script.sol";
import {P2PPectraBulker} from "../src/P2PPectraBulker.sol";

contract Deploy is Script {
    function run() public {
        uint256 deployerKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerKey);
        new P2PPectraBulker();
        vm.stopBroadcast();
    }
}