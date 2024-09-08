// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

@main
struct CryptoWalletApp: App {
    @State private var navigationPath: NavigationPath = .init()
    @StateObject private var viewModel: CryptoWalletAppViewModel = .init(userDefaultUseCase: UserDefaultImp())
    
    var body: some Scene {
        WindowGroup {
            if viewModel.hasCreatedWallet() {
                DashboardView()
            } else {
                WelcomeView(navigationPath: $navigationPath)
            }
        }
    }
}
