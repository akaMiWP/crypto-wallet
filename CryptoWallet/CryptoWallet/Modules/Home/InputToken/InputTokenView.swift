// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct InputTokenView: View {
    @ObservedObject var viewModel: InputTokenViewModel
    @Binding var navigationPath: NavigationPath
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack {
            makeTopBarComponent()
            
            makeAddressComponent()
            
            Spacer()
            
            GeometryReader { geometry in
                HStack {
                    let minWidth: CGFloat = 50
                    let maxWidth = min(CGFloat(viewModel.inputAmount.count * 10), geometry.size.width)
                    
                    TextField("", text: $viewModel.inputAmount)
                        .keyboardType(.numberPad)
                        .font(.title3)
                        .multilineTextAlignment(.trailing)
                        .frame(minWidth: minWidth, maxWidth: maxWidth < minWidth ? minWidth : maxWidth)
                        .focused($isFocused)
                    
                    Text(viewModel.selectedTokenViewModel.symbol)
                        .font(.title3)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                .padding(.top, geometry.size.height * 0.2)
            }
            .frame(maxWidth: .infinity)
            
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .onAppear { isFocused = true }
    }
}

// MARK: - Private
private extension InputTokenView {
    func makeTopBarComponent() -> some View {
        TitleBarPresentedView(
            title: viewModel.title,
            imageSystemName: "chevron.backward",
            bottomView: { EmptyView() },
            backCompletion: {
                navigationPath.removeLastIfNeeded()
            }
        )
    }
    
    func makeAddressComponent() -> some View {
        VStack {
            HStack {
                Text("To:")
                    .font(.headline)
                
                Text(viewModel.selectedDestinationAddress)
                    .font(.subheadline)
                
                Spacer()
                
                Image(systemName: "pencil.slash")
                    .resizable()
                    .foregroundColor(.primaryViolet1_800)
                    .frame(width: 18, height: 18)
                    .frame(width: 40, height: 40)
                    .onTapGesture {
                        navigationPath.removeLastIfNeeded()
                    }
            }
            .padding(.horizontal)
            .padding(.vertical, 4)
            
            Rectangle()
                .fill(.gray.opacity(0.2))
                .frame(height: 1)
                .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    let viewModel: InputTokenViewModel = .init(
        selectedTokenViewModel: .init(name: "Ethereum", symbol: "ETH", balance: 100, totalAmount: 0),
        selectedDestinationAddress: "0x00000000000000000",
        title: "Send ETH"
    )
    return InputTokenView(
        viewModel: viewModel,
        navigationPath: .constant(.init())
    )
}
