// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct SwitchAccountView: View {
    @ObservedObject var viewModel: SwitchAccountViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            TitleBarPresentedView(
                title: "Select a network",
                bottomView: {}
            )
            
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
                        .background(wallet.isSelected ? Color.primaryViolet1_100 : Color.primaryViolet1_50)
                        .clipShape(RoundedRectangle(cornerSize: .init(width: 16, height: 16)))
                        .onTapGesture {
                            viewModel.selectWallet(wallet: wallet)
                            dismiss()
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
            .background(Color.primaryViolet1_500)
            .clipShape(RoundedRectangle(cornerSize: .init(width: 16, height: 16)))
            .padding()
            .shadow(color: .primaryViolet2_300, radius: 22, x: 7, y: 7)
        }
        .modifier(AlertModifier(viewModel: viewModel))
        .onAppear { viewModel.loadWallets() }
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
