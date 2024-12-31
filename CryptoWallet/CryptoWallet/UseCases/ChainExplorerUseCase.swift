// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine
import Foundation

protocol ChainExplorerUseCase {
    func retrieveExplorerURL(from txHash: String) -> AnyPublisher<URL, Error>
}

final class ChainExplorerImp: ChainExplorerUseCase {
    
    private let walletManager: HDWalletManager
    
    init(walletManager: HDWalletManager = .shared) {
        self.walletManager = walletManager
    }
    
    func retrieveExplorerURL(from txHash: String) -> AnyPublisher<URL, Error> {
        guard let url: URL = .init(string: walletManager.selectedNetwork.explorer + txHash) else {
            return Fail(error: ChainExplorerError.unableToMakeURL).eraseToAnyPublisher()
        }
        return Just(url).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}

// MARK: - Private
private enum ChainExplorerError: Error {
    case unableToMakeURL
}
