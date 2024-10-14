// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct TabbarView: View {
    var body: some View {
        TabView {
            DashboardView(
                viewModel: .init(
                    nodeProviderUseCase: NodeProviderImpl(
                        networkStack: .init(),
                        networkPollingHandler: NetworkPollingHandler()
                    ),
                    manageHDWalletUseCase: ManageHDWalletImpl(),
                    manageTokensUseCase: ManageTokensImp(),
                    manageWalletsUseCase: ManageWalletsImpl(),
                    supportNetworksUseCase: SupportNetworksImp(),
                    globalEventUseCase: GlobalEventImp()
                )
            )
            .tabItem { Label("Dashboard", systemImage: "house.fill") }
            
            Text("This is a setting page")
                .tabItem { Label("Settings", systemImage: "gear") }
        }
    }
}

#Preview {
    TabbarView()
}
