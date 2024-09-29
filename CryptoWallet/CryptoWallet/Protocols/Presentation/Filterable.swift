// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine
import Foundation

protocol Filterable: ObservableObject {
    associatedtype Item
    
    var searchInputPublisher: AnyPublisher<String, Never> { get }
    var filteredViewModels: Item { get set }
    
    func filterItems(from searchInput: String) -> AnyPublisher<Item, Never>
    func subscribeToSearchInput() -> AnyCancellable
}

extension Filterable {
    func subscribeToSearchInput() -> AnyCancellable {
        searchInputPublisher
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .map { $0.lowercased() }
            .flatMap(filterItems)
            .assign(to: \.filteredViewModels, on: self)
    }
}
