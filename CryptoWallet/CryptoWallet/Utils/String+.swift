// Copyright © 2567 BE akaMiWP. All rights reserved.

extension String {
    func maskedWalletAddress() -> String {
        let frontRange = startIndex..<index(startIndex, offsetBy: 7)
        let backRange = index(endIndex, offsetBy: -5)..<endIndex
        return self[frontRange] + "...." + self[backRange]
    }
    
    func toDouble() -> Double {
        Double(self) ?? 0
    }
    
    func toHexadecimalString() -> String {
        String(format: "%02x", self)
    }
    
    func fullByteHexString() -> String {
        let droppedHexPrefixString = hasPrefix("0x") ? String(dropFirst(2)) : self
        let fullByteHexString = droppedHexPrefixString.count % 2 == 0
        ? droppedHexPrefixString
        : "0" + droppedHexPrefixString
        return fullByteHexString
    }
}
