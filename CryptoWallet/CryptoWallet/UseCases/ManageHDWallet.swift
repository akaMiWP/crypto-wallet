// Copyright © 2567 BE akaMiWP. All rights reserved.

import Foundation
import WalletCore

protocol ManageHDWallet {
    func createHDWallet(strength: Int32) throws -> String
    func importHDWallet(mnemonic: String) throws
}

final class ManageHDWalletUsecase: ManageHDWallet {
    func createHDWallet(strength: Int32) throws -> String {
        guard let wallet = HDWallet(strength: strength, passphrase: "") else {
            throw ManageHDWalletUsecaseError.unableToCreateHDWallet
        }
        return wallet.mnemonic
    }
    
    func importHDWallet(mnemonic: String) throws {
        guard let wallet = HDWallet(mnemonic: mnemonic, passphrase: "") else {
            throw ManageHDWalletUsecaseError.unableToImportHDWallet
        }
    }
}

// MARK: - Private
private enum ManageHDWalletUsecaseError: Error, LocalizedError {
    case unableToCreateHDWallet
    case unableToImportHDWallet
    
    var errorDescription: String? {
        switch self {
        case .unableToCreateHDWallet: return "Please try again to create the wallet"
        case .unableToImportHDWallet: return "Please try again to import the wallet"
        }
    }
}
