// SPDX-FileCopyrightText: 2025 P2P Validator <info@p2p.org>
// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import {Test, console} from "forge-std/Test.sol";
import "../src/P2PPectraBulker.sol";
import {BaseTest} from "./BaseTest.t.sol";

contract HoodiTest is BaseTest {
    function setUp() public {
        vm.createSelectFork("hoodi", 254403);

        sourcePubkeyList.push(hex"95fc74e5fe24796ef39d6e6ccd49a00c1829cc75144b18c4c142848a325fcb9bc4aeb269a700784be739338cb1acad2d");
        sourcePubkeyList.push(hex"95fc74e5fe24796ef39d6e6ccd49a00c1829cc75144b18c4c142848a325fcb9bc4aeb269a700784be739338cb1acad2d");
        sourcePubkeyList.push(hex"95fc74e5fe24796ef39d6e6ccd49a00c1829cc75144b18c4c142848a325fcb9bc4aeb269a700784be739338cb1acad2d");

        client = makeAddr("client");
        deployer = makeAddr("deployer");
        deal(client, 10 ether);
        deal(deployer, 10 ether);

        vm.startPrank(deployer);
        p2pPectraBulker = new P2PPectraBulker();

        deal(address(p2pPectraBulker), 10 ether);

        vm.stopPrank();
    }
}