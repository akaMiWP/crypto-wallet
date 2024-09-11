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
        VStack {
            Rectangle()
                .frame(height: 200)
                .padding(.horizontal)
            
            Text("You're all done!")
                .font(.title)
                .padding(.top, 16)
            
            Text("You can now fully enjoy your wallet")
                .font(.body)
                .padding(.top, 8)
            
            Button(action: {
                navigationPath.wrappedValue = .init()
                viewModel.didTapButton()
            }, label: {
                Text("Get Started")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 46)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerSize: .init(width: 16, height: 16)))
                    .padding(.horizontal)
                    .padding(.top, 24)
            })
        }
    }
}

#Preview {
    CongratsView(viewModel: .init(), navigationPath: .constant(.init()))
}
