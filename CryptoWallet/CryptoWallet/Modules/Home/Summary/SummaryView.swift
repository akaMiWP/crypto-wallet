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
            
            Text(viewModel.sendAmountText)
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 12)
            
            VStack(spacing: 24) {
                HStack {
                    Text("To:")
                    
                    Spacer()
                    
                    Text(viewModel.destinationAddress)
                        .fontWeight(.semibold)
                }
                
                Rectangle()
                    .fill(Color.white)
                    .frame(height: 1)
                
                HStack {
                    Text("Network:")
                    
                    Spacer()
                    
                    Text(viewModel.networkName)
                        .fontWeight(.semibold)
                }
                
                Rectangle()
                    .fill(Color.white)
                    .frame(height: 1)
                
                HStack {
                    Text("Network fee:")
                    
                    Spacer()
                    
                    Text("$\(viewModel.networkFee)")
                        .fontWeight(.semibold)
                }
            }
            .padding()
            .background(Color.secondaryGreen1_50)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal)
            .padding(.top, 24)
            
            Spacer()
            
            Button(action: { navigationPath = .init() }, label: {
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
        .navigationBarBackButtonHidden()
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
    let viewModel: SummaryViewModel = .init(summaryTokenUseCase: SummaryTokenImp(destinationAddress: "0x000000", sendAmount: 0, tokenModel: .default))
    return SummaryView(viewModel: viewModel, navigationPath: .constant(.init()))
}
