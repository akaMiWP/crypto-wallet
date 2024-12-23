// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct CongratsView: View {
    @ObservedObject private var viewModel: CongratsViewModel
    @EnvironmentObject private var theme: ThemeManager
    
    private var navigationPath: Binding<NavigationPath>
    
    init(viewModel: CongratsViewModel, navigationPath: Binding<NavigationPath>) {
        self.viewModel = viewModel
        self.navigationPath = navigationPath
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ProgressBarView(totalSteps: 3, currentIndex: 2)
            .padding(.top, 24)
            
            Spacer()
            
            Image(.imageRocket)
            
            Text("You're all done!")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(foregroundColor)
                .padding(.top, 16)
            
            Text("You can now fully enjoy your wallet")
                .font(.callout)
                .foregroundColor(foregroundColor)
                .padding(.top, 8)
            
            Spacer()
            
            PrimaryButton(title: "Get Started") {
                navigationPath.wrappedValue = .init()
                viewModel.didTapButton()
            }
            .dropShadow()
            
            Spacer()
        }
        .padding(.horizontal, 36)
        .background(backgroundColor)
        .cardStyle()
    }
}

// MARK: - Private
private extension CongratsView {
    var backgroundColor: Color {
        theme.currentTheme == .light ? .neutral_10 : .primaryViolet1_800
    }
    
    var foregroundColor: Color {
        theme.currentTheme == .light ? .primaryViolet1_900 : .primaryViolet1_50
    }
}

#Preview {
    CongratsView(viewModel: .init(), navigationPath: .constant(.init()))
}
