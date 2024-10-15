// Copyright © 2567 BE akaMiWP. All rights reserved.

extension TransactionReceiptResponse {
    func toModel() -> TransactionReceiptModel {
        .init(txHash: transactionHash)
    }
}
