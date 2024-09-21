// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine
import Foundation

struct WalletViewModel: Equatable {
    let name: String
    let address: String
    let isSelected: Bool
}

final class SwitchAccountViewModel: ObservableObject {
    
    let wallets: [WalletViewModel] = [
        .init(name: "Account #1", address: "0x12345678", isSelected: true),
        .init(name: "Account #2", address: "0x22345678", isSelected: false),
        .init(name: "Account #3", address: "0x32345678", isSelected: false)
    ]
    
    private let mangageHDWalletUseCase: ManageHDWalletUseCase
    
    init(mangageHDWalletUseCase: ManageHDWalletUseCase) {
        self.mangageHDWalletUseCase = mangageHDWalletUseCase
    }
    
    func createNewWallet() {
        mangageHDWalletUseCase.createNewWallet()
        NotificationCenter.default.post(name: .init("accountChanged"), object: nil)
    }
    
    func selectWallet(wallet: WalletViewModel) {
        NotificationCenter.default.post(name: .init("accountChanged"), object: nil)
    }
}
