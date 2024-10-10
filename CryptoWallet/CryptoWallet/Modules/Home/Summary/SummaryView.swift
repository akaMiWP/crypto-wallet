// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct SummaryView: View {
    @ObservedObject var viewModel: SummaryViewModel
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        VStack {
            makeTopBarComponent()
            
            Image(systemName: "paperplane.fill")
                .resizable()
                .foregroundColor(.primaryViolet1_400)
                .frame(width: 36, height: 36)
                .padding()
                .background(Color.primaryViolet1_50)
                .clipShape(Circle())
                .padding(.top, 24)
            
            Text("0.01 ETH")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 12)
            
            VStack(spacing: 24) {
                HStack {
                    Text("To:")
                    
                    Spacer()
                    
                    Text("0x000000000")
                        .fontWeight(.semibold)
                }
                
                Rectangle()
                    .fill(Color.white)
                    .frame(height: 1)
                
                HStack {
                    Text("Network:")
                    
                    Spacer()
                    
                    Text("Ethereum")
                        .fontWeight(.semibold)
                }
                
                Rectangle()
                    .fill(Color.white)
                    .frame(height: 1)
                
                HStack {
                    Text("Network fee:")
                    
                    Spacer()
                    
                    Text("$0.01")
                        .fontWeight(.semibold)
                }
            }
            .padding()
            .background(Color.secondaryGreen1_50)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal)
            .padding(.top, 24)
            
            Spacer()
            
            Button(action: {}, label: {
                Text("Send")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 48)
                    .frame(maxWidth: .infinity)
                    .background(Color.primaryViolet1_400)
                    .clipShape(RoundedRectangle(cornerSize: .init(width: 24, height: 24)))
                    .padding()
            })
            
            
        }
    }
}

// MARK: - Private
private extension SummaryView {
    func makeTopBarComponent() -> some View {
        TitleBarPresentedView(
            title: "Summary",
            imageSystemName: "chevron.backward",
            bottomView: { EmptyView() },
            backCompletion: {
                navigationPath.removeLastIfNeeded()
            }
        )
    }
}

#Preview {
    let viewModel: SummaryViewModel = .init()
    return SummaryView(viewModel: viewModel, navigationPath: .constant(.init()))
}
