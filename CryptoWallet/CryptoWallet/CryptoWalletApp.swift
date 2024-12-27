// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

@main
struct CryptoWalletApp: App {
    @StateObject var theme: ThemeManager = .init()
    private let container: DIContainer = .init()
    
    init() {
        container.register(PasswordRepository.self) { PasswordRepositoryImp() }
    }
    
    var body: some Scene {
        WindowGroup {
            RootView(viewModel: .init(globalEventUseCase: GlobalEventImp(), userDefaultUseCase: UserDefaultImp()))
                .environmentObject(theme)
                .environment(\.container, container)
        }
    }
}
