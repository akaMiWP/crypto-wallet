// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine
import Foundation

final class SelectTokensViewModel: Filterable {
    
    @Published var searchInput: String = ""
    @Published var filteredViewModels: [TokenViewModel] = []
    
    private let viewModels: [TokenViewModel]
    private let manageTokensUseCase: ManageTokensUseCase
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(manageTokensUseCase: ManageTokensUseCase,
         viewModels: [TokenViewModel]) {
        self.manageTokensUseCase = manageTokensUseCase
        self.viewModels = viewModels
        self.filteredViewModels = viewModels
        
        subscribeToSearchInput()
            .store(in: &cancellables)
    }
    
    func makeSelectTokenViewModel(selectedTokenViewModel: TokenViewModel) -> SelectTokenViewModel {
        .init(manageTokensUseCase: manageTokensUseCase,
              prepareTransactionUseCase: PrepareTransactionImp(),
              selectedTokenViewModel: selectedTokenViewModel
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
