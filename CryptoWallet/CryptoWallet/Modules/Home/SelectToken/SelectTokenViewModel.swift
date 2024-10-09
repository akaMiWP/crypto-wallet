// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine

final class SelectTokenViewModel: ObservableObject {
    
    @Published var isAddressValid: Bool = false
    @Published var addressInput: String = ""
    let pageTitle: String
    
    private let selectedTokenViewModel: TokenViewModel
    private let manageTokensUseCase: ManageTokensUseCase
    private let prepareTransactionUseCase: PrepareTransactionUseCase
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(manageTokensUseCase: ManageTokensUseCase,
         prepareTransactionUseCase: PrepareTransactionUseCase,
         selectedTokenViewModel: TokenViewModel
    ) {
        self.manageTokensUseCase = manageTokensUseCase
        self.prepareTransactionUseCase = prepareTransactionUseCase
        self.selectedTokenViewModel = selectedTokenViewModel
        self.pageTitle = "Send $\(selectedTokenViewModel.symbol)"
        
        subscribeToDestinationAddress()
    }
    
    func didTapPasteButton(address: String?) {
        address.map { addressInput = $0 }
    }
    
    func didTapNextButton() {
    }
}

// MARK: - Private
private extension SelectTokenViewModel {
    func subscribeToDestinationAddress() {
        $addressInput
            .flatMap(prepareTransactionUseCase.validateAddress(address:))
            .sink { isAddressValid in
                self.isAddressValid = isAddressValid
            }
            .store(in: &cancellables)
    }
}
