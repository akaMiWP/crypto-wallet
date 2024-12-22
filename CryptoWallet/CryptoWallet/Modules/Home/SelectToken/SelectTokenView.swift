// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct SelectTokenView: View {
    @ObservedObject var viewModel: SelectTokenViewModel
    @Binding var navigationPath: NavigationPath
    @EnvironmentObject var theme: ThemeManager
    
    enum Destinations: Hashable {
        case inputToken
    }
    
    var body: some View {
        VStack {
            makeTopBarComponent()
            
            makeAddressComponent()
            
            Spacer()
            
            Button(action: {
                navigationPath.append(Destinations.inputToken)
            }, label: {
                Text("Next")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 48)
                    .frame(maxWidth: .infinity)
                    .background(viewModel.isAddressValid ? Color.primaryViolet1_500 : Color.primaryViolet1_100)
                    .clipShape(RoundedRectangle(cornerSize: .init(width: 24, height: 24)))
                    .padding()
            })
            .disabled(!viewModel.isAddressValid)
        }
        .background(backgroundColor)
        .navigationBarBackButtonHidden()
        .navigationDestination(for: Destinations.self) {
            switch $0 {
            case .inputToken:
                InputTokenView(
                    viewModel: viewModel.makeInputTokenViewModel(),
                    navigationPath: $navigationPath
                )
            }
        }
    }
}

// MARK: - Private
private extension SelectTokenView {
    
    var backgroundColor: Color {
        theme.currentTheme == .light ? .neutral_10 : .primaryViolet1_700
    }
    
    var borderColor: Color {
        theme.currentTheme == .light ? .primaryViolet1_400 : .primaryViolet1_50
    }
    
    var foregroundColor: Color {
        theme.currentTheme == .light ? .primaryViolet1_900 : .primaryViolet1_50
    }
    
    var shadowColor: Color {
        theme.currentTheme == .light ? .primaryViolet2_300 : .primaryViolet1_900.opacity(0.8)
    }
    
    var placeholderTitleColor: Color { .primaryViolet1_200 }
    
    var placeholderBackgroundColor: Color {
        theme.currentTheme == .light ? .white : .primaryViolet1_700
    }
    
    func makeTopBarComponent() -> some View {
        TitleBarPresentedView(
            title: viewModel.pageTitle,
            imageSystemName: "chevron.backward",
            bottomView: { EmptyView() },
            backCompletion: {
                navigationPath.removeLast()
            }
        )
    }
    
    func makeAddressComponent() -> some View {
        VStack {
            HStack {
                Text("To:")
                    .foregroundColor(foregroundColor)
                    .padding(.trailing)
                
                TextField("Name or address", text: $viewModel.addressInput)
                    .font(.subheadline)
                    .foregroundColor(placeholderTitleColor)
                    .padding()
                    .background(placeholderBackgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(borderColor)
                    )
                
                
                Image(systemName: viewModel.isAddressValid ? "checkmark" : "doc.on.clipboard.fill")
                    .resizable()
                    .foregroundColor( viewModel.isAddressValid ? .secondaryGreen2_700 : foregroundColor)
                    .frame(width: 18, height: 18)
                    .frame(width: 40, height: 40)
                    .disabled(viewModel.isAddressValid)
                    .animation(.bouncy, value: viewModel.isAddressValid)
                    .onTapGesture {
                        let address = UIPasteboard.general.string
                        viewModel.didTapPasteButton(address: address)
                    }
            }
            .padding(.horizontal)
            .padding(.vertical, 4)
            
            Rectangle()
                .fill(Color.primaryViolet1_50)
                .frame(height: 1)
                .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    SelectTokenView(
        viewModel: .init(
            selectTokenUseCase: SelectTokenImp(
                selectedTokenModel: .default
            ),
            prepareTransactionUseCase: PrepareTransactionImp()
        ),
        navigationPath: .constant(.init())
    )
    .environmentObject(ThemeManager())
}
