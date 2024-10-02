// Copyright © 2567 BE akaMiWP. All rights reserved.

import Foundation
import SwiftUI

struct TokenViewModel: Identifiable, Equatable {
    let id: UUID = .init()
    let name: String
    let symbol: String
    let logo: URL?
    let image: UIImage
    let balance: Double
    let totalAmount: Double //TODO: Check if this is feasible to fetch for the price on chain
    let redactedReason: RedactionReasons
    
    init(
        name: String,
        symbol: String,
        logo: URL? = nil,
        image: UIImage = .init(),
        balance: Double,
        totalAmount: Double,
        redactedReason: RedactionReasons = []
    ) {
        self.name = name
        self.symbol = symbol
        self.logo = logo
        self.image = image
        self.balance = balance
        self.totalAmount = totalAmount
        self.redactedReason = redactedReason
    }
    
    var formattedTotalAmount: String {
        totalAmount.format(with: .tokenBalanceFormatter)
    }
}

extension TokenViewModel {
    static var placeholders: [TokenViewModel] {
        [.init(name: "------------", symbol: "", balance: 1000, totalAmount: 0, redactedReason: .placeholder),
         .init(name: "-------", symbol: "", balance: 10, totalAmount: 0, redactedReason: .placeholder),
         .init(name: "--------------", symbol: "", balance: 10, totalAmount: 0, redactedReason: .placeholder),
         .init(name: "-----------", symbol: "", balance: 100, totalAmount: 0, redactedReason: .placeholder),
         .init(name: "-----", symbol: "", balance: 1000, totalAmount: 0, redactedReason: .placeholder)]
    }
}
