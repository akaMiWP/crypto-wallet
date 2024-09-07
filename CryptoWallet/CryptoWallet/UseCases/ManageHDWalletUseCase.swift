// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine
import Foundation
import WalletCore

protocol ManageHDWalletUseCase {
    func createHDWalletPublisher(strength: Int32) -> AnyPublisher<String, Error>
    func importHDWallet(mnemonic: String) throws
}

final class ManageHDWalletImpl: ManageHDWalletUseCase {
    func createHDWalletPublisher(strength: Int32) -> AnyPublisher<String, Error> {
        Future { promise in
            do {
                guard let wallet = HDWallet(strength: strength, passphrase: "") else {
                    throw ManageHDWalletUsecaseError.unableToCreateHDWallet
                }
                HDWalletManager.shared.store(wallet: wallet)
                promise(.success(wallet.mnemonic))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func importHDWallet(mnemonic: String) throws {
        guard let wallet = HDWallet(mnemonic: mnemonic, passphrase: "") else {
            throw ManageHDWalletUsecaseError.unableToImportHDWallet
        }
        HDWalletManager.shared.store(wallet: wallet)
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
