// SPDX-FileCopyrightText: 2025 P2P Validator <info@p2p.org>
// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

error P2PPectraBulker__ReadingFeeFailed();
error P2PPectraBulker__TransferToSenderFailed();
error P2PPectraBulker__CallingConsolidationRequestFailed();
error P2PPectraBulker__TooSmallMessageValue();
error P2PPectraBulker__CallingPartialWithdrawalRequestFailed();
error P2PPectraBulker__InvalidPubkeyLength(string placeholder, bytes pubkey);
error P2PPectraBulker__WithdrawalListIsEmpty();
error P2PPectraBulker__SourcePubkeyListIsEmpty();

contract P2PPectraBulker {
    address private constant ConsolidationContract = 0x0000BBdDc7CE488642fb579F8B00f3a590007251;
    address private constant PartialWithdrawalContract = 0x00000961Ef480Eb55e80D19ad83579A64c007002;

    uint256 private constant FEE_GAP = 2;

    struct PartialWithdrawal {
        bytes pubkey;
        uint64 amount;
    }

    function consolidateValidators(bytes calldata sourcePubkey, bytes calldata targetPubkey) external payable {        
        require(sourcePubkey.length == 48, P2PPectraBulker__InvalidPubkeyLength("sourcePubkey", sourcePubkey));
        require(targetPubkey.length == 48, P2PPectraBulker__InvalidPubkeyLength("targetPubkey", targetPubkey));

        uint256 consolidationFee = getConsolidationFee();
        uint256 fee = consolidationFee + FEE_GAP;

        require(msg.value >= fee, P2PPectraBulker__TooSmallMessageValue());

        bytes memory callData = abi.encodePacked(sourcePubkey, targetPubkey);
        (bool writeOK,) = ConsolidationContract.call{value: fee}(callData);
        require(writeOK, P2PPectraBulker__CallingConsolidationRequestFailed());

        _refund(fee);
    }

    function bulkConsolidateValidators(bytes[] calldata sourcePubkeyList, bytes calldata targetPubkey) external payable {
        require(targetPubkey.length == 48, P2PPectraBulker__InvalidPubkeyLength("targetPubkey", targetPubkey));
        require(sourcePubkeyList.length > 0, P2PPectraBulker__SourcePubkeyListIsEmpty());

        uint256 consolidationFee = getConsolidationFee();
        uint256 totalFee = (consolidationFee + FEE_GAP) * sourcePubkeyList.length;

        require(msg.value >= totalFee, P2PPectraBulker__TooSmallMessageValue());

        for (uint256 i = 0; i < sourcePubkeyList.length; i++) {
            require(sourcePubkeyList[i].length == 48, P2PPectraBulker__InvalidPubkeyLength("sourcePubkey", sourcePubkeyList[i]));

            bytes memory callData = abi.encodePacked(sourcePubkeyList[i], targetPubkey);
            (bool writeOK,) = ConsolidationContract.call{value: totalFee}(callData);
            require(writeOK, P2PPectraBulker__CallingConsolidationRequestFailed());
        }

        _refund(totalFee);
    }

    function partialWithdraw(bytes calldata pubkey, uint64 amount) external payable {
        require(pubkey.length == 48, P2PPectraBulker__InvalidPubkeyLength("pubkey", pubkey));

        uint256 partialWithdrawalFee = getPartialWithdrawalFee();
        uint256 fee = partialWithdrawalFee + FEE_GAP;

        require(msg.value >= fee, P2PPectraBulker__TooSmallMessageValue());

        bytes memory callData = abi.encodePacked(pubkey, amount);
        (bool writeOK,) = PartialWithdrawalContract.call{value: fee}(callData);
        require(writeOK, P2PPectraBulker__CallingPartialWithdrawalRequestFailed());

        _refund(fee);
    }

    function bulkPartialWithdaw(PartialWithdrawal[] calldata withdrawals) external payable {
        require(withdrawals.length > 0, P2PPectraBulker__WithdrawalListIsEmpty());

        uint256 partialWithdrawalFee = getPartialWithdrawalFee();
        uint256 totalFee = (partialWithdrawalFee + FEE_GAP) * withdrawals.length;

        require(msg.value >= totalFee, P2PPectraBulker__TooSmallMessageValue());

        for (uint256 i = 0; i < withdrawals.length; i++) {
            require(withdrawals[i].pubkey.length == 48, P2PPectraBulker__InvalidPubkeyLength("pubkey", withdrawals[i].pubkey));
            bytes memory callData = abi.encodePacked(withdrawals[i].pubkey, withdrawals[i].amount);
            (bool writeOK,) = PartialWithdrawalContract.call{value: totalFee}(callData);
            require(writeOK, P2PPectraBulker__CallingPartialWithdrawalRequestFailed());
        }

        _refund(totalFee);
    }

    function getConsolidationFee() public view returns (uint256 consolidationFee) {
        (bool ok, bytes memory feeData) = ConsolidationContract.staticcall('');
        require(ok, P2PPectraBulker__ReadingFeeFailed());
        consolidationFee = uint256(bytes32(feeData));
    }

    function getPartialWithdrawalFee() public view returns (uint256 partialWithdrawalFee) {
        (bool ok, bytes memory feeData) = PartialWithdrawalContract.staticcall('');
        require(ok, P2PPectraBulker__ReadingFeeFailed());
        partialWithdrawalFee = uint256(bytes32(feeData));
    }

    function _refund(uint256 fee) private {
        if (msg.value > fee) {
            (bool ok, ) = msg.sender.call{value: msg.value - fee}("");
            require(ok, P2PPectraBulker__TransferToSenderFailed());
        }
    }
}
