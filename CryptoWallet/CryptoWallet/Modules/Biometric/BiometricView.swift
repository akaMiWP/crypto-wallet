// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct BiometricView: View {
    @StateObject private var viewModel: BiometricViewModel = .init()
    @Binding var navigationPath: NavigationPath
    
    @EnvironmentObject private var theme: ThemeManager
    
    enum Destinations {
        case dashboard
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            backgroundColor
                .ignoresSafeArea(edges: .vertical)
                .onChange(of: viewModel.isPolicyEvaluated) { newValue in
                    if newValue {
                        navigationPath.append(Destinations.dashboard)
                    }
                }
                .onAppear { viewModel.authenticate() }
                .navigationDestination(for: Destinations.self) {
                    switch $0 {
                    case .dashboard:
                        TabbarView(viewModel: .init())
                            .navigationBarHidden(true)
                    }
                }
        }
    }
}

// MARK: - Private
private extension BiometricView {
    
    var backgroundColor: Color {
        theme.currentTheme == .light ? Color.primaryViolet2_400 : Color.primaryViolet1_800
    }
}

#Preview {
    BiometricView(navigationPath: .constant(.init()))
        .environmentObject(ThemeManager())
}
