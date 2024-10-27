// Copyright © 2567 BE akaMiWP. All rights reserved.

import WalletCore

final class HDWalletManager {
    
    static let shared: HDWalletManager = .init()
    lazy var selectedNetwork: SupportedNetwork = {
        (try? KeychainManager.shared.get(SupportedNetwork.self, for: .selectedNetwork)) ?? .mainnet(.ethereum)
    }()
    lazy var createdWalletModels: [WalletModel] = {
        (try? KeychainManager.shared.get([WalletModel].self, for: .walletModels)) ?? []
    }()
    lazy var orderOfSelectedWallet: Int = {
        (try? KeychainManager.shared.get(Int.self, for: .orderOfSelectedWallet)) ?? 0
    }()
    
    private var hdWallet: HDWallet?
    
    private init() {}
    
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
    
    func removePreviousCreatedWalletModels() throws {
        try KeychainManager.shared.delete(key: .walletModels)
        createdWalletModels = []
        orderOfSelectedWallet = 0
    }
    
    func select(network: SupportedNetwork) {
        try? KeychainManager.shared.set(network, for: .selectedNetwork)
        selectedNetwork = network
    }
    
    func saveNewWallet(wallet: WalletModel) throws {
        do {
            createdWalletModels.append(wallet)
            try KeychainManager.shared.set(createdWalletModels, for: .walletModels)
            try selectWalletAndSaveOrderInStorage(order: createdWalletModels.count - 1)
        } catch {
            throw HDWalletManagerError.unableToSaveNewWallet
        }
    }
    
    func selectWallet(order: Int) throws {
        do {
            try selectWalletAndSaveOrderInStorage(order: order)
        } catch {
            throw HDWalletManagerError.unableToSaveWalletSelection
        }
    }
    
    func retrieveSelectedWallet() throws -> WalletModel {
        guard createdWalletModels.count > orderOfSelectedWallet else {
            throw HDWalletManagerError.unableToRetrieveSelectedWallet
        }
        return createdWalletModels[orderOfSelectedWallet]
    }
    
    func retrieveMneumonic() throws -> String {
        guard let mnemonic = hdWallet?.mnemonic else {
            throw HDWalletManagerError.unableToRetrieveMneumonic
        }
        return mnemonic
    }
}

// MARK: - Private
private extension HDWalletManager {
    func selectWalletAndSaveOrderInStorage(order: Int) throws {
        orderOfSelectedWallet = order
        try KeychainManager.shared.set(orderOfSelectedWallet, for: .orderOfSelectedWallet)
    }
}

private enum HDWalletManagerError: Error {
    case unableToRestoreWallet
    case unableToLoadCreatedWallets
    case unableToSaveNewWallet
    case unableToRetrieveSelectedWallet
    case unableToRetrieveMneumonic
    case unableToSaveWalletSelection
}
