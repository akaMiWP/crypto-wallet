// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine

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
    
    func createNewWallet() {}
    
    func selectWallet(wallet: WalletViewModel) {
        
    }
}
