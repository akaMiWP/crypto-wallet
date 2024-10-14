// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine

final class InputTokenViewModel: ObservableObject {
    
    @Published var inputAmount: String = ""
    @Published var isInputValid: Bool = false
    
    var destinationAddress: String { inputTokenUseCase.destinationAddress }
    
    let selectedTokenViewModel: TokenViewModel
    let title: String
    
    private let inputTokenUseCase: InputTokenUseCase
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(inputTokenUseCase: InputTokenUseCase) {
        self.inputTokenUseCase = inputTokenUseCase
        self.selectedTokenViewModel = inputTokenUseCase.tokenModel.toViewModel()
        self.title = "Send \(selectedTokenViewModel.symbol)"
        
        $inputAmount
            .map { $0.toDouble() }
            .map { self.selectedTokenViewModel.balance > $0 && $0 != 0 }
            .sink { [weak self] in
                self?.isInputValid = $0
            }
            .store(in: &cancellables)
    }
    
    func makeSummaryViewModel() -> SummaryViewModel {
        .init(
            summaryTokenUseCase: SummaryTokenImp(
                destinationAddress: destinationAddress,
                sendAmount: inputAmount.toDouble(),
                tokenModel: inputTokenUseCase.tokenModel
            ),
            manageWalletUseCase: ManageWalletsImpl(),
            nodeProviderUseCase: NodeProviderImpl(
                networkStack: .init(),
                networkPollingHandler: NetworkPollingHandler()
            ),
            prepareTransactionUseCase: PrepareTransactionImp()
        )
    }
}
