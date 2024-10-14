// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine
import WalletCore

protocol ManageWalletsUseCase: DerivationPathRetriever {
    func getSelectedWalletAddressPublisher() -> AnyPublisher<String, Error>
    func loadWalletsPublisher() ->  AnyPublisher<[WalletModel], Error>
    func loadSelectedWalletPublisher() -> AnyPublisher<WalletModel, Error>
    func makeNewWalletModel(coinType: CoinType) -> AnyPublisher<Void, Error>
    func selectWallet(wallet: WalletModel) -> AnyPublisher<Void, Error>
}

final class ManageWalletsImpl: ManageWalletsUseCase {
    
    func loadWalletsPublisher() -> AnyPublisher<[WalletModel], Error> {
        Just(HDWalletManager.shared.createdWalletModels)
            .tryMap { models in
                guard models.count > 0 else { throw ManageWalletsUseCaseError.corruptedWalletModels }
                return models
            }
            .eraseToAnyPublisher()
    }
    
    func loadSelectedWalletPublisher() -> AnyPublisher<WalletModel, Error> {
        loadWalletsPublisher()
            .tryMap { models in
                if HDWalletManager.shared.orderOfSelectedWallet < HDWalletManager.shared.createdWalletModels.count {
                    let model = models[HDWalletManager.shared.orderOfSelectedWallet]
                    return model
                } else if let model = models.first {
                    return model
                } else {
                    throw ManageWalletsUseCaseError.unableToLoadSelectedWallet
                }
            }
            .eraseToAnyPublisher()
    }
    
    func makeNewWalletModel(coinType: CoinType) -> AnyPublisher<Void, Error> {
        do {
            guard let hdWallet = HDWalletManager.shared.retrieveWallet() else {
                throw ManageWalletsUseCaseError.unableToRetrieveWallet
            }
            let newWalletIndex = HDWalletManager.shared.createdWalletModels.count
            let address = getWalletAddressUsingDerivationPath(wallet: hdWallet, coinType: coinType, order: newWalletIndex)
            let wallet: WalletModel = .init(name: "Account #\(newWalletIndex + 1)", address: address)
            try saveNewWallet(wallet: wallet)
            return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    func getSelectedWalletAddressPublisher() -> AnyPublisher<String, Error> {
        do {
            let selectedWallet = try HDWalletManager.shared.retrieveSelectedWallet()
            return Just(selectedWallet.address).setFailureType(to: Error.self).eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    func selectWallet(wallet: WalletModel) -> AnyPublisher<Void, Error> {
        do {
            guard let selectedWalletIndex = HDWalletManager.shared.createdWalletModels.firstIndex(of: wallet) else {
                throw ManageWalletsUseCaseError.unableToSelectWallet
            }
            HDWalletManager.shared.orderOfSelectedWallet = selectedWalletIndex
            return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
}

// MARK: - Private

private extension ManageWalletsImpl {
    func saveNewWallet(wallet: WalletModel) throws {
        try HDWalletManager.shared.saveNewWallet(wallet: wallet)
    }
}

private enum ManageWalletsUseCaseError: Error {
    case unableToRetrieveWallet
    case unableToSelectWallet
    case unableToLoadSelectedWallet
    case corruptedWalletModels
}
