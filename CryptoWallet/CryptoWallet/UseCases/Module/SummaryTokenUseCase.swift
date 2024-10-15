// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine
import Foundation

protocol SummaryTokenUseCase {
    var destinationAddress: String { get }
    var sendAmount: Double { get }
    var tokenModel: TokenModel { get }
    
    func isNativeTokenPublisher() -> AnyPublisher<Bool, Never>
}

final class SummaryTokenImp: SummaryTokenUseCase {
    
    var destinationAddress: String
    var sendAmount: Double
    var tokenModel: TokenModel
    
    init(destinationAddress: String, sendAmount: Double, tokenModel: TokenModel) {
        self.destinationAddress = destinationAddress
        self.sendAmount = sendAmount
        self.tokenModel = tokenModel
    }
    
    func isNativeTokenPublisher() -> AnyPublisher<Bool, Never> {
        Just(tokenModel.isNativeToken).eraseToAnyPublisher()
    }
}
