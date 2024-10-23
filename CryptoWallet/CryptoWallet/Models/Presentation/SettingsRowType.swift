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
    
    var titleColor: Color {
        switch self {
        case .changeTheme: return Color.primaryViolet1_900
        case .resetWallet: return .red
        case .revealSeedPhrase: return Color.primaryViolet1_900
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .changeTheme: return Color.primaryViolet1_50
        case .resetWallet: return .clear
        case .revealSeedPhrase: return Color.primaryViolet1_50
        }
    }
    
    var iconName: String? {
        switch self {
        case .changeTheme: return "moon.fill"
        case .resetWallet: return nil
        case .revealSeedPhrase: return "rectangle.and.pencil.and.ellipsis"
        }
    }
}
