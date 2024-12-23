// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct SummaryView: View {
    @StateObject var viewModel: SummaryViewModel
    @Binding var navigationPath: NavigationPath
    @Environment(\.presentedSheet) private var presentedSheet
    @EnvironmentObject private var theme: ThemeManager
    
    init(viewModel: SummaryViewModel, navigationPath: Binding<NavigationPath>) {
        _viewModel = .init(wrappedValue: viewModel)
        _navigationPath = navigationPath
    }
    
    var body: some View {
        VStack {
            makeTopBarComponent()
            
            Image(systemName: "paperplane.fill")
                .resizable()
                .foregroundColor(imageTintColor)
                .frame(width: 36, height: 36)
                .padding()
                .background(imageBackgroundColor)
                .clipShape(Circle())
                .padding(.top, 24)
            
            Text(viewModel.sendAmountText)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(foregroundColor)
                .padding(.top, 12)
            
            VStack(spacing: 24) {
                HStack {
                    Text("To:")
                        .foregroundColor(foregroundColor)
                    
                    Spacer()
                    
                    Text(viewModel.destinationAddress)
                        .fontWeight(.semibold)
                        .foregroundColor(foregroundColor)
                }
                
                Rectangle()
                    .fill(backgroundColor)
                    .frame(height: 1)
                
                HStack {
                    Text("Network:")
                        .foregroundColor(foregroundColor)
                    
                    Spacer()
                    
                    Text(viewModel.networkName)
                        .fontWeight(.semibold)
                        .foregroundColor(foregroundColor)
                }
                
                Rectangle()
                    .fill(backgroundColor)
                    .frame(height: 1)
                
                HStack {
                    Text("Network fee:")
                        .foregroundColor(foregroundColor)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("$\(viewModel.networkFee)")
                            .fontWeight(.semibold)
                            .foregroundColor(foregroundColor)
                        
                        Text("(\(viewModel.gasPrice) Gwei)")
                            .foregroundColor(gasColor)
                            .font(.callout)
                            .foregroundColor(foregroundColor)
                    }
                }
            }
            .padding()
            .background(tableBackgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal)
            .padding(.top, 24)
            
            Spacer()
            
            Button(action: {
                viewModel.didTapNextButton()
            }, label: {
                Text("Send")
                    .font(.headline)
                    .foregroundColor(.primaryViolet1_50)
                    .frame(height: 48)
                    .frame(maxWidth: .infinity)
                    .background(viewModel.hasFetchedForGasPrice ? Color.primaryViolet1_500 : Color.primaryViolet1_100)
                    .clipShape(RoundedRectangle(cornerSize: .init(width: 24, height: 24)))
                    .padding()
            })
            .disabled(!viewModel.hasFetchedForGasPrice)
        }
        .background(backgroundColor)
        .modifier(AlertModifier(viewModel: viewModel))
        .overlay {
            if viewModel.shouldPresentTransactionReceipt {
                TransactionReceiptView(
                    viewModel: viewModel.receiptViewModel,
                    onDismiss: {
                        presentedSheet.wrappedValue = false
                    }
                )
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            viewModel.fetchGasPrice()
        }
        .onDisappear {
            viewModel.postRefreshAccountBalanceNotification()
        }
    }
}

// MARK: - Private
private extension SummaryView {
    
    var foregroundColor: Color {
        theme.currentTheme == .light ? .primaryViolet1_900 : .primaryViolet1_50
    }
    
    var gasColor: Color {
        theme.currentTheme == .light ? .secondaryGreen1_50 : .secondaryGreen2_600
    }
    
    var backgroundColor: Color {
        theme.currentTheme == .light ? .neutral_10 : .primaryViolet1_700
    }
    
    var tableBackgroundColor: Color {
        theme.currentTheme == .light ? .primaryViolet1_50 : .primaryViolet1_800
    }
    
    var imageBackgroundColor: Color {
        theme.currentTheme == .light ? .primaryViolet1_200 : .primaryViolet1_800
    }
    
    var imageTintColor: Color { .primaryViolet1_50 }
    
    func makeTopBarComponent() -> some View {
        TitleBarPresentedView(
            title: "Summary",
            imageSystemName: "chevron.backward",
            bottomView: { EmptyView() },
            backCompletion: {
                navigationPath.removeLastIfNeeded()
            }
        )
    }
}

#Preview {
    let viewModel: SummaryViewModel = .init(
        summaryTokenUseCase: SummaryTokenImp(
            destinationAddress: "0x000000",
            sendAmount: 0,
            tokenModel: .default
        ),
        manageWalletUseCase: ManageWalletsImpl(),
        nodeProviderUseCase: NodeProviderImpl(
            networkStack: .init(),
            networkPollingHandler: NetworkPollingHandler()
        ),
        prepareTransactionUseCase: PrepareTransactionImp()
    )
    return SummaryView(viewModel: viewModel, navigationPath: .constant(.init())).environmentObject(ThemeManager())
}
