// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine

final class SwitchNetworkViewModel: ObservableObject {
    @Published var supportedNetworks: [NetworkViewModel] = []
    
    private var supportNetworksUseCase: SupportNetworksUseCase
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(supportNetworksUseCase: SupportNetworksUseCase) {
        self.supportNetworksUseCase = supportNetworksUseCase
    }
    
    func fetchSupportedNetworks() {
        supportNetworksUseCase
            .makeNetworkModelsPublisher()
            .map { networkModels in
                let mainnetViewModels: [NetworkViewModel] = networkModels.mainnets.compactMap { model in
                    return .init(name: model.chainName)
                }
                let testnetViewModels: [NetworkViewModel] = networkModels.testnets.compactMap { model in
                    return .init(name: model.chainName)
                }
                return mainnetViewModels + testnetViewModels
            }
            .assign(to: \.supportedNetworks, on: self)
            .store(in: &cancellables)
    }
    
    func didSelect(viewModel: NetworkViewModel) {
        
    }
}
