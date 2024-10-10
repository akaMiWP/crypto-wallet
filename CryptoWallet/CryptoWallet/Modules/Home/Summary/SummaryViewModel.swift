// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine

final class SummaryViewModel: ObservableObject {
    
    @Published var networkFee: Double = 0.0
    
    var destinationAddress: String { summaryTokenUseCase.destinationAddress }
    var networkName: String { summaryTokenUseCase.tokenModel.name }
    
    let sendAmountText: String
    private let summaryTokenUseCase: SummaryTokenUseCase
    
    init(summaryTokenUseCase: SummaryTokenUseCase) {
        self.summaryTokenUseCase = summaryTokenUseCase
        
        sendAmountText = summaryTokenUseCase.sendAmount.toString() + " \(summaryTokenUseCase.tokenModel.symbol)"
    }
}
