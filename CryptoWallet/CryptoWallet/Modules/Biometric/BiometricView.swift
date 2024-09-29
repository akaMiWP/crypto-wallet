// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct BiometricView: View {
    @StateObject private var viewModel: BiometricViewModel = .init()
    @Binding var navigationPath: NavigationPath
    
    enum Destinations {
        case dashboard
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            Color.primaryViolet2_400
                .ignoresSafeArea(edges: .vertical)
                .onChange(of: viewModel.isPolicyEvaluated, { _, newValue in
                    if newValue {
                        navigationPath.append(Destinations.dashboard)
                    }
                })
                .onAppear { viewModel.authenticate() }
                .navigationDestination(for: Destinations.self) {
                    switch $0 {
                    case .dashboard:
                        DashboardView(
                            viewModel: .init(
                                nodeProviderUseCase: NodeProviderImpl(networkStack: .init()),
                                manageHDWalletUseCase: ManageHDWalletImpl(),
                                manageWalletsUseCase: ManageWalletsImpl(),
                                globalEventUseCase: GlobalEventImp()
                            )
                        )
                    }
                }
        }
    }
}

#Preview {
    BiometricView(navigationPath: .constant(.init()))
}
