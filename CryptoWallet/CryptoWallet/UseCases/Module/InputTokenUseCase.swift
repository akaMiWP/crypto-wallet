// Copyright © 2567 BE akaMiWP. All rights reserved.

protocol InputTokenUseCase {
    var tokenModel: TokenModel { get }
    var destinationAddress: String { get }
}

final class InputTokenImp: InputTokenUseCase {
    
    var tokenModel: TokenModel
    var destinationAddress: String
    
    init(tokenModel: TokenModel, destinationAddress: String) {
        self.tokenModel = tokenModel
        self.destinationAddress = destinationAddress
    }
}
