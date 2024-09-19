// Copyright © 2567 BE akaMiWP. All rights reserved.

extension String {
    func maskedWalletAddress() -> String {
        let frontRange = startIndex..<index(startIndex, offsetBy: 5)
        let backRange = index(endIndex, offsetBy: -4)..<endIndex
        return self[frontRange] + "...." + self[backRange]
    }
}
