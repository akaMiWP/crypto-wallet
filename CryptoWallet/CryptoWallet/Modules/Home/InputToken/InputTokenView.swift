// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine
import SwiftUI

struct InputTokenView: View {
    @ObservedObject var viewModel: InputTokenViewModel
    @Binding var navigationPath: NavigationPath
    
    @FocusState private var isFocused: Bool
    @State private var cancellable: AnyCancellable?
    @State private var keyboardHeight: CGFloat = 0
    
    enum Destinations: Hashable {
        case summary(transferAmount: Double, tokenViewModel: TokenViewModel)
    }
    
    var body: some View {
        VStack {
            makeTopBarComponent()
            
            makeAddressComponent()
            
            Spacer()
            
            GeometryReader { geometry in
                HStack {
                    let minWidth: CGFloat = 50
                    let maxWidth = min(CGFloat(viewModel.inputAmount.count * 12), geometry.size.width)
                    
                    TextField("", text: $viewModel.inputAmount)
                        .keyboardType(.numberPad)
                        .font(.title3)
                        .foregroundColor(.primaryViolet1_900)
                        .multilineTextAlignment(.trailing)
                        .frame(minWidth: minWidth, maxWidth: maxWidth < minWidth ? minWidth : maxWidth)
                        .focused($isFocused)
                    
                    Text(viewModel.selectedTokenViewModel.symbol)
                        .font(.title3)
                        .foregroundColor(.primaryViolet1_900)
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                .padding(.top, geometry.size.height * 0.2)
            }
            .frame(maxWidth: .infinity)
            
            Spacer()
            
            VStack {
                Rectangle()
                    .fill(.gray.opacity(0.4))
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
                    .lineUpperShadow()
                
                HStack {
                    Text("Available balance:")
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.primaryViolet1_900)
                    
                    Text("\(viewModel.selectedTokenViewModel.balance)")
                        .font(.body)
                        .foregroundColor(.primaryViolet1_900)
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                Button(action: {
                    navigationPath.append(Destinations.summary(transferAmount: viewModel.inputAmount.toDouble(), tokenViewModel: viewModel.selectedTokenViewModel))
                }, label: {
                    Text("Next")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 48)
                        .frame(maxWidth: .infinity)
                        .background(viewModel.isInputValid ? Color.primaryViolet1_400 : Color.primaryViolet1_100)
                        .clipShape(RoundedRectangle(cornerSize: .init(width: 24, height: 24)))
                        .padding()
                })
                .disabled(!viewModel.isInputValid)
            }
            .padding(.vertical)
        }
        .navigationBarBackButtonHidden()
        .navigationDestination(for: Destinations.self) {
            switch $0 {
            case .summary(let transferAmount, let tokenViewModel):
                SummaryView(viewModel: .init())
            }
        }
        .onAppear {
            isFocused = true
            
            /// this will be needed for complex UI scenario. Since iOS14, Apple already handle automatic keyboard avoidance
            cancellable = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
                .merge(with: NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification))
                .sink { notification in
                    if notification.name == UIResponder.keyboardWillShowNotification {
                        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                            keyboardHeight = keyboardFrame.height
                        }
                    } else if notification.name == UIResponder.keyboardWillHideNotification {
                        keyboardHeight = 0
                    }
                }
        }
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
                    .foregroundColor(.primaryViolet1_900)
                
                Text(viewModel.destinationAddress)
                    .font(.subheadline)
                    .foregroundColor(.primaryViolet1_900)
                
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
                .lineDropShadow()
        }
    }
}

#Preview {
    let viewModel: InputTokenViewModel = .init(
        inputTokenUseCase: InputTokenImp(
            tokenModel: .default,
            destinationAddress: "0x00000000000000000"
        )
    )
    return InputTokenView(
        viewModel: viewModel,
        navigationPath: .constant(.init())
    )
}
