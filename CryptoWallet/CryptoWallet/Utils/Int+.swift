// Copyright © 2567 BE akaMiWP. All rights reserved.

extension Int {
    func toHexString() -> String {
        return "0x" + String(self, radix: 16)
    }
}
