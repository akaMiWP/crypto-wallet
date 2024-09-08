// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct RootView: View {
    
    @ObservedObject private var viewModel: RootViewModel
    @State private var navigationPath: NavigationPath = .init()
    
    init(viewModel: RootViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        if viewModel.isSignedIn {
            DashboardView()
        } else {
            WelcomeView(navigationPath: $navigationPath)
                .onAppear {
                    viewModel.listenToSignInEvent()
                }
        }
    }
}

#Preview {
    RootView(viewModel: .init(globalEventUseCase: GlobalEventImp(), userDefaultUseCase: UserDefaultImp()))
}
