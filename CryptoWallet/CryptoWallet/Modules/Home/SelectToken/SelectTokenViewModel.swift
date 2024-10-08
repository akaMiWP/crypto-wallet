// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine

final class SelectTokenViewModel: ObservableObject {
    
    @Published var isAddressValid: Bool = false
    @Published var addressInput: String = ""
    
    private let prepareTransactionUseCase: PrepareTransactionUseCase
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(prepareTransactionUseCase: PrepareTransactionUseCase) {
        self.prepareTransactionUseCase = prepareTransactionUseCase
        
        $addressInput
            .map { prepareTransactionUseCase.validateAddress(address: $0) }
            .sink { isAddressValid in
                self.isAddressValid = isAddressValid
            }
            .store(in: &cancellables)
    }
    
    func didTapPasteButton(address: String?) {
        address.map { addressInput = $0 }
    }
    
    func didTapNextButton() {}
}
