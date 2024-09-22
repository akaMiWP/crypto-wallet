// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine
import WalletCore

protocol ManageWalletsUseCase {
    func loadWalletsPublisher() ->  AnyPublisher<[WalletModel], Error>
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
    func getWalletAddressUsingDerivationPath(
        wallet: HDWallet,
        coinType: CoinType,
        order: Int
    ) -> String {
        let deriviationPath = buildEthAddressUsingDeriviationPath(order: order)
        let privateKey = wallet.getKey(coin: coinType, derivationPath: deriviationPath)
        let walletAddress = coinType.deriveAddress(privateKey: privateKey)
        return walletAddress
    }
    
    func saveNewWallet(wallet: WalletModel) throws {
        try HDWalletManager.shared.saveNewWallet(wallet: wallet)
    }
    
    func buildEthAddressUsingDeriviationPath(order: Int = 0) -> String {
        "m/44\'/60\'/\(order)\'/0/0"
    }
}

private enum ManageWalletsUseCaseError: Error {
    case unableToRetrieveWallet
    case unableToSelectWallet
    case corruptedWalletModels
}
