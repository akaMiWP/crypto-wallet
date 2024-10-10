// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine

final class SelectTokenViewModel: ObservableObject {
    
    @Published var isAddressValid: Bool = false
    @Published var addressInput: String = ""
    let pageTitle: String
    let selectedTokenViewModel: TokenViewModel
    
    private let selectTokenUseCase: SelectTokenUseCase
    private let prepareTransactionUseCase: PrepareTransactionUseCase
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(selectTokenUseCase: SelectTokenUseCase,
         prepareTransactionUseCase: PrepareTransactionUseCase
    ) {
        self.selectTokenUseCase = selectTokenUseCase
        self.prepareTransactionUseCase = prepareTransactionUseCase
        self.selectedTokenViewModel = selectTokenUseCase.selectedTokenModel.toViewModel()
        self.pageTitle = "Send \(selectedTokenViewModel.symbol)"
        
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
