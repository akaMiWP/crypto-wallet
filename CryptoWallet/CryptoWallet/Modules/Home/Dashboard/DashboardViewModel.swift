// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine
import Foundation

// 0xd8da6bf26964af9d7eed9e03e53415d37aa96045: a sample address

final class DashboardViewModel: Alertable {
    
    @Published var state: ViewModelState = .loading
    @Published var walletViewModel: WalletViewModel = .default
    @Published var networkViewModel: NetworkViewModel = .default
    @Published var tokenViewModels: [TokenViewModel] = []
    @Published var shouldRefetchTokenBalances: Bool = false
    @Published var shouldShowToastMessage: Bool = false
    @Published var alertViewModel: AlertViewModel?
    
    private let pageSize: Int = 12
    private var allTokens: [AddressToTokenModel] = []
    private var offset: Int = 0
    
    private var ethBalance: Double = 0
    
    private var addressToTokenModelsDict:
    PassthroughSubject<[AddressToTokenModel: TokenMetadataModel], Never> = .init()
    private var cancellables: Set<AnyCancellable> = .init()
    
    private let nodeProviderUseCase: NodeProviderUseCase
    private let manageHDWalletUseCase: ManageHDWalletUseCase
    private let manageWalletsUseCase: ManageWalletsUseCase
    private let supportNetworksUseCase: SupportNetworksUseCase
    private let globalEventUseCase: GlobalEventUseCase
    
    init(nodeProviderUseCase: NodeProviderUseCase,
         manageHDWalletUseCase: ManageHDWalletUseCase,
         manageWalletsUseCase: ManageWalletsUseCase,
         supportNetworksUseCase: SupportNetworksUseCase,
         globalEventUseCase: GlobalEventUseCase
    ) {
        self.nodeProviderUseCase = nodeProviderUseCase
        self.manageHDWalletUseCase = manageHDWalletUseCase
        self.manageWalletsUseCase = manageWalletsUseCase
        self.supportNetworksUseCase = supportNetworksUseCase
        self.globalEventUseCase = globalEventUseCase
        subscribeToAddressToTokenModelDict()
        subscribeToAccountChange()
        subscribeToNetworkChange()
    }
    
    func fetchData() {
        let fetchSelectedNetworkPublisher = fetchSelectedNetwork()
        let fetchTokenBalancesPublisher = fetchTokenBalances()
        let fetchEthereumBalancePublisher = manageWalletsUseCase
            .loadSelectedWalletPublisher()
            .delay(for: .seconds(0.5), scheduler: RunLoop.main)
            .flatMap { model -> AnyPublisher<String, any Error> in
                return self.nodeProviderUseCase.fetchEthereumBalance(address: model.address)
            }
            .tryMap { hexString -> Double in
                guard let balance = convertHexToDouble(hexString: hexString, decimals: 18) else {
                    throw DashboardViewModelError.unableToParseHexStringToDouble
                }
                return balance
            }
        
        Publishers.Zip3(fetchSelectedNetworkPublisher, fetchTokenBalancesPublisher, fetchEthereumBalancePublisher)
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.handleError(completion: $0)
            } receiveValue: { [weak self] (viewModel, tokenModels, ethBalance) in
                guard let self = self else { return }
                self.networkViewModel = viewModel
                self.allTokens = tokenModels
                self.ethBalance = ethBalance
                self.fetchNextTokens()
            }
            .store(in: &cancellables)
    }
    
    func fetchNextTokens() {
        guard offset < allTokens.count else { return }
        if offset != 0 { tokenViewModels += TokenViewModel.placeholders }
        let range = offset..<min(offset + pageSize, allTokens.count)
        let targetedTokens = allTokens[range]
        offset += pageSize
        
        let delayPublisher = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
        let metadataPublishers = targetedTokens.enumerated().map { index, model in
            delayPublisher
                .dropFirst(index)
                .prefix(1)
                .flatMap { _ in
                    self.nodeProviderUseCase
                        .fetchTokenMetadata(address: model.address)
                        .map { metadata -> (AddressToTokenModel, TokenMetadataModel) in
                            return (model, metadata)
                        }
                        .catch { _ in
                            Just(nil).eraseToAnyPublisher()
                        }
                }
        }
        
        Publishers.MergeMany(metadataPublishers)
            .compactMap { $0 }
            .collect()
            .map { tuples in
                Dictionary(uniqueKeysWithValues: tuples)
            }
            .sink { [weak self] dict in
                self?.addressToTokenModelsDict.send(dict)
            }
            .store(in: &cancellables)
    }
    
    func didTapCopyToClipboard() {
        shouldShowToastMessage = true
        let timerPublisher = Timer.publish(every: 1.5, on: .main, in: .common)
            .autoconnect()
        timerPublisher
            .prefix(1)
            .sink { [weak self] _ in
                self?.shouldShowToastMessage = false            }
            .store(in: &cancellables)
    }
}

// MARK: - Private
private extension DashboardViewModel {
    func fetchSelectedNetwork() -> AnyPublisher<NetworkViewModel, Error> {
        supportNetworksUseCase
            .fetchSelectedChainIdPublisher()
            .flatMap { self.supportNetworksUseCase.fetchNetworkModel(from: $0) }
            .map { model -> NetworkViewModel in
                return .init(name: model.chainName, chainId: model.chainId, isSelected: model.isSelected)
            }
            .eraseToAnyPublisher()
    }
    
    func fetchTokenBalances() -> AnyPublisher<[AddressToTokenModel], Error> {
        tokenViewModels = TokenViewModel.placeholders
        
        return manageHDWalletUseCase.restoreWallet()
            .flatMap { [weak self] _ -> AnyPublisher<WalletModel, Error> in
                guard let self = self else {
                    return Just(WalletModel(name: "", address: ""))
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
                return self.manageWalletsUseCase.loadSelectedWalletPublisher()
            }
            .map { model -> WalletViewModel in
                .init(name: model.name, address: model.address, isSelected: true)
            }
            .flatMap { [weak self] model -> AnyPublisher<[AddressToTokenModel], Error> in
                guard let self = self else { return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher() }
                self.walletViewModel = model
                return self.nodeProviderUseCase.fetchTokenBalances(address: model.address)
            }
            .eraseToAnyPublisher()
    }
    
    func subscribeToAddressToTokenModelDict() {
        addressToTokenModelsDict
            .map { [weak self] dict -> [TokenViewModel] in
                guard let self = self else { return [] }
                var tokenViewModels: [TokenViewModel] = self.tokenViewModels
                if tokenViewModels.filter({ $0.redactedReason != .placeholder }).count == 0 {
                    tokenViewModels.append(.init(
                        name: "Ethereum",
                        symbol: "ETH",
                        image: .iconEthereum,
                        balance: ethBalance,
                        totalAmount: 0,
                        isNativeToken: true
                    ))
                }
                dict.forEach { key, value in
                    guard let balance = convertHexToDouble(hexString: key.tokenBalance, decimals: value.decimals)
                    else { return }
                    let tokenViewModel: TokenViewModel = .init(
                        name: value.name,
                        symbol: "$\(value.symbol)",
                        logo: value.logo,
                        balance: balance,
                        totalAmount: 0
                    )
                    tokenViewModels.append(tokenViewModel)
                }
                tokenViewModels = tokenViewModels.filter { $0.redactedReason != .placeholder }
                return tokenViewModels
            }
            .sink { [weak self] models in
                guard let self = self else { return }
                self.tokenViewModels = models
                self.state = .finished
            }
            .store(in: &cancellables)
    }
    
    func subscribeToAccountChange() {
        globalEventUseCase.makeAccountChangePublisher()
            .sink { [weak self] _ in
                self?.modelDidChange()
            }
            .store(in: &cancellables)
    }
    
    func subscribeToNetworkChange() {
        globalEventUseCase.makeNetworkChangePublisher()
            .sink { [weak self] _ in
                self?.modelDidChange()
            }
            .store(in: &cancellables)
    }
    
    func handleError(completion: Subscribers.Completion<any Error>) {
        if case .failure(let error) = completion {
            self.alertViewModel = .init(message: error.localizedDescription)
            self.state = .error
        }
    }
    
    func modelDidChange() {
        offset = 0
        state = .loading
        fetchData()
    }
}

private enum DashboardViewModelError: Error {
    case unableToParseHexStringToDouble
}
