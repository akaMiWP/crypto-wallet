// Copyright © 2567 BE akaMiWP. All rights reserved.

import Foundation

extension NumberFormatter {
    
    static var tokenBalanceFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        return formatter
    }
}

extension Double {
    func format(with formatter: NumberFormatter) -> String {
        guard let string = formatter.string(from: .init(value: self)) else { return "" }
        return string
    }
}
