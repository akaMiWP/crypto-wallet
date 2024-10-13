// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine

final class SummaryViewModel: Alertable {
    
    @Published var networkFee: Double = 0.0
    @Published var gasPrice: String = "0.0"
    @Published var hasFetchedForGasPrice: Bool = false
    
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
                    .map {
                        self?.gasPrice = $0
                        self?.hasFetchedForGasPrice = true
                    }
            }
            .store(in: &cancellables)
    }
    
    func didTapNextButton() {
        do {
            guard let amountInHexString = convertEtherToWei(ether: summaryTokenUseCase.sendAmount.toString())
                .toHexadecimalString() else {
                throw SummaryViewModelError.unableToTransformIntoHextring
            }
            guard let smartContractAddress = summaryTokenUseCase.tokenModel.smartContractAddress else {
                throw SummaryViewModelError.smartContractAddressNotFound
            }
            prepareTransactionUseCase.buildERC20TransferTransaction(
                amount: amountInHexString,
                smartContractAddress: smartContractAddress
            )
            .flatMap { transaction in
                self.prepareTransactionUseCase.prepareSigningInput(
                    destinationAddress: self.summaryTokenUseCase.destinationAddress,
                    gasPrice: self.gasPrice,
                    gasLimit: "21000",
                    transaction: transaction
                )
            }
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.handleError(error: error)
                }
            } receiveValue: { input in
                print(input)
            }
            .store(in: &cancellables)
        } catch {
            handleError(error: error)
        }
    }
}

// MARK: - Private
private extension SummaryViewModel {
    func handleError(error: Error) {
        alertViewModel = .init()
    }
}

private enum SummaryViewModelError: Error {
    case smartContractAddressNotFound
    case unableToTransformIntoHextring
}
