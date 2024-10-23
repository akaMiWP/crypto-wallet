// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct TabbarView: View {
    @ObservedObject var viewModel: TabbarViewModel
    
    var body: some View {
        TabView {
            DashboardView(viewModel: viewModel.dashboardViewModel)
                .tabItem { Label("Dashboard", systemImage: "house.fill") }
                .padding(.bottom, 4)
            
            SettingsView(viewModel: viewModel.settingsViewModel)
                .tabItem { Label("Settings", systemImage: "gear") }
                .padding(.bottom)
        }
    }
}

#Preview {
    TabbarView(viewModel: .init())
}
