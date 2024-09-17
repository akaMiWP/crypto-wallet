// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct DashboardView: View {
    
    @State private var isSheetPresented: Bool = false
    @ObservedObject private var viewModel: DashboardViewModel
    
    init(viewModel: DashboardViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            makeTopBarView()
            
            ScrollView {
                Text("$21.10")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .redacted(reason: viewModel.state.redactionReasons)
                
                makeOperationViews()
                TokenListView(
                    viewModels: viewModel.tokenViewModels,
                    isLoading: viewModel.state.redactionReasons == .placeholder,
                    didScrollToBottom: { viewModel.fetchNextTokens() }
                )
                    
                Spacer()
            }
        }
        .onAppear {
            viewModel.fetchTokenBalances()
        }
    }
}

// MARK: - Private
private extension DashboardView {
    func makeTopBarView() -> some View {
        ZStack {
            HStack {
                Text("Account 1")
                    .font(.headline)
                
                Image(systemName: "chevron.down")
            }
            
            HStack {
                HStack {
                    Text("S")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.blue)
                        .clipShape(Circle())
                    
                    Image(systemName: "chevron.down")
                }
                .padding(.trailing, 12)
                .background(Color.blue.opacity(0.2))
                .clipShape(RoundedRectangle(cornerSize: .init(width: 32, height: 32)))
                
                Spacer()
            }
        }
        .padding(.horizontal)
    }
    
    func makeOperationViews() -> some View {
        HStack(spacing: 32) {
            makeOperationView(imageName: "plus", actionName: "Receive", destination: .receiveTokens)
            
            makeOperationView(imageName: "paperplane", actionName: "Send", destination: .sendTokens)
        }
        .padding()
    }
    
    func makeOperationView(imageName: String, actionName: String, destination: NavigationDestinations) -> some View {
        VStack(spacing: 8) {
            Image(systemName: imageName)
                .font(.title2)
                .foregroundColor(Color.blue)
            Text(actionName)
                .font(.caption)
        }
        .frame(width: 100, height: 80)
        .background(Color.blue.opacity(0.2))
        .clipShape(RoundedRectangle(cornerSize: .init(width: 16, height: 16)))
        .onTapGesture { isSheetPresented = true }
        .sheet(isPresented: $isSheetPresented) {
            switch destination {
            case .sendTokens: SelectTokensView()
            case .receiveTokens: SelectTokensView()
            default: EmptyView()
            }
        }
    }
}

#Preview {
    let viewModel: DashboardViewModel = .init(
        nodeProviderUseCase: NodeProviderImpl(
            networkStack: .init()
        )
    )
    viewModel.state = .loading
    return DashboardView(viewModel: viewModel)
}
