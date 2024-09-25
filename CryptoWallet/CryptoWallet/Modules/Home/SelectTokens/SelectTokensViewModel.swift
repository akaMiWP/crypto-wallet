// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine
import Foundation

final class SelectTokensViewModel: ObservableObject {
    @Published var searchInput: String = ""
    @Published var filteredViewModels: [TokenViewModel] = []
    
    private let viewModels: [TokenViewModel]
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(viewModels: [TokenViewModel]) {
        self.viewModels = viewModels
        self.filteredViewModels = viewModels
        
        $searchInput
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .map { $0.lowercased() }
            .flatMap { searchInput in
                guard !searchInput.isEmpty else { return Just(self.viewModels).eraseToAnyPublisher() }
                let filterdViewModels = self.viewModels.filter { $0.name.lowercased().contains(searchInput) }
                return Just(filterdViewModels).eraseToAnyPublisher()
            }
            .sink { viewModels in
                self.filteredViewModels = viewModels
            }
            .store(in: &cancellables)
    }
}
