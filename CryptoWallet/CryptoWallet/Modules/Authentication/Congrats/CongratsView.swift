// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct CongratsView: View {
    @ObservedObject private var viewModel: CongratsViewModel
    
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
                .foregroundColor(.primaryViolet1_800)
                .padding(.top, 16)
            
            Text("You can now fully enjoy your wallet")
                .font(.callout)
                .foregroundColor(.primaryViolet1_900)
                .padding(.top, 8)
            
            Spacer()
            
            PrimaryButton(title: "Get Started") {
                navigationPath.wrappedValue = .init()
                viewModel.didTapButton()
            }
            .shadow(color: .primaryViolet2_300, radius: 22, x: 7, y: 7)
            
            Spacer()
        }
        .padding(.horizontal, 36)
        .cardStyle()
    }
}

#Preview {
    CongratsView(viewModel: .init(), navigationPath: .constant(.init()))
}
