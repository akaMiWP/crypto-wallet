// Copyright © 2567 BE akaMiWP. All rights reserved.

import Foundation

final class GenerateSeedPhraseViewModel: ObservableObject {
    
    @Published var mnemonic: String
    
    private let manageHDWalletUseCase: ManageHDWalletUseCase
    
    init(manageHDWalletUseCase: ManageHDWalletUseCase) {
        self.manageHDWalletUseCase = manageHDWalletUseCase
    }
    
    func createSeedPhrase() {
        try manageHDWalletUseCase.createHDWallet(strength: 128)
    }
}
