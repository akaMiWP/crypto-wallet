// Copyright © 2567 BE akaMiWP. All rights reserved.

import WalletCore

final class HDWalletManager {
    
    static let shared: HDWalletManager = .init()
    private var hdWallet: HDWallet?
    
    private init() {}
    
    func store(wallet: HDWallet) {
        self.hdWallet = wallet
    }
    
    func retrieveWallet() -> HDWallet? {
        hdWallet
    }
}
