// Copyright © 2567 BE akaMiWP. All rights reserved.

import BigInt
import Foundation

func convertHexToDouble(hexString: String, decimals: Int = 18) -> Double? {
    let hexValue = hexString.replacingOccurrences(of: "0x", with: "")
    guard let bigUIntValue = BigUInt(hexValue, radix: 16) else { return nil }
    let decimalFactor = pow(10, Double(decimals))
    let balanceInDouble = Double(bigUIntValue) / decimalFactor
    return balanceInDouble
}
