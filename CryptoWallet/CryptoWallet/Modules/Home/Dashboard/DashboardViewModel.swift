// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine
import Foundation

final class DashboardViewModel: Alertable {
    
    @Published var state: ViewModelState = .loading
    @Published var tokenViewModels: [TokenViewModel] = TokenViewModel.placeholders
    @Published var alertViewModel: AlertViewModel?
    
    private var addressToTokenModelsDict:
    PassthroughSubject<[AddressToTokenModel: TokenMetadataModel], Never> = .init()
    private var shouldLoadMore: Bool = false
    private var cancellables: Set<AnyCancellable> = .init()
    
    private let nodeProviderUseCase: NodeProviderUseCase
    
    init(nodeProviderUseCase: NodeProviderUseCase) {
        self.nodeProviderUseCase = nodeProviderUseCase
        
        addressToTokenModelsDict
            .sink { [weak self] dict in
                var tokenViewModels: [TokenViewModel] = []
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
                self?.tokenViewModels = tokenViewModels
                self?.state = .finished
            }
            .store(in: &cancellables)
    }
    
    func fetchTokenBalances() { //TODO: Implement Pagination
        nodeProviderUseCase
            .fetchTokenBalances(address: "0xd8da6bf26964af9d7eed9e03e53415d37aa96045")
            .flatMap { [weak self] models -> AnyPublisher<[AddressToTokenModel: TokenMetadataModel], Never> in
                guard let self = self else { return Just([:]).eraseToAnyPublisher() }
                let delayPublisher = Timer.publish(every: 0.1, on: .main, in: .common)
                    .autoconnect()
                let metadataPublishers = models.enumerated().map { index, model in
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
                
                return Publishers.MergeMany(metadataPublishers)
                    .compactMap { $0 }
                    .collect()
                    .map { tuples in
                        Dictionary(uniqueKeysWithValues: tuples)
                    }
                    .eraseToAnyPublisher()
            }
            .sink { [weak self] in
                self?.handleError(completion: $0)
            } receiveValue: { [weak self] dict in
                self?.addressToTokenModelsDict.send(dict)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Private
private extension DashboardViewModel {
    func handleError(completion: Subscribers.Completion<any Error>) {
        if case .failure(let error) = completion {
            self.alertViewModel = .init(message: error.localizedDescription)
            self.state = .error
        }
    }
}
