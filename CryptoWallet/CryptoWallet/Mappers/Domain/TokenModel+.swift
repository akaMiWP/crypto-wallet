// Copyright © 2567 BE akaMiWP. All rights reserved.

import Foundation

extension Array where Element == TokenModel {
    func toViewModels() -> [TokenViewModel] {
        map { model in
                .init(
                    name: model.name,
                    symbol: model.symbol,
                    image: model.symbol == SymbolsConstants.ethereum ? .iconEthereum : .init(),
                    balance: model.tokenBalance,
                    totalAmount: 0
                )
        }
    }
}
