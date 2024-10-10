// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine
import Foundation

final class SelectTokensViewModel: Alertable, Filterable {
    
    @Published var searchInput: String = ""
    @Published var filteredViewModels: [TokenViewModel] = []
    @Published var alertViewModel: AlertViewModel?
    
    private let viewModels: [TokenViewModel]
    private let manageTokensUseCase: ManageTokensUseCase
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(manageTokensUseCase: ManageTokensUseCase) {
        self.manageTokensUseCase = manageTokensUseCase
        self.viewModels = manageTokensUseCase.models.toViewModels()
        self.filteredViewModels = viewModels
        
        subscribeToSearchInput()
            .store(in: &cancellables)
    }
    
    func makeSelectTokenViewModel(selectedTokenViewModel: TokenViewModel) -> SelectTokenViewModel? {
        guard let tokenModel = manageTokensUseCase.models.first(where: { $0.address == selectedTokenViewModel.address }) else {
            alertViewModel = .init()
            return nil
        }
        return .init(selectTokenUseCase: SelectTokenImp(selectedTokenModel: tokenModel),
                     prepareTransactionUseCase: PrepareTransactionImp()
        )
    }
}

// MARK: - Filterable
extension SelectTokensViewModel {
    var searchInputPublisher: AnyPublisher<String, Never> {
        $searchInput.eraseToAnyPublisher()
    }
    
    func filterItems(from searchInput: String) -> AnyPublisher<[TokenViewModel], Never> {
        guard !searchInput.isEmpty else { return Just(viewModels).eraseToAnyPublisher() }
        let filterdViewModels = viewModels.filter { $0.name.lowercased().contains(searchInput) }
        return Just(filterdViewModels).eraseToAnyPublisher()
    }
}
