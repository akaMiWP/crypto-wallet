// Copyright © 2567 BE akaMiWP. All rights reserved.

struct WalletViewModel: Equatable {
    let name: String
    let address: String
    let isSelected: Bool
    
    var maskedAddress: String { address.maskedHexString() }
    
    static let `default`: WalletViewModel = .init(name: "Account 0", address: "0x00000000", isSelected: false)
}
