// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct DashboardView: View {
    
    @State private var destination: NavigationDestinations?
    @State private var showToastMessage = false
    @ObservedObject private var viewModel: DashboardViewModel
    
    init(viewModel: DashboardViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 0) {
            makeTopBarView()
            
            ScrollView {
                Text("$0.00")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primaryViolet1_900)
                    .redacted(reason: viewModel.state.redactionReasons)
                
                makeOperationViews()
                TokenListView(
                    viewModels: viewModel.tokenViewModels,
                    shouldShowTotalAmount: false,
                    didScrollToBottom: { viewModel.fetchNextTokens() }
                )
                .padding(.top, 30)
            }
            .padding(.top, 36)
            .refreshable { viewModel.pullToRefresh() }
        }
        .navigationBarBackButtonHidden()
        .modifier(AlertModifier(viewModel: viewModel))
        .modifier(ToastMessageModifier(text: "Address Copied", shouldShowToastMessage: viewModel.shouldShowToastMessage))
        .sheet(isPresented: isPresented) {
            switch destination {
            case .switchNetwork: SwitchNetworkView()
            case .switchAccount: SwitchAccountView(viewModel: .init(manageWalletsUseCase: ManageWalletsImpl()))
            case .sendTokens:
                SelectTokensView(viewModel: viewModel.makeSelectTokensViewModel())
                    .presentedSheet(isPresented)
            case .receiveTokens: SelectTokensView(viewModel: viewModel.makeSelectTokensViewModel())
            case nil: EmptyView()
            }
        }
        .disabled(viewModel.state.isLoading)
        .onAppear {
            if !viewModel.didAppear {
                viewModel.fetchData()
            }
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
    
    func didTapCopyToClipboard() {
        viewModel.didTapCopyToClipboard()
        UIPasteboard.general.string = viewModel.walletViewModel.address
    }
    
    func makeTopBarView() -> some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
                .frame(height: 70)
                .shadow(color: .primaryViolet1_300.opacity(0.15), radius: 3, y: 3)
            
            VStack(spacing: 4) {
                HStack(spacing: 8) {
                    Text(viewModel.walletViewModel.name)
                        .font(.headline)
                        .foregroundColor(.primaryViolet1_900)
                        .padding(.leading, 14)
                    
                    Image(systemName: "chevron.down")
                        .clipShape(Circle())
                        .foregroundColor(.primaryViolet1_900)
                        .frame(width: 20, height: 20)
                }
                .onTapGesture {
                    self.destination = .switchAccount
                }
                
                Button(action: didTapCopyToClipboard) {
                    Text(viewModel.walletViewModel.maskedAddress)
                        .font(.subheadline)
                        .foregroundColor(.primaryViolet1_900)
                        .padding(.leading, 14)
                    
                    Image(systemName: "doc.on.doc.fill")
                        .foregroundColor(.primaryViolet1_900)
                        .frame(width: 20, height: 20)
                }
                .padding(.bottom, 16)
            }
            
            HStack {
                HStack {
                    Image(uiImage: viewModel.networkViewModel.image)
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 30, height: 30)
                        .padding(8)
                        .background(Color.primaryViolet1_50)
                        .clipShape(Circle())
                    
                    Image(systemName: "chevron.down")
                        .resizable()
                        .frame(width: 16, height: 8)
                        .foregroundColor(.primaryViolet1_500)
                }
                .padding(.trailing, 12)
                .background(Color.primaryViolet1_50)
                .clipShape(RoundedRectangle(cornerSize: .init(width: 32, height: 32)))
                .onTapGesture {
                    self.destination = .switchNetwork
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 16)
        }
        .redacted(reason: viewModel.state.redactionReasons)
        .animation(.linear, value: viewModel.tokenViewModels)
    }
    
    func makeOperationViews() -> some View {
        HStack(spacing: 32) {
            makeOperationView(imageName: "plus", actionName: "Receive", destination: .receiveTokens)
            
            makeOperationView(imageName: "paperplane", actionName: "Send", destination: .sendTokens)
        }
        .padding(.top, 24)
        .padding(.horizontal)
    }
    
    func makeOperationView(imageName: String, actionName: String, destination: NavigationDestinations) -> some View {
        VStack(spacing: 8) {
            Image(systemName: imageName)
                .resizable()
                .frame(width: 27, height: 27)
                .foregroundColor(.white)
            Text(actionName)
                .font(.caption)
                .foregroundColor(.white)
        }
        .frame(width: 100, height: 80)
        .background(Color.primaryViolet1_400)
        .clipShape(RoundedRectangle(cornerSize: .init(width: 16, height: 16)))
        .onTapGesture {
            self.destination = destination
        }
    }
}

#Preview {
    let viewModel: DashboardViewModel = .init(
        nodeProviderUseCase: NodeProviderImpl(
            networkStack: .init(),
            networkPollingHandler: NetworkPollingHandler()
        ),
        manageHDWalletUseCase: ManageHDWalletImpl(),
        manageTokensUseCase: ManageTokensImp(),
        manageWalletsUseCase: ManageWalletsImpl(),
        supportNetworksUseCase: SupportNetworksImp(),
        globalEventUseCase: GlobalEventImp()
    )
    viewModel.state = .loading
    viewModel.walletViewModel = .init(
        name: "Account #1",
        address: "0x99900dddddddddddddddddddddddddddddddddddd",
        isSelected: true
    )
    return DashboardView(viewModel: viewModel)
}
