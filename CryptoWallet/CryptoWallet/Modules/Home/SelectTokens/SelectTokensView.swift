// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct SelectTokensView: View {
    @ObservedObject var viewModel: SelectTokensViewModel
    @State private var navigationPath = NavigationPath()
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var theme: ThemeManager
    
    enum Destinations: Hashable {
        case sendToken(tokenViewModel: TokenViewModel)
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
                            navigationPath.append(Destinations.sendToken(tokenViewModel: selectedViewModel))
                        }
                    )
                }
                .padding(.top)
                .background(backgroundColor)
                .modifier(AlertModifier(viewModel: viewModel))
                .navigationDestination(for: Destinations.self) { screen in
                    switch screen {
                    case .sendToken(let viewModel):
                        if let viewModel = self.viewModel.makeSelectTokenViewModel(selectedTokenViewModel: viewModel) {
                            SelectTokenView(
                                viewModel: viewModel,
                                navigationPath: $navigationPath
                            )
                        }
                    }
                }
            }
            .ignoresSafeArea(.all, edges: .bottom)
        }
    }
}

// MARK: - Private
private extension SelectTokensView {
    
    var backgroundColor: Color {
        theme.currentTheme == .light ? .neutral_10 : .primaryViolet1_700
    }
    
    var placeholderTitleColor: Color { .primaryViolet1_200 }
    
    var placeholderBackgroundColor: Color {
        theme.currentTheme == .light ? .primaryViolet1_50 : .primaryViolet1_900
    }
    
    func makeSearchComponentView() -> some View {
        TitleBarPresentedView(title: "Select Token") {
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search...", text: $viewModel.searchInput)
                }
                .padding(.all, 8)
                .foregroundColor(placeholderTitleColor)
                .background(placeholderBackgroundColor)
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
        viewModel: .init(manageTokensUseCase: ManageTokensImp())
    )
}
