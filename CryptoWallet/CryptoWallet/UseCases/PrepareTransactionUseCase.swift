// Copyright © 2567 BE akaMiWP. All rights reserved.

import WalletCore

protocol PrepareTransactionUseCase {
    func validateAddress(address: String) -> Bool
}

final class PrepareTransactionImp: PrepareTransactionUseCase {
    
    private let HDWalletManager: HDWalletManager
    
    init(HDWalletManager: HDWalletManager = .shared) {
        self.HDWalletManager = HDWalletManager
    }
    
    func validateAddress(address: String) -> Bool {
        AnyAddress.isValid(string: address, coin: HDWalletManager.selectedNetwork.coinType)
    }
}
