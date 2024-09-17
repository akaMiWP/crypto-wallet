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
            AsyncImage(url: viewModel.logo)
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(viewModel.name)
                    .font(.headline)
                    .foregroundColor(.black)
                
                Text("\(viewModel.balance)")
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
        .redacted(reason: viewModel.redactedReason)
    }
}

#Preview {
    TokenListView(viewModels: [])
}
