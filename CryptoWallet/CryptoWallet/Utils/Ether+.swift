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

func convertGweiToWei(gwei: String) -> String {
    let gweiUnit = NSDecimalNumber(decimal: pow(10, 9)).doubleValue
    let gasPrice = gwei.toDouble() * gweiUnit
    return gasPrice.format(with: .gasFormatter)
}

func convertEtherToHex(ether: Double) -> String? {
    let weiPerEther = NSDecimalNumber(decimal: pow(10, 18)).doubleValue
    let weiAmount = ether * weiPerEther
    guard let weiAsInt = UInt64(exactly: weiAmount) else { return nil }
    return String(weiAsInt, radix: 16)
}
