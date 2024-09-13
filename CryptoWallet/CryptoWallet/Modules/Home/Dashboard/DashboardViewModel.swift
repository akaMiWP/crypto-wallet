// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine

final class DashboardViewModel: ObservableObject {
    
    @Published var tokenViewModels: [TokenViewModel] = .init()
    
    private let nodeProviderUseCase: NodeProviderUseCase
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(nodeProviderUseCase: NodeProviderUseCase) {
        self.nodeProviderUseCase = nodeProviderUseCase
    }
    
    func fetchTokenBalances() {
        nodeProviderUseCase
            .fetchTokenBalances(address: "0xd8da6bf26964af9d7eed9e03e53415d37aa96045")
            .sink {
                if case .failure(let error) = $0 {
                    print(error)
                }
            } receiveValue: { models in
                print(models)
            }
            .store(in: &cancellables)

    }
}
