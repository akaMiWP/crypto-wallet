// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

@main
struct CryptoWalletApp: App {
    @State private var navigationPath: NavigationPath = .init()
    
    var body: some Scene {
        WindowGroup {
            WelcomeView(navigationPath: $navigationPath)
        }
    }
}
