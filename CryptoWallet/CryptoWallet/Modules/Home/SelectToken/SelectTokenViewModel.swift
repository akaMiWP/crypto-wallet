// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine

final class SelectTokenViewModel: ObservableObject {
    
    @Published var isAddressValid: Bool = false
    @Published var addressInput: String = ""
    
    private let manageTokensUseCase: ManageTokensUseCase
    private let prepareTransactionUseCase: PrepareTransactionUseCase
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(manageTokensUseCase: ManageTokensUseCase,
         prepareTransactionUseCase: PrepareTransactionUseCase) {
        self.manageTokensUseCase = manageTokensUseCase
        self.prepareTransactionUseCase = prepareTransactionUseCase
        
        $addressInput
            .flatMap(prepareTransactionUseCase.validateAddress(address:))
            .sink { isAddressValid in
                self.isAddressValid = isAddressValid
            }
            .store(in: &cancellables)
    }
    
    func didTapPasteButton(address: String?) {
        address.map { addressInput = $0 }
    }
    
    func didTapNextButton() {
    }
}
