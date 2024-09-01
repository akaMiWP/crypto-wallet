// Copyright © 2567 BE akaMiWP. All rights reserved.

import Foundation

struct TokenViewModel: Identifiable {
    let id: UUID = .init()
    let name: String
    let balance: String
    let totalAmount: String
}
