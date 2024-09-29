// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine
import Foundation

final class SelectTokensViewModel: Filterable {
    
    @Published var searchInput: String = ""
    @Published var filteredViewModels: [TokenViewModel] = []
    
    private let viewModels: [TokenViewModel]
    private var cancellables: Set<AnyCancellable> = .init()
    
    var searchInputPublisher: AnyPublisher<String, Never> {
        $searchInput.eraseToAnyPublisher()
    }
    
    init(viewModels: [TokenViewModel]) {
        self.viewModels = viewModels
        self.filteredViewModels = viewModels
        
        subscribeToSearchInput()
            .store(in: &cancellables)
    }
    
    func filterItems(from searchInput: String) -> AnyPublisher<[TokenViewModel], Never> {
        guard !searchInput.isEmpty else { return Just(self.viewModels).eraseToAnyPublisher() }
        let filterdViewModels = self.viewModels.filter { $0.name.lowercased().contains(searchInput) }
        return Just(filterdViewModels).eraseToAnyPublisher()
    }
}
