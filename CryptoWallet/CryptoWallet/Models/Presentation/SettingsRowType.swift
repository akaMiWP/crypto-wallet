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
    
    var titleColor: Color { Color.primaryViolet1_900 }
    
    var backgroundColor: Color { Color.primaryViolet1_50 }
    
    var iconName: String? {
        switch self {
        case .changeTheme: return "moon.fill"
        case .resetWallet: return nil
        case .revealSeedPhrase: return "rectangle.and.pencil.and.ellipsis"
        }
    }
}
