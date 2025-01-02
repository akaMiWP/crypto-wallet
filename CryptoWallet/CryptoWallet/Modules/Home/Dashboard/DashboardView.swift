// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct DashboardView: View {
    
    @ObservedObject private var viewModel: DashboardViewModel
    @EnvironmentObject private var theme: ThemeManager
    
    @State private var destination: NavigationDestinations?
    @State private var showToastMessage = false
    
    init(viewModel: DashboardViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 0) {
            makeTopBarView()
            
            ScrollView {
                Text(viewModel.accountAmount)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(foregroundColor)
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
            .background(backgroundColor)
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
    
    var topBarBackgroundColor: Color {
        theme.currentTheme == .light ? .neutral_20 : .primaryViolet1_800
    }
    
    var buttonBackgroundColor: Color {
        theme.currentTheme == .light ? .primaryViolet1_50 : .primaryViolet1_900
    }
    
    var buttonDropdownColor: Color {
        theme.currentTheme == .light ? .primaryViolet1_500 : .primaryViolet1_100
    }
    
    var backgroundColor: Color {
        theme.currentTheme == .light ? .neutral_10 : .primaryViolet1_700
    }
    
    var foregroundColor: Color {
        theme.currentTheme == .light ? .primaryViolet1_900 : .primaryViolet1_50
    }
    
    var iconColor: Color {
        theme.currentTheme == .light ? .primaryViolet1_400 : .primaryViolet1_200
    }
    
    var shortcutBackgroundColor: Color {
        theme.currentTheme == .light ? .primaryViolet1_400 : .primaryViolet2_900
    }
    
    func didTapCopyToClipboard() {
        viewModel.didTapCopyToClipboard()
        UIPasteboard.general.string = viewModel.walletViewModel.address
    }
    
    func makeTopBarView() -> some View {
        ZStack {
            topBarBackgroundColor
                .ignoresSafeArea()
                .frame(height: 70)
                .shadow(color: .primaryViolet1_300.opacity(0.15), radius: 3, y: 3)
            
            VStack(spacing: 4) {
                HStack(spacing: 8) {
                    Text(viewModel.walletViewModel.name)
                        .font(.headline)
                        .foregroundColor(foregroundColor)
                        .padding(.leading, 14)
                    
                    Image(systemName: "chevron.down")
                        .clipShape(Circle())
                        .foregroundColor(foregroundColor)
                        .frame(width: 20, height: 20)
                }
                .onTapGesture {
                    self.destination = .switchAccount
                }
                
                Button(action: didTapCopyToClipboard) {
                    Text(viewModel.walletViewModel.maskedAddress)
                        .font(.subheadline)
                        .foregroundColor(foregroundColor)
                        .padding(.leading, 14)
                    
                    Image(systemName: "doc.on.doc.fill")
                        .foregroundColor(iconColor)
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
                        .foregroundColor(buttonDropdownColor)
                }
                .padding(.trailing, 12)
                .background(buttonBackgroundColor)
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
                .foregroundColor(.primaryViolet1_50)
            Text(actionName)
                .font(.caption)
                .foregroundColor(.primaryViolet1_50)
        }
        .frame(width: 100, height: 80)
        .background(shortcutBackgroundColor)
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
