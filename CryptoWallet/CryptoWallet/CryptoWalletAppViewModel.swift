// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine

final class CryptoWalletAppViewModel: ObservableObject {
    
    private let userDefaultUseCase: UserDefaultUseCase
    
    init(userDefaultUseCase: UserDefaultUseCase) {
        self.userDefaultUseCase = userDefaultUseCase
    }
    
    func hasCreatedWallet() -> Bool {
        userDefaultUseCase.hasCreatedWallet
    }
}
