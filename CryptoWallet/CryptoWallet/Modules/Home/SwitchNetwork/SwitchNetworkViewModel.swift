// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine

final class SwitchNetworkViewModel: Filterable {
   
    @Published var searchInput: String = ""
    @Published var filteredViewModels: SupportedNetworkViewModel = .init(mainnetViewModels: [], testnetViewModels: [])
    
    private var supportNetworksUseCase: SupportNetworksUseCase
    private var cancellables: Set<AnyCancellable> = .init()
    
    private var viewModelSubject: CurrentValueSubject<SupportedNetworkViewModel, Never> = .init(
        .init(mainnetViewModels: [], testnetViewModels: [])
    )
    
    init(supportNetworksUseCase: SupportNetworksUseCase) {
        self.supportNetworksUseCase = supportNetworksUseCase
        
        viewModelSubject
            .assign(to: \.filteredViewModels, on: self)
            .store(in: &cancellables)
        
        subscribeToSearchInput()
            .store(in: &cancellables)
    }
    
    func fetchSupportedNetworks() {
        supportNetworksUseCase
            .fetchSelectedChainIdPublisher()
            .flatMap { selectedChainId in
                self.supportNetworksUseCase.makeNetworkModelsPublisher(from: selectedChainId)
            }
            .map { networkModels -> SupportedNetworkViewModel in
                let mainnetViewModels: [NetworkViewModel] = networkModels.mainnets.compactMap { model in
                    return .init(name: model.chainName, chainId: model.chainId)
                }
                let testnetViewModels: [NetworkViewModel] = networkModels.testnets.compactMap { model in
                    return .init(name: model.chainName, chainId: model.chainId)
                }
                return .init(mainnetViewModels: mainnetViewModels, testnetViewModels: testnetViewModels)
            }
            .assign(to: \.viewModelSubject.value, on: self)
            .store(in: &cancellables)
    }
    
    func didSelect(viewModel: NetworkViewModel) {
        //TODO: To be implemented
    }
}

// MARK: - Filterable
extension SwitchNetworkViewModel {
    var searchInputPublisher: AnyPublisher<String, Never> {
        $searchInput.eraseToAnyPublisher()
    }
    
    func filterItems(from searchInput: String) -> AnyPublisher<SupportedNetworkViewModel, Never> {
        guard !searchInput.isEmpty else { return Just(viewModelSubject.value).eraseToAnyPublisher() }
        let viewModel = viewModelSubject.value
        let sections: [NetworkSection] = viewModel.sections.compactMap { section in
            let viewModels = section.viewModels.filter { $0.name.lowercased().contains(searchInput) }
            return .init(title: section.title, viewModels: viewModels)
        }
        let filteredViewModel: SupportedNetworkViewModel = .init(sections: sections)
        return Just(filteredViewModel).eraseToAnyPublisher()
    }
}
