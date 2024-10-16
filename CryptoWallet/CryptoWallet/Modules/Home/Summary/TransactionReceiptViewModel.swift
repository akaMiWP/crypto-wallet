// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine
import Foundation

final class TransactionReceiptViewModel: ObservableObject {
    enum ReceiptViewState: Equatable {
        case initiatingTransaction
        case processingTransaction
        case confirmedTransaction(txHash: String)
    }
    
    @Published var viewState: ReceiptViewState = .initiatingTransaction
    
    func buildURL() -> URL? {
        guard let txHash = viewState.txHash else { return nil }
        //TODO: Implement domain logic to handle etherscan links based on chain
        return .init(string: "https://sepolia.etherscan.io/tx/\(txHash)")
    }
}

// MARK: - Private
private extension TransactionReceiptViewModel.ReceiptViewState {
    var txHash: String? {
        switch self {
        case .initiatingTransaction, .processingTransaction: return nil
        case .confirmedTransaction(let txHash): return txHash
        }
    }
}
