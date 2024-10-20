// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine

final class SettingsViewModel: ObservableObject {
    
    let rows: [SettingsRowViewModel] = [
        .init(rowType: .changeTheme),
        .init(rowType: .revealSeedPhrase),
        .init(rowType: .resetWallet)
    ]
    
    private let manageHDWalletUseCase: ManageHDWalletUseCase
    
    init(manageHDWalletUseCase: ManageHDWalletUseCase) {
        self.manageHDWalletUseCase = manageHDWalletUseCase
    }
    
    func didTapEditAccount() {}
    
    func didTapChangeTheme() {}
    
    func didTapRevealSeedPhrase() {
        manageHDWalletUseCase.retrieveMneumonic()
    }
}
