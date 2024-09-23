// Copyright © 2567 BE akaMiWP. All rights reserved.

import WalletCore

final class HDWalletManager {
    
    static let shared: HDWalletManager = .init()
    private var hdWallet: HDWallet?
    
    var createdWalletModels: [WalletModel] = []
    var orderOfSelectedWallet: Int = 0
    
    private init() {
        loadCreatedWallets()
        loadOrderOfSelectedWallet()
    }
    
    func store(wallet: HDWallet) {
        self.hdWallet = wallet
    }
    
    func retrieveWallet() -> HDWallet? {
        hdWallet
    }
    
    func restoreWallet() throws -> HDWallet {
        guard let mneumonic = try KeychainManager.shared.get(String.self, for: .seedPhrase),
              let hdWallet: HDWallet = .init(mnemonic: mneumonic, passphrase: "")
        else {
            throw HDWalletManagerError.unableToRestoreWallet
        }
        store(wallet: hdWallet)
        return hdWallet
    }
    
    func encryptMnemonic(_ mneumonic: String) throws {
        try KeychainManager.shared.set(mneumonic, for: .seedPhrase)
    }
    
    func saveNewWallet(wallet: WalletModel) throws {
        do {
            createdWalletModels.append(wallet)
            try KeychainManager.shared.set(createdWalletModels, for: .walletModels)
            orderOfSelectedWallet = createdWalletModels.count - 1
            try KeychainManager.shared.set(orderOfSelectedWallet, for: .orderOfSelectedWallet)
        } catch {
            throw HDWalletManagerError.unableToSaveNewWallet
        }
    }
}

// MARK: - Private
private enum HDWalletManagerError: Error {
    case unableToRestoreWallet
    case unableToLoadCreatedWallets
    case unableToSaveNewWallet
}

private extension HDWalletManager {
    func loadCreatedWallets() {
        if let walletModels = try? KeychainManager.shared.get([WalletModel].self, for: .walletModels) {
            self.createdWalletModels = walletModels
        }
    }
    
    func loadOrderOfSelectedWallet() {
        if let orderOfSelectedWallet = try? KeychainManager.shared.get(Int.self, for: .orderOfSelectedWallet) {
            self.orderOfSelectedWallet = orderOfSelectedWallet
        }
    }
}
