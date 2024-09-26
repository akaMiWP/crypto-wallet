// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct SwitchAccountView: View {
    @ObservedObject var viewModel: SwitchAccountViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Select an account")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primaryViolet1_900)
                .padding(.top)
            
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
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .padding(.horizontal)
                        .background(Color.primaryViolet2_400)
                        .clipShape(RoundedRectangle(cornerSize: .init(width: 16, height: 16)))
                        .onTapGesture {
                            viewModel.selectWallet(wallet: wallet)
                            dismiss()
                        }
                    }
                    .foregroundColor(.white)
                }
            }
            
            Spacer()
            
            Button(action: {
                viewModel.createNewWallet()
                dismiss()
            }, label: {
                Text("Create a new wallet")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .font(.subheadline)
            })
            .frame(height: 46)
            .frame(maxWidth: .infinity)
            .background(Color.primaryViolet1_500)
            .clipShape(RoundedRectangle(cornerSize: .init(width: 16, height: 16)))
        }
        .padding(.horizontal)
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
