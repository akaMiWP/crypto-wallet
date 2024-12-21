// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct SwitchAccountView: View {
    @ObservedObject var viewModel: SwitchAccountViewModel
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var theme: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            TitleBarPresentedView(
                title: "Select an account",
                bottomView: {}
            ) {
                dismiss()
            }
            
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.wallets, id: \.address) { wallet in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(wallet.name)
                                    .fontWeight(.bold)
                                    .font(.subheadline)
                                Text(wallet.maskedAddress)
                                    .font(.subheadline)
                            }
                            .foregroundColor(foregroundColor)
                            
                            Spacer()
                            
                            if wallet.isSelected {
                                Image(systemName: "checkmark.circle")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 66)
                        .padding(.horizontal)
                        .background(wallet.isSelected ? selectedBackgroundColor : unselectedBackgroundColor)
                        .clipShape(RoundedRectangle(cornerSize: .init(width: 16, height: 16)))
                        .onTapGesture {
                            viewModel.selectWallet(wallet: wallet)
                        }
                    }
                    .foregroundColor(.primaryViolet1_900)
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            Button(action: {
                viewModel.createNewWallet()
                dismiss()
            }, label: {
                Text("Create a new wallet")
                    .foregroundColor(.white)
            })
            .frame(height: 46)
            .frame(maxWidth: .infinity)
            .background(buttonBackgroundColor)
            .clipShape(RoundedRectangle(cornerSize: .init(width: 16, height: 16)))
            .padding()
            .shadow(color: buttonShadowColor, radius: 22, x: 7, y: 7)
        }
        .background(backgroundColor)
        .modifier(AlertModifier(viewModel: viewModel))
        .dismissable(from: viewModel.$shouldDismiss, dismissAction: dismiss)
        .onAppear { viewModel.loadWallets() }
    }
}

// MARK: - Private
private extension SwitchAccountView {
    
    var backgroundColor: Color {
        theme.currentTheme == .light ? .neutral_10 : .primaryViolet1_700
    }
    
    var buttonBackgroundColor: Color { .primaryViolet1_500 }
    
    var buttonShadowColor: Color {
        theme.currentTheme == .light ? .primaryViolet2_300 : .primaryViolet1_900
    }
    
    var foregroundColor: Color {
        theme.currentTheme == .light ? .primaryViolet1_900 : .primaryViolet1_50
    }
    
    var unselectedBackgroundColor: Color {
        theme.currentTheme == .light ? .primaryViolet1_50 : .primaryViolet1_800
    }
    
    var selectedBackgroundColor: Color {
        theme.currentTheme == .light ? .primaryViolet1_100 : .primaryViolet1_900
    }
}

#Preview {
    HDWalletManager.shared.createdWalletModels = [
        .init(name: "Account #1", address: "0xd8da6bf26964af9d7eed9e03e53415d37aa96045"),
        .init(name: "Account #2", address: "0xd8da6bf26964af9d7eed9e03e53415d37aa96045"),
        .init(name: "Account #3", address: "0xd8da6bf26964af9d7eed9e03e53415d37aa96045")
    ]
    return SwitchAccountView(viewModel: .init(manageWalletsUseCase: ManageWalletsImpl()))
}
