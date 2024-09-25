// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct SelectTokensView: View {
    @ObservedObject var viewModel: SelectTokensViewModel
    @State private var navigationPath = NavigationPath()
    @Environment(\.dismiss) private var dismiss
    
    enum Destinations {
        case sendToken
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            makeSearchComponentView()
            
            ScrollView {
                NavigationLink(value: Destinations.sendToken) {
                    TokenListView(viewModels: viewModel.filteredViewModels, shouldShowTotalAmount: false)
                }
                
                Spacer()
            }
            .navigationDestination(for: Destinations.self) { screen in
                switch screen {
                case .sendToken:
                    SelectTokenView(navigationPath: $navigationPath)
                        .navigationBarHidden(true)
                }
            }
        }
    }
}

// MARK: - Private
private extension SelectTokensView {
    func makeSearchComponentView() -> some View {
        TitleBarPresentedView(title: "Select Token") {
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search...", text: $viewModel.searchInput)
                }
                .padding(.all, 8)
                .background(Color.blue.opacity(0.1))
                .clipShape(RoundedRectangle(cornerSize: .init(width: 16, height: 16)))
                
                Text("Cancel")
                    .font(.subheadline)
            }
        } backCompletion: { dismiss() }
    }
}

#Preview {
    SelectTokensView(
        viewModel: .init(
            viewModels: [
                .init(name: "ABCD", symbol: "XXXX", balance: 0, totalAmount: 0),
                .init(name: "BCDE", symbol: "XXXX", balance: 0, totalAmount: 0),
                .init(name: "CDEF", symbol: "XXXX", balance: 0, totalAmount: 0),
                .init(name: "DEFG", symbol: "XXXX", balance: 0, totalAmount: 0),
                .init(name: "EFGH", symbol: "XXXX", balance: 0, totalAmount: 0),
                .init(name: "FGHI", symbol: "XXXX", balance: 0, totalAmount: 0),
            ]
        )
    )
}
