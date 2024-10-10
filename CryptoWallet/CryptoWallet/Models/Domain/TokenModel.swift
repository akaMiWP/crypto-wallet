// Copyright © 2567 BE akaMiWP. All rights reserved.

import Foundation

struct TokenModel {
    let name: String
    let symbol: String
    let address: String?
    let logo: URL?
    let isNativeToken: Bool
    let tokenBalance: Double
    let totalAmount: Double
    
    init(
        name: String,
        symbol: String,
        address: String? = nil,
        logo: URL? = nil,
        isNativeToken: Bool = false,
        tokenBalance: Double,
        totalAmount: Double
    ) {
        self.name = name
        self.symbol = symbol
        self.address = address
        self.logo = logo
        self.isNativeToken = isNativeToken
        self.tokenBalance = tokenBalance
        self.totalAmount = totalAmount
    }
}
