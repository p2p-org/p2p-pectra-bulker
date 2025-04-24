// SPDX-FileCopyrightText: 2025 P2P Validator <info@p2p.org>
// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import {Test, console} from "forge-std/Test.sol";
import "../src/P2PPectraBulker.sol";

abstract contract BaseTest is Test {
    P2PPectraBulker public p2pPectraBulker;
    address public deployer;
    address public client;

    bytes public targetPubkey = hex"b07f6b42a68fdc12f41b0c1984fcee63c465f72335d37b1ee099355a06fd4d9d3d07b184dc8de82b9507547581118e88";
    bytes public sourcePubkey = hex"95fc74e5fe24796ef39d6e6ccd49a00c1829cc75144b18c4c142848a325fcb9bc4aeb269a700784be739338cb1acad2d";
    bytes[] public sourcePubkeyList;

    function test_ConsolidateValidators() public {
        vm.startPrank(client);

        p2pPectraBulker.consolidateValidators{value: 1 ether}(sourcePubkey, targetPubkey);

        vm.stopPrank();
    }

    function test_ConsolidateValidators__CallingRequestFailed() public {
        vm.startPrank(client);
    
        vm.expectRevert(P2PPectraBulker__CallingConsolidationRequestFailed.selector);
        p2pPectraBulker.consolidateValidators(sourcePubkey, targetPubkey);

        vm.stopPrank();
    }

    function test_ConsolidateValidators__CheckingBalanceRefund() public {
        vm.startPrank(client);

        uint256 balanceBefore = client.balance;
        p2pPectraBulker.consolidateValidators{value: 1 ether}(sourcePubkey, targetPubkey);
        uint256 balanceAfter = client.balance;

        assertEq(balanceBefore - balanceAfter, 3);

        vm.stopPrank();
    }

    function test_ConsolidateValidators__InvalidTargetPubkeyLength() public {
        vm.startPrank(client);

        bytes memory invalidTargetPubkey = hex"b07f6b42a68fdc12f41b0c1984fcee63c465f72335";
        bytes memory expectedError = abi.encodeWithSelector(
            P2PPectraBulker__InvalidPubkeyLength.selector,
            "targetPubkey",
            invalidTargetPubkey
        );

        vm.expectRevert(expectedError);
        p2pPectraBulker.consolidateValidators{value: 1 ether}(sourcePubkey, invalidTargetPubkey);

        vm.stopPrank();
    }

    function test_ConsolidateValidators__InvalidSourcePubkeyLength() public {
        vm.startPrank(client);

        bytes memory invalidSourcePubkey = hex"95fc74e5fe24796ef39d6e6ccd49a00c1829cc75144b18c4c142848a325fcb9bc4aeb269";
        bytes memory expectedError = abi.encodeWithSelector(
            P2PPectraBulker__InvalidPubkeyLength.selector,
            "sourcePubkey",
            invalidSourcePubkey
        );

        vm.expectRevert(expectedError);
        p2pPectraBulker.consolidateValidators{value: 1 ether}(invalidSourcePubkey, targetPubkey);

        vm.stopPrank();
    }

    function test_BulkConsolidateValidators() public {
        vm.startPrank(client);

        p2pPectraBulker.bulkConsolidateValidators{value: 1 ether}(sourcePubkeyList, targetPubkey);

        vm.stopPrank();
    }

    function test_BulkConsolidateValidators__CallingRequestFailed() public {
        vm.startPrank(client);
    
        vm.expectRevert(P2PPectraBulker__CallingConsolidationRequestFailed.selector);
        p2pPectraBulker.bulkConsolidateValidators(sourcePubkeyList, targetPubkey);

        vm.stopPrank();
    }

    function test_BulkConsolidateValidators__CheckingBalanceRefund() public {
        vm.startPrank(client);

        uint256 balanceBefore = client.balance;
        p2pPectraBulker.bulkConsolidateValidators{value: 1 ether}(sourcePubkeyList, targetPubkey);
        uint256 balanceAfter = client.balance;

        assertEq(balanceBefore - balanceAfter, 9);

        vm.stopPrank();
    }

    function test_BulkConsolidateValidators__InvalidTargetPubkeyLength() public {
        vm.startPrank(client);

        bytes memory invalidTargetPubkey = hex"b07f6b42a68fdc12f41b0c1984fcee63c465f72335";
        bytes memory expectedError = abi.encodeWithSelector(
            P2PPectraBulker__InvalidPubkeyLength.selector,
            "targetPubkey",
            invalidTargetPubkey
        );

        vm.expectRevert(expectedError);
        p2pPectraBulker.bulkConsolidateValidators{value: 1 ether}(sourcePubkeyList, invalidTargetPubkey);

        vm.stopPrank();
    }

    function test_BulkConsolidateValidators__InvalidSourcePubkeyListLength() public {
        vm.startPrank(client);

        bytes[] memory invalidSourcePubkeyList;
        
        vm.expectRevert(P2PPectraBulker__SourcePubkeyListIsEmpty.selector);
        p2pPectraBulker.bulkConsolidateValidators{value: 1 ether}(invalidSourcePubkeyList, targetPubkey);

        vm.stopPrank();
    }

    function test_BulkConsolidateValidators__InvalidSourcePubkeyLength() public {
        vm.startPrank(client);

        bytes memory invalidSourcePubkey = hex"95fc74e5fe24796ef39d6e6ccd49a00c1829cc75144b18c4c142848a325fcb9bc4aeb269";
        bytes[] memory invalidSourcePubkeyList = new bytes[](3);
        invalidSourcePubkeyList[0] = sourcePubkey;
        invalidSourcePubkeyList[1] = invalidSourcePubkey;
        invalidSourcePubkeyList[2] = sourcePubkey;

        bytes memory expectedError = abi.encodeWithSelector(
            P2PPectraBulker__InvalidPubkeyLength.selector,
            "sourcePubkey",
            invalidSourcePubkey
        );

        vm.expectRevert(expectedError);
        p2pPectraBulker.bulkConsolidateValidators{value: 1 ether}(invalidSourcePubkeyList, targetPubkey);

        vm.stopPrank();
    }

    function test_PartialWithdraw() public {
        vm.startPrank(client);

        p2pPectraBulker.partialWithdraw{value: 1 ether}(targetPubkey, 1);

        vm.stopPrank();
    }

    function test_PartialWithdraw__CallingRequestFailed() public {
        vm.startPrank(client);
    
        vm.expectRevert(P2PPectraBulker__CallingPartialWithdrawalRequestFailed.selector);
        p2pPectraBulker.partialWithdraw(targetPubkey, 1);

        vm.stopPrank();
    }

    function test_PartialWithdraw__CheckingBalanceRefund() public {
        vm.startPrank(client);

        uint256 balanceBefore = client.balance;
        p2pPectraBulker.partialWithdraw{value: 1 ether}(targetPubkey, 1);
        uint256 balanceAfter = client.balance;

        assertEq(balanceBefore - balanceAfter, 3);

        vm.stopPrank();
    }

    function test_PartialWithdraw__InvalidPubkeyLength() public {
        vm.startPrank(client);

        bytes memory invalidPubkey = hex"b07f6b42a68fdc12f41b0c1984fcee63c465f72335";
        bytes memory expectedError = abi.encodeWithSelector(
            P2PPectraBulker__InvalidPubkeyLength.selector,
            "pubkey",
            invalidPubkey
        );

        vm.expectRevert(expectedError);
        p2pPectraBulker.partialWithdraw{value: 1 ether}(invalidPubkey, 1);

        vm.stopPrank();
    }

    function test_BulkPartialWithdraw() public {
        vm.startPrank(client);

        P2PPectraBulker.PartialWithdrawal[] memory withdrawals = new P2PPectraBulker.PartialWithdrawal[](3);
        withdrawals[0] = P2PPectraBulker.PartialWithdrawal(sourcePubkey, 1);
        withdrawals[1] = P2PPectraBulker.PartialWithdrawal(sourcePubkey, 1);
        withdrawals[2] = P2PPectraBulker.PartialWithdrawal(sourcePubkey, 1);

        p2pPectraBulker.bulkPartialWithdaw{value: 1 ether}(withdrawals);

        vm.stopPrank();
    }

    function test_BulkPartialWithdraw__CallingRequestFailed() public {
        vm.startPrank(client);

        P2PPectraBulker.PartialWithdrawal[] memory withdrawals = new P2PPectraBulker.PartialWithdrawal[](3);
        withdrawals[0] = P2PPectraBulker.PartialWithdrawal(sourcePubkey, 1);
        withdrawals[1] = P2PPectraBulker.PartialWithdrawal(sourcePubkey, 1);
        withdrawals[2] = P2PPectraBulker.PartialWithdrawal(sourcePubkey, 1);
    
        vm.expectRevert(P2PPectraBulker__CallingPartialWithdrawalRequestFailed.selector);
        p2pPectraBulker.bulkPartialWithdaw(withdrawals);

        vm.stopPrank();
    }

    function test_BulkPartialWithdraw__CheckingBalanceRefund() public {
        vm.startPrank(client);

        P2PPectraBulker.PartialWithdrawal[] memory withdrawals = new P2PPectraBulker.PartialWithdrawal[](3);
        withdrawals[0] = P2PPectraBulker.PartialWithdrawal(sourcePubkey, 1);
        withdrawals[1] = P2PPectraBulker.PartialWithdrawal(sourcePubkey, 1);
        withdrawals[2] = P2PPectraBulker.PartialWithdrawal(sourcePubkey, 1);

        uint256 balanceBefore = client.balance;
        p2pPectraBulker.bulkPartialWithdaw{value: 1 ether}(withdrawals);
        uint256 balanceAfter = client.balance;

        assertEq(balanceBefore - balanceAfter, 9);

        vm.stopPrank();
    }

    function test_BulkPartialWithdraw__InvalidPubkeyLength() public {
        vm.startPrank(client);

        P2PPectraBulker.PartialWithdrawal[] memory withdrawals = new P2PPectraBulker.PartialWithdrawal[](3);
        bytes memory invalidPubkey = hex"b07f6b42a68fdc12f41b0c1984fcee63c465f72335";
        bytes memory expectedError = abi.encodeWithSelector(
            P2PPectraBulker__InvalidPubkeyLength.selector,
            "pubkey",
            invalidPubkey
        );

        withdrawals[0] = P2PPectraBulker.PartialWithdrawal(invalidPubkey, 1);
        withdrawals[1] = P2PPectraBulker.PartialWithdrawal(sourcePubkey, 1);
        withdrawals[2] = P2PPectraBulker.PartialWithdrawal(sourcePubkey, 1);

        vm.expectRevert(expectedError);
        p2pPectraBulker.bulkPartialWithdaw{value: 1 ether}(withdrawals);

        vm.stopPrank();
    }

    function test_BulkPartialWithdraw__InvalidWithdrawalListLength() public {
        vm.startPrank(client);

        P2PPectraBulker.PartialWithdrawal[] memory invalidWithdrawals;
        
        vm.expectRevert(P2PPectraBulker__WithdrawalListIsEmpty.selector);
        p2pPectraBulker.bulkPartialWithdaw{value: 1 ether}(invalidWithdrawals);

        vm.stopPrank();
    }
}
