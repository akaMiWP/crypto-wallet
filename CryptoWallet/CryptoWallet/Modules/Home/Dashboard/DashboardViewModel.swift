// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine

final class DashboardViewModel: Alertable {
    
    @Published var tokenViewModels: [TokenViewModel] = .init()
    @Published var alertViewModel: AlertViewModel?
    
    private var addressToTokenModelsDict:
    PassthroughSubject<[AddressToTokenModel: TokenMetadataModel], Never> = .init()
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
            }
            .store(in: &cancellables)
    }
    
    func fetchTokenBalances() {
        nodeProviderUseCase
            .fetchTokenBalances(address: "0xd8da6bf26964af9d7eed9e03e53415d37aa96045")
            .sink { [weak self] in
                self?.handleError(completion: $0)
            } receiveValue: { [weak self] models in
                models.forEach { self?.subscribeTokenMetadata(model: $0) }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Private
private extension DashboardViewModel {
    func subscribeTokenMetadata(model: AddressToTokenModel) {
        nodeProviderUseCase
            .fetchTokenMetadata(address: model.address)
            .sink { [weak self] in
                self?.handleError(completion: $0)
            } receiveValue: { model in
                print(model)
            }
            .store(in: &cancellables)
    }
    
    func handleError(completion: Subscribers.Completion<any Error>) {
        if case .failure(let error) = completion {
            self.alertViewModel = .init(message: error.localizedDescription)
        }
    }
}
