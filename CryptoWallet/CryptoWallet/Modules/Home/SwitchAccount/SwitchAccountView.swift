// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct SwitchAccountView: View {
    @ObservedObject var viewModel: SwitchAccountViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Select an account")
                .font(.title)
                .fontWeight(.bold)
            
            ForEach(viewModel.wallets, id: \.address) { wallet in
                HStack {
                    VStack(alignment: .leading) {
                        Text(wallet.name)
                            .fontWeight(.bold)
                        Text(wallet.address)
                    }
                    .font(.subheadline)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .padding(.horizontal)
                .background(.blue)
                .clipShape(RoundedRectangle(cornerSize: .init(width: 16, height: 16)))
                .padding(.horizontal)
                .onTapGesture {
                    viewModel.selectWallet(wallet: wallet)
                    dismiss()
                }
            }
            .foregroundColor(.white)
            
            Spacer()
            
            Button(action: {
                viewModel.createNewWallet()
                dismiss()
            }, label: {
                Text("Create a new wallet")
            })
            
        }
    }
}

#Preview {
    SwitchAccountView(viewModel: .init())
}
