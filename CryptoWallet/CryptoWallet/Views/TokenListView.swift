// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct TokenListView: View {
    private let viewModels: [TokenViewModel]
    private let didScrollToBottom: (() -> Void)?
    private let cellTapCompletion: ((TokenViewModel) -> Void)?
    
    let shouldShowTotalAmount: Bool
    
    init(viewModels: [TokenViewModel],
         shouldShowTotalAmount: Bool = true,
         didScrollToBottom: (() -> Void)? = nil,
         cellTapCompletion: ((TokenViewModel) -> Void)? = nil
    ) {
        self.viewModels = viewModels
        self.shouldShowTotalAmount = shouldShowTotalAmount
        self.didScrollToBottom = didScrollToBottom
        self.cellTapCompletion = cellTapCompletion
    }
    
    var body: some View {
        LazyVStack {
            ForEach(viewModels, id: \.id) { viewModel in
                makeTokenView(viewModel: viewModel)
                    .onTapGesture { cellTapCompletion?(viewModel) }
                    .onAppear {
                        if viewModel == viewModels.last(where: { $0.redactedReason != .placeholder }) {
                            didScrollToBottom?()
                        }
                    }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.primaryViolet1_50)
            .clipShape(RoundedRectangle(cornerSize: .init(width: 10, height: 10)))
            .padding(.horizontal)
        }
        .animation(.easeIn, value: viewModels)
    }
}

// MARK: - Private
private extension TokenListView {
    func makeTokenView(viewModel: TokenViewModel) -> some View {
        HStack(alignment: .top) {
            if let logo = viewModel.logo {
                AsyncImage(url: logo) { image in
                    image.image?.resizable()
                }
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .dropShadow()
                .padding(.trailing)
            } else {
                Image(uiImage: viewModel.image)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .dropShadow()
                    .padding(.trailing)
            }
            
            VStack(alignment: .leading) {
                Text(viewModel.name)
                    .fontWeight(.bold)
                    .font(.body)
                    .foregroundColor(.primaryViolet1_900)
                
                Text("\(viewModel.balance)")
                    .font(.body)
                    .foregroundColor(.primaryViolet1_900)
            }
            
            Spacer()
            
            if shouldShowTotalAmount {
                Text(viewModel.formattedTotalAmount)
                    .fontWeight(.semibold)
                    .font(.body)
                    .foregroundColor(.primaryViolet1_900)
            }
        }
        .redacted(reason: viewModel.redactedReason)
    }
}

#Preview {
    TokenListView(viewModels: [
        .init(address: "", name: "ABCD", symbol: "XXXX", balance: 0, totalAmount: 0),
        .init(address: "", name: "BCDE", symbol: "XXXX", balance: 0, totalAmount: 0),
        .init(address: "", name: "CDEF", symbol: "XXXX", balance: 0, totalAmount: 0),
        .init(address: "", name: "DEFG", symbol: "XXXX", balance: 0, totalAmount: 0),
        .init(address: "", name: "EFGH", symbol: "XXXX", balance: 0, totalAmount: 0),
        .init(address: "", name: "FGHI", symbol: "XXXX", balance: 0, totalAmount: 0),
    ])
}
