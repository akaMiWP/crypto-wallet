// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

enum SettingsRowType {
    case changeTheme
    case resetWallet
    case revealSeedPhrase
    
    var title: String {
        switch self {
        case .changeTheme: return "Change Theme"
        case .resetWallet: return "Reset Wallet"
        case .revealSeedPhrase: return "Reveal Seed Phrase"
        }
    }
    
    var iconName: UIImage? {
        switch self {
        case .changeTheme: return .iconMoon
        case .resetWallet: return .iconArrowRotate
        case .revealSeedPhrase: return .iconPassword
        }
    }
}
