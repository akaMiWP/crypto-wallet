// Copyright © 2567 BE akaMiWP. All rights reserved.

import Foundation

func convertEtherToGwei(ether: String) -> String {
    let gweiUnit = NSDecimalNumber(decimal: pow(10, 9)).doubleValue
    let gasPrice = ether.toDouble() * gweiUnit
    return gasPrice.format(with: .gasFormatter)
}

func convertEtherToWei(ether: String) -> String {
    let gweiUnit = NSDecimalNumber(decimal: pow(10, 18)).doubleValue
    let gasPrice = ether.toDouble() * gweiUnit
    return gasPrice.format(with: .gasFormatter)
}
