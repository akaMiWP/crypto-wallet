// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

@main
struct CryptoWalletApp: App {
    
    var body: some Scene {
        WindowGroup {
            RootView(viewModel: .init(globalEventUseCase: GlobalEventImp(), userDefaultUseCase: UserDefaultImp()))
        }
    }
}
