// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine

final class SummaryViewModel: Alertable {
    
    @Published var networkFee: Double = 0.0
    @Published var gasPrice: String = "0.0"
    
    var destinationAddress: String { summaryTokenUseCase.destinationAddress }
    var networkName: String { summaryTokenUseCase.tokenModel.network.chainName }
    
    let sendAmountText: String
    var alertViewModel: AlertViewModel?
    
    private let summaryTokenUseCase: SummaryTokenUseCase
    private let nodeProviderUseCase: NodeProviderUseCase
    private let prepareTransactionUseCase: PrepareTransactionUseCase
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(summaryTokenUseCase: SummaryTokenUseCase,
         nodeProviderUseCase: NodeProviderUseCase,
         prepareTransactionUseCase: PrepareTransactionUseCase
    ) {
        self.summaryTokenUseCase = summaryTokenUseCase
        self.nodeProviderUseCase = nodeProviderUseCase
        self.prepareTransactionUseCase = prepareTransactionUseCase
        
        sendAmountText = summaryTokenUseCase.sendAmount.toString() + " \(summaryTokenUseCase.tokenModel.symbol)"
    }
    
    func fetchGasPrice() {
        nodeProviderUseCase
            .fetchGasPrice()
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.handleError(error: error)
                }
            } receiveValue: { [weak self] gasPrice in
                convertHexToDouble(hexString: gasPrice)
                    .map { convertEtherToGwei(ether: $0.toString()) }
                    .map { self?.gasPrice = $0 }
            }
            .store(in: &cancellables)
    }
    
    func didTapNextButton() {
        prepareTransactionUseCase.buildERC20TransferTransaction(
            amount: summaryTokenUseCase.sendAmount.toString(),
            address: summaryTokenUseCase.destinationAddress
        )
        .flatMap { <#TW_Ethereum_Proto_Transaction#> in
            let address: String = summaryTokenUseCase.tokenModel.isNativeToken
            ? summaryTokenUseCase.tokenModel.address
            :
            prepareTransactionUseCase.prepareSigningInput(
                address: summaryTokenUseCase.tokenModel.isNativeToken ? ,
                gasPrice: <#T##String#>,
                gasLimit: <#T##String#>,
                transaction: <#T##EthereumTransaction#>
            )
        }
    }
}

// MARK: - Private
private extension SummaryViewModel {
    func handleError(error: Error) {
        alertViewModel = .init()
    }
}
