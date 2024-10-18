// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine

final class TabbarViewModel: ObservableObject {
    
    var dashboardViewModel: DashboardViewModel
    
    init() {
        dashboardViewModel = .init(
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
    }
}
