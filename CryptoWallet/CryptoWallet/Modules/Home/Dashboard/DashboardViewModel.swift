// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine
import Foundation

// 0xd8da6bf26964af9d7eed9e03e53415d37aa96045: a sample address

final class DashboardViewModel: Alertable {
    // Output properties
    @Published var state: ViewModelState = .loading
    @Published var walletViewModel: WalletViewModel = .default
    @Published var networkViewModel: NetworkViewModel = .default
    @Published var tokenViewModels: [TokenViewModel] = []
    @Published var shouldRefetchTokenBalances: Bool = false
    @Published var shouldShowToastMessage: Bool = false
    @Published var accountAmount: String = "0 ETH"
    @Published var alertViewModel: AlertViewModel?
    
    var didAppear: Bool = false
    
    private let pageSize: Int = 12
    private var allTokens: [AddressToTokenModel] = []
    private var offset: Int = 0
    
    private let ethBalance: CurrentValueSubject<Double, Never> = .init(0)
    
    private var addressToTokenModelsDict:
    PassthroughSubject<[AddressToTokenModel: TokenMetadataModel], Never> = .init()
    private var cancellables: Set<AnyCancellable> = .init()
    
    private let nodeProviderUseCase: NodeProviderUseCase
    private let manageHDWalletUseCase: ManageHDWalletUseCase
    private let manageTokensUseCase: ManageTokensUseCase
    private let manageWalletsUseCase: ManageWalletsUseCase
    private let supportNetworksUseCase: SupportNetworksUseCase
    private let globalEventUseCase: GlobalEventUseCase
    
    init(nodeProviderUseCase: NodeProviderUseCase,
         manageHDWalletUseCase: ManageHDWalletUseCase,
         manageTokensUseCase: ManageTokensUseCase,
         manageWalletsUseCase: ManageWalletsUseCase,
         supportNetworksUseCase: SupportNetworksUseCase,
         globalEventUseCase: GlobalEventUseCase
    ) {
        self.nodeProviderUseCase = nodeProviderUseCase
        self.manageHDWalletUseCase = manageHDWalletUseCase
        self.manageTokensUseCase = manageTokensUseCase
        self.manageWalletsUseCase = manageWalletsUseCase
        self.supportNetworksUseCase = supportNetworksUseCase
        self.globalEventUseCase = globalEventUseCase
        subscribeToAddressToTokenModelDict()
        subscribeToAccountChange()
        subscribeToNetworkChange()
        subscribeToTransactionSent()
        subscribeToAccountAmount()
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
                self.ethBalance.send(ethBalance)
                self.fetchNextTokens()
                self.didAppear = true
            }
            .store(in: &cancellables)
    }
    
    func fetchNextTokens() {
        guard offset <= allTokens.count else { return }
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
    
    func makeSelectTokensViewModel() -> SelectTokensViewModel {
        .init(manageTokensUseCase: manageTokensUseCase)
    }
    
    func pullToRefresh() {
        modelDidChange()
    }
}

// MARK: - Private
private extension DashboardViewModel {
    func fetchSelectedNetwork() -> AnyPublisher<NetworkViewModel, Error> {
        supportNetworksUseCase
            .fetchSelectedChainIdPublisher()
            .flatMap { self.supportNetworksUseCase.fetchNetworkModel(from: $0) }
            .map { model -> NetworkViewModel in
                return .init(name: model.chainName, chainId: model.chainId, isSelected: model.isSelected, isMainnet: model.isMainnet)
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
            .flatMap { dict in
                self.supportNetworksUseCase
                    .fetchSelectedChainIdPublisher()
                    .flatMap { self.supportNetworksUseCase.fetchNetworkModel(from: $0) }
                    .map { (dict, $0) }
            }
            .flatMap { (dict, networkModel) in
                self.manageTokensUseCase.createTokensModelPublisher(
                    dict: dict,
                    ethBalance: self.ethBalance.value,
                    network: networkModel
                )
            }
            .map { models in models.toViewModels() }
            .sink { [weak self] completion in
                self?.handleError(completion: completion)
            } receiveValue: { [weak self] viewModels in
                guard let self = self else { return }
                self.tokenViewModels = viewModels
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
    
    func subscribeToTransactionSent() {
        globalEventUseCase.makeRefreshAccountBalancePublisher()
            .sink { [weak self] _ in
                self?.modelDidChange()
            }
            .store(in: &cancellables)
    }
    
    func subscribeToAccountAmount() {
        Publishers.CombineLatest($networkViewModel, ethBalance)
            .map { (network, balance) in
                if !network.isMainnet {
                    return "\(balance) SepoliaETH"
                }
                return "\(balance) ETH"
            }
            .assign(to: &$accountAmount)
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
        manageTokensUseCase.clearModels()
        fetchData()
    }
}

private enum DashboardViewModelError: Error {
    case unableToParseHexStringToDouble
}
