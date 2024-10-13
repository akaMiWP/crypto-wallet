// Copyright © 2567 BE akaMiWP. All rights reserved.

import Foundation

extension TokenModel {
    func toViewModel() -> TokenViewModel {
        .init(
            address: smartContractAddress,
            name: name,
            symbol: symbol,
            image: symbol == SymbolsConstants.ethereum ? .iconEthereum : .init(),
            balance: tokenBalance,
            totalAmount: 0
        )
    }
}

extension Array where Element == TokenModel {
    func toViewModels() -> [TokenViewModel] {
        map { $0.toViewModel() }
    }
}
