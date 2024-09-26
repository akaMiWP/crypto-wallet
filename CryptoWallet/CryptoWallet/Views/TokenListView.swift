// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct TokenListView: View {
    private let viewModels: [TokenViewModel]
    private let didScrollToBottom: (() -> Void)?
    
    let shouldShowTotalAmount: Bool
    
    init(viewModels: [TokenViewModel],
         shouldShowTotalAmount: Bool = true,
         didScrollToBottom: (() -> Void)? = nil
    ) {
        self.viewModels = viewModels
        self.shouldShowTotalAmount = shouldShowTotalAmount
        self.didScrollToBottom = didScrollToBottom
    }
    
    var body: some View {
        LazyVStack {
            ForEach(viewModels, id: \.id) { viewModel in
                makeERC20TokenView(viewModel: viewModel)
                    .onAppear {
                        if viewModel == viewModels.last(where: { $0.redactedReason != .placeholder }) {
                            didScrollToBottom?()
                        }
                    }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.secondaryGreen1_50)
            .clipShape(RoundedRectangle(cornerSize: .init(width: 16, height: 16)))
            .padding(.horizontal)
        }
    }
}

// MARK: - Private
private extension TokenListView {
    func makeERC20TokenView(viewModel: TokenViewModel) -> some View {
        HStack(alignment: .top) {
            AsyncImage(url: viewModel.logo)
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .dropShadow()
                .padding(.trailing)
            
            VStack(alignment: .leading) {
                Text(viewModel.name)
                    .font(.headline)
                    .foregroundColor(.primaryViolet1_900)
                
                Text("\(viewModel.balance)")
                    .font(.subheadline)
                    .foregroundColor(.primaryViolet1_900)
            }
            
            Spacer()
            
            if shouldShowTotalAmount {
                Text(viewModel.formattedTotalAmount)
                    .font(.headline)
                    .foregroundColor(.primaryViolet1_900)
            }
        }
        .redacted(reason: viewModel.redactedReason)
    }
}

#Preview {
    TokenListView(viewModels: [
        .init(name: "ABCD", symbol: "XXXX", balance: 0, totalAmount: 0),
        .init(name: "BCDE", symbol: "XXXX", balance: 0, totalAmount: 0),
        .init(name: "CDEF", symbol: "XXXX", balance: 0, totalAmount: 0),
        .init(name: "DEFG", symbol: "XXXX", balance: 0, totalAmount: 0),
        .init(name: "EFGH", symbol: "XXXX", balance: 0, totalAmount: 0),
        .init(name: "FGHI", symbol: "XXXX", balance: 0, totalAmount: 0),
    ])
}
