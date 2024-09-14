// Copyright © 2567 BE akaMiWP. All rights reserved.

import Foundation

struct TokenViewModel: Identifiable {
    let id: UUID = .init()
    let name: String
    let symbol: String
    let logo: URL?
    let balance: Double
    let totalAmount: Double //TODO: Check if this is feasible to fetch for the price on chain
    
    var formattedTotalAmount: String {
        totalAmount.format(with: .tokenBalanceFormatter)
    }
}
