// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine
import Foundation

final class SwitchNetworkViewModel: Alertable, Dismissable, Filterable {
    
    @Published var searchInput: String = ""
    @Published var filteredViewModels: SupportedNetworkViewModel = .init(mainnetViewModels: [], testnetViewModels: [])
    @Published var alertViewModel: AlertViewModel?
    
    let shouldDismissSubject: PassthroughSubject<Bool, Never> = .init()
    
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
                    return .init(name: model.chainName, chainId: model.chainId, isSelected: model.isSelected)
                }
                let testnetViewModels: [NetworkViewModel] = networkModels.testnets.compactMap { model in
                    return .init(name: model.chainName, chainId: model.chainId, isSelected: model.isSelected)
                }
                return .init(mainnetViewModels: mainnetViewModels, testnetViewModels: testnetViewModels)
            }
            .assign(to: \.viewModelSubject.value, on: self)
            .store(in: &cancellables)
    }
    
    func didSelect(viewModel: NetworkViewModel) {
        supportNetworksUseCase
            .selectNetworkPublisher(from: viewModel.chainId)
            .sink {
                switch $0 {
                case .finished: self.shouldDismissSubject.send(true)
                case .failure(let error): self.alertViewModel = .init(message: error.localizedDescription)
                }
            } receiveValue: { _ in
                NotificationCenter.default.post(name: .init("networkChanged"), object: nil)
            }
            .store(in: &cancellables)
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
