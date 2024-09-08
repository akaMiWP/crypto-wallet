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
    
    func restoreWallet() throws -> HDWallet? {
        guard let mneumonic = try KeychainManager.shared.get(String.self, for: .seedPhrase) else { return nil }
        hdWallet = .init(mnemonic: mneumonic, passphrase: "")
        return hdWallet
    }
    
    func encryptMnemonic(_ mneumonic: String) throws {
        try KeychainManager.shared.set(mneumonic, for: .seedPhrase)
    }
}

// MARK: - Private
private enum HDWalletManagerError: Error {
    case unableToRestoreWallet
}
