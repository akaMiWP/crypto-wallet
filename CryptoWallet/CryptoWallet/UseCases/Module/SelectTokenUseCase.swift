// Copyright © 2567 BE akaMiWP. All rights reserved.

protocol SelectTokenUseCase {
    var selectedTokenModel: TokenModel { get }
}

final class SelectTokenImp: SelectTokenUseCase {
    
    var selectedTokenModel: TokenModel
    
    init(selectedTokenModel: TokenModel) {
        self.selectedTokenModel = selectedTokenModel
    }
}
