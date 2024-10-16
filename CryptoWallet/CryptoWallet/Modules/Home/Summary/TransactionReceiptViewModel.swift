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
}
