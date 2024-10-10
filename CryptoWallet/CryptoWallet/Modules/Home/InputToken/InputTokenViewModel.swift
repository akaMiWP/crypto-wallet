// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine

final class InputTokenViewModel: ObservableObject {
    
    @Published var inputAmount: String = ""
    @Published var isInputValid: Bool = false
    
    let selectedTokenViewModel: TokenViewModel
    let selectedDestinationAddress: String
    let title: String
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(selectedTokenViewModel: TokenViewModel,
         selectedDestinationAddress: String,
         title: String
    ) {
        self.selectedTokenViewModel = selectedTokenViewModel
        self.selectedDestinationAddress = selectedDestinationAddress
        self.title = title
        
        $inputAmount
            .map { $0.toDouble() }
            .map { selectedTokenViewModel.balance > $0 && $0 != 0 }
            .sink { [weak self] in
                self?.isInputValid = $0
            }
            .store(in: &cancellables)
    }
}
