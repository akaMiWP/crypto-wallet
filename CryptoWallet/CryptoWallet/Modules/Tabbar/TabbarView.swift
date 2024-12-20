// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct TabbarView: View {
    @ObservedObject var viewModel: TabbarViewModel
    @EnvironmentObject var theme: ThemeManager
    
    @State private var selectedItem: SelectedItem = .home
    
    enum SelectedItem {
        case home, settings
    }
    
    var body: some View {
        VStack(spacing: 0) {
            switch selectedItem {
            case .home:
                DashboardView(viewModel: viewModel.dashboardViewModel)
                    .tabItem { Label("Dashboard", systemImage: "house.fill") }
            case .settings:
                SettingsView(viewModel: viewModel.settingsViewModel)
                    .tabItem { Label("Settings", systemImage: "gear") }
            }
            
            HStack {
                GeometryReader { proxy in
                    if selectedItem == .home {
                        RoundedRectangle(cornerSize: .init(width: 16, height: 16))
                            .fill(itemColor)
                            .frame(width: proxy.size.width * 0.7, height: 2)
                            .position(x: proxy.size.width / 2)
                    }
                    
                    VStack(spacing: 2) {
                        Image(selectedItem.homeImage)
                            .renderingMode(.template)
                            .foregroundColor(itemColor)
                        
                        Text("Dashboard")
                            .foregroundColor(itemColor)
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity)
                    .position(x: proxy.size.width / 2, y: proxy.size.height / 2)
                    .onTapGesture {
                        selectedItem = .home
                    }
                }
                
                GeometryReader { proxy in
                    if selectedItem == .settings {
                        RoundedRectangle(cornerSize: .init(width: 16, height: 16))
                            .fill(itemColor)
                            .frame(width: proxy.size.width * 0.7, height: 2)
                            .position(x: proxy.size.width / 2)
                    }
                    
                    VStack(spacing: 2) {
                        Image(selectedItem.settingsImage)
                            .renderingMode(.template)
                            .foregroundColor(itemColor)
                        Text("Settings")
                            .foregroundColor(itemColor)
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity)
                    .position(x: proxy.size.width / 2, y: proxy.size.height / 2)
                    .onTapGesture {
                        selectedItem = .settings
                    }
                }
            }
            .frame(height: 70)
            .background(backgroundColor)
            .animation(.easeIn, value: selectedItem)
        }
    }
}

private extension TabbarView {
    var backgroundColor: Color {
        theme.currentTheme == .light ? .white : .primaryViolet1_800
    }
    
    var itemColor: Color {
        theme.currentTheme == .light ? .primaryViolet1_400 : .primaryViolet1_50
    }
}

private extension TabbarView.SelectedItem {
    var homeImage: ImageResource {
        switch self {
        case .home: return .iconHomeSelected
        case .settings: return .iconHomeUnselected
        }
    }
    
    var settingsImage: ImageResource {
        switch self {
        case .home: return .iconSettingsUnselected
        case .settings: return .iconSettingsSelected
        }
    }
}

#Preview {
    let themeManager: ThemeManager = .init()
    themeManager.currentTheme = .dark
    return TabbarView(viewModel: .init())
        .environmentObject(themeManager)
}
