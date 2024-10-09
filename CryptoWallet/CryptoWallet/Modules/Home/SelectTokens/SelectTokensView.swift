// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct SelectTokensView: View {
    @ObservedObject var viewModel: SelectTokensViewModel
    @State private var navigationPath = NavigationPath()
    @Environment(\.dismiss) private var dismiss
    
    enum Destinations: Hashable {
        case sendToken(TokenViewModel)
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(spacing: 0) {
                makeSearchComponentView()
                
                ScrollView {
                    TokenListView(
                        viewModels: viewModel.filteredViewModels,
                        shouldShowTotalAmount: false,
                        cellTapCompletion: { selectedViewModel in
                            navigationPath.append(Destinations.sendToken(selectedViewModel))
                        }
                    )
                }
                .padding(.top)
                .navigationDestination(for: Destinations.self) { screen in
                    switch screen {
                    case .sendToken(let selectedTokenViewModel):
                        SelectTokenView(
                            viewModel: viewModel.makeSelectTokenViewModel(selectedTokenViewModel: selectedTokenViewModel),
                            navigationPath: $navigationPath
                        )
                        .navigationBarHidden(
                            true
                        )
                    }
                }
            }
            .ignoresSafeArea(.all, edges: .bottom)
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
                .foregroundColor(.primaryViolet1_900)
                .background(Color.primaryViolet1_50)
                .clipShape(RoundedRectangle(cornerSize: .init(width: 16, height: 16)))
                
                if !viewModel.searchInput.isEmpty {
                    Text("Cancel")
                        .font(.subheadline)
                        .foregroundColor(.primaryViolet1_50)
                }
            }
            .animation(.bouncy, value: viewModel.searchInput)
        } backCompletion: { dismiss() }
    }
}

#Preview {
    SelectTokensView(
        viewModel: .init(
            manageTokensUseCase: ManageTokensImp(),
            viewModels: [
                .init(name: "ABCD", symbol: "ABCD", balance: 0, totalAmount: 0),
                .init(name: "BCDE", symbol: "BCDE", balance: 0, totalAmount: 0),
                .init(name: "CDEF", symbol: "CDEF", balance: 0, totalAmount: 0),
                .init(name: "DEFG", symbol: "DEFG", balance: 0, totalAmount: 0),
                .init(name: "EFGH", symbol: "EFGH", balance: 0, totalAmount: 0),
                .init(name: "FGHI", symbol: "FGHI", balance: 0, totalAmount: 0),
            ]
        )
    )
}
