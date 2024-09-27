// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine
import Foundation
import WalletCore

protocol ManageHDWalletUseCase {
    func createHDWalletPublisher(strength: Int32) -> AnyPublisher<String, Error>
    func importHDWallet(mnemonic: String) throws
    func encryptMnemonic(_ mneumonic: String) -> AnyPublisher<Void, Error>
    func deletePreviousCreatedWalletModelsIfNeeded() -> AnyPublisher<Void, Error>
    func restoreWallet() -> AnyPublisher<HDWallet, Error>
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
    
    func encryptMnemonic(_ mneumonic: String) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { promise in
            do {
                try HDWalletManager.shared.encryptMnemonic(mneumonic)
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func deletePreviousCreatedWalletModelsIfNeeded() -> AnyPublisher<Void, Error> {
        Future<Void, Error> { promise in
            do {
                try HDWalletManager.shared.removePreviousCreatedWalletModels()
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func restoreWallet() -> AnyPublisher<HDWallet, Error> {
        Future<HDWallet, Error> { promise in
            do {
                let wallet = try HDWalletManager.shared.restoreWallet()
                promise(.success(wallet))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
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

private extension ManageHDWalletUseCase {
    func buildEthAddressUsingDeriviationPath(order: Int = 0) -> String {
        "m/44\'/60\'/\(order)\'/0/0"
    }
}
