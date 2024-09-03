// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct TokenListView: View {
    @State private var mocks: [TokenViewModel] = [
        .init(name: "Ethereum", balance: "0.2 $ETH", totalAmount: 500.12),
        .init(name: "Bitcoin", balance: "0.1 $BTC", totalAmount: 5801.44),
        .init(name: "AAVE Protocol", balance: "17.2 $AAVE", totalAmount: 2567.31),
        .init(name: "Uniswap", balance: "0.1 $UNI", totalAmount: 10.77),
        .init(name: "Solana", balance: "17.8 $SOL", totalAmount: 1890.66)
    ]
    
    let shouldShowTotalAmount: Bool
    
    init(shouldShowTotalAmount: Bool = true) {
        self.shouldShowTotalAmount = shouldShowTotalAmount
    }
    
    var body: some View {
        VStack {
            ForEach(mocks, id: \.id) { viewModel in
                makeERC20TokenView(viewModel: viewModel)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue.opacity(0.1))
            .clipShape(RoundedRectangle(cornerSize: .init(width: 16, height: 16)))
            .padding(.horizontal)
        }
    }
}

// MARK: - Private
private extension TokenListView {
    func makeERC20TokenView(viewModel: TokenViewModel) -> some View {
        HStack(alignment: .top) {
            Rectangle()
                .fill(Color.blue)
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(viewModel.name)
                    .font(.headline)
                    .foregroundColor(.black)
                
                Text(viewModel.balance)
                    .font(.subheadline)
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            if shouldShowTotalAmount {
                Text(viewModel.formattedTotalAmount)
                    .font(.headline)
                    .foregroundColor(.black)
            }
        }
    }
}

#Preview {
    TokenListView()
}
