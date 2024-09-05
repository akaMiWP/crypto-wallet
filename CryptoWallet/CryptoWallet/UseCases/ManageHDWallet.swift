// Copyright © 2567 BE akaMiWP. All rights reserved.

import Foundation
import WalletCore

protocol ManageHDWallet {
    func createHDWallet(strength: Int32) throws -> String
}

final class ManageHDWalletUsecase: ManageHDWallet {
    func createHDWallet(strength: Int32) throws -> String {
        guard let wallet = HDWallet(strength: strength, passphrase: "") else {
            throw ManageHDWalletUsecaseError.unableToCreateHDWallet
        }
        return wallet.mnemonic
    }
}

// MARK: - Private
private enum ManageHDWalletUsecaseError: Error, LocalizedError {
    case unableToCreateHDWallet
    
    var errorDescription: String? {
        return "Please try again"
    }
}
