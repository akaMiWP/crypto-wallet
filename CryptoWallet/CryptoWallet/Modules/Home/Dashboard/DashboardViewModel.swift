// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine
import Foundation

// 0xd8da6bf26964af9d7eed9e03e53415d37aa96045: a sample address

final class DashboardViewModel: Alertable {
    
    @Published var state: ViewModelState = .loading
    @Published var derivatedAddress: String = ""
    @Published var tokenViewModels: [TokenViewModel] = []
    @Published var alertViewModel: AlertViewModel?
    
    private let pageSize: Int = 12
    private var allTokens: [AddressToTokenModel] = []
    private var offset: Int = 0
    
    private var addressToTokenModelsDict:
    PassthroughSubject<[AddressToTokenModel: TokenMetadataModel], Never> = .init()
    private var cancellables: Set<AnyCancellable> = .init()
    
    private let nodeProviderUseCase: NodeProviderUseCase
    private let manageHDWalletUseCase: ManageHDWalletUseCase
    
    init(nodeProviderUseCase: NodeProviderUseCase, manageHDWalletUseCase: ManageHDWalletUseCase) {
        self.nodeProviderUseCase = nodeProviderUseCase
        self.manageHDWalletUseCase = manageHDWalletUseCase
        subscribeToAddressToTokenModelDict()
    }
    
    func fetchTokenBalances() {
        tokenViewModels += TokenViewModel.placeholders
        
        manageHDWalletUseCase.restoreWallet()
            .flatMap { [weak self] wallet -> AnyPublisher<[AddressToTokenModel], Error> in
                guard let self = self else { return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher() }
                //wallet.getKey(coin: .ethereum, derivationPath: "m/44\'/60\'/1\'/0/0")
                let address = wallet.getAddressForCoin(coin: .ethereum)
                self.derivatedAddress = address.maskedWalletAddress()
                return self.nodeProviderUseCase.fetchTokenBalances(address: address)
            }
            .sink { [weak self] in
                self?.handleError(completion: $0)
            } receiveValue: { [weak self] models in
                guard let self = self else { return }
                self.allTokens = models
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
}

// MARK: - Private
private extension DashboardViewModel {
    func subscribeToAddressToTokenModelDict() {
        addressToTokenModelsDict
            .sink { [weak self] dict in
                guard let self = self else { return }
                var tokenViewModels: [TokenViewModel] = self.tokenViewModels
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
                self.tokenViewModels = tokenViewModels.filter { $0.redactedReason != .placeholder }
                self.state = .finished
            }
            .store(in: &cancellables)
    }
    
    func handleError(completion: Subscribers.Completion<any Error>) {
        if case .failure(let error) = completion {
            self.alertViewModel = .init(message: error.localizedDescription)
            self.state = .error
        }
    }
}
