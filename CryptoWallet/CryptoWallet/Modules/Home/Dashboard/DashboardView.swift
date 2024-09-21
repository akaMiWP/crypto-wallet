// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct DashboardView: View {
    
    @State private var destination: NavigationDestinations?
    @ObservedObject private var viewModel: DashboardViewModel
    
    init(viewModel: DashboardViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            makeTopBarView()
            
            ScrollView {
                Text("$0.00")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .redacted(reason: viewModel.state.redactionReasons)
                
                makeOperationViews()
                TokenListView(
                    viewModels: viewModel.tokenViewModels,
                    shouldShowTotalAmount: false,
                    didScrollToBottom: { viewModel.fetchNextTokens() }
                )
                    
                Spacer()
            }
        }
        .navigationBarBackButtonHidden()
        .modifier(AlertModifier(viewModel: viewModel))
        .sheet(isPresented: isPresented) {
            switch destination {
            case .switchNetwork: EmptyView()
            case .switchAccount: SwitchAccountView(viewModel: .init(mangageHDWalletUseCase: ManageHDWalletImpl()))
            case .sendTokens: SelectTokensView()
            case .receiveTokens: SelectTokensView()
            case nil: EmptyView()
            }
        }
        .onAppear {
            viewModel.fetchTokenBalances()
        }
    }
}

// MARK: - Private
private extension DashboardView {
    var isPresented: Binding<Bool> {
        .init(
            get: { destination != nil },
            set: { newValue in
                if !newValue { destination = nil }
            }
        )
    }
    
    func makeTopBarView() -> some View {
        ZStack {
            VStack {
                HStack {
                    Text("Account 1")
                        .font(.headline)
                    
                    Image(systemName: "chevron.down")
                        .clipShape(Circle())
                }
                .onTapGesture {
                    self.destination = .switchAccount
                }
                
                Text(viewModel.derivatedAddress)
                    .font(.subheadline)
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
                        .clipShape(Circle())
                }
                .padding(.trailing, 12)
                .background(Color.blue.opacity(0.2))
                .clipShape(RoundedRectangle(cornerSize: .init(width: 32, height: 32)))
                .onTapGesture {
                    self.destination = .switchNetwork
                }
                
                Spacer()
            }
        }
        .padding(.horizontal)
        .redacted(reason: viewModel.state.redactionReasons)
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
        .onTapGesture {
            self.destination = destination
        }
    }
}

#Preview {
    let viewModel: DashboardViewModel = .init(
        nodeProviderUseCase: NodeProviderImpl(
            networkStack: .init()
        ),
        manageHDWalletUseCase: ManageHDWalletImpl(),
        globalEventUseCase: GlobalEventImp()
    )
    viewModel.state = .loading
    viewModel.derivatedAddress = "0x99900dddddddddddddddddddddddddddddddddddd".maskedWalletAddress()
    return DashboardView(viewModel: viewModel)
}
