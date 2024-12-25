// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

@main
struct CryptoWalletApp: App {
    @StateObject var theme: ThemeManager = .init()
    
    var body: some Scene {
        WindowGroup {
//            RootView(viewModel: .init(globalEventUseCase: GlobalEventImp(), userDefaultUseCase: UserDefaultImp()))
            EnterPassPhraseView(navigationPath: .constant(.init()), viewModel: .init())
                .environmentObject(theme)
        }
    }
}
