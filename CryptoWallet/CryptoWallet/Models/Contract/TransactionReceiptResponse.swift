// Copyright © 2567 BE akaMiWP. All rights reserved.

struct TransactionReceiptResponse: Decodable {
    let blockHash: String // "0x9f...ab"
    let blockNumber: String // "0x5daf3b"
    let transactionHash: String // "0xYourTransactionHash"
    let transactionIndex: String // "0x1"
    let from: String // "0xSenderAddress"
    let to: String // "0xRecipientAddress"
    let gasUsed: String // "0x5208"
    let cumulativeGasUsed: String // "0x33bc"
    let contractAddress: String? // Non-null if contract was created
    let status: String // "0x1", 1 = success, 0 = failure
    // "logs": []
}
