// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine

final class DashboardViewModel: Alertable {
    
    @Published var tokenViewModels: [TokenViewModel] = .init()
    @Published var alertViewModel: AlertViewModel?
    
    private let nodeProviderUseCase: NodeProviderUseCase
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(nodeProviderUseCase: NodeProviderUseCase) {
        self.nodeProviderUseCase = nodeProviderUseCase
    }
    
    func fetchTokenBalances() {
        nodeProviderUseCase
            .fetchTokenBalances(address: "0xd8da6bf26964af9d7eed9e03e53415d37aa96045")
            .sink { [weak self] in
                self?.handleError(completion: $0)
            } receiveValue: { [weak self] models in
                models.forEach { self?.subscribeTokenMetadata(address: $0.address) }
            }
            .store(in: &cancellables)

    }
}

// MARK: - Private
private extension DashboardViewModel {
    func handleError(completion: Subscribers.Completion<any Error>) {
        if case .failure(let error) = completion {
            self.alertViewModel = .init(message: error.localizedDescription)
        }
    }
    
    func subscribeTokenMetadata(address: String) {
        nodeProviderUseCase
            .fetchTokenMetadata(address: address)
            .sink { [weak self] in
                self?.handleError(completion: $0)
            } receiveValue: { model in
                print(model)
            }
            .store(in: &cancellables)
    }
}
