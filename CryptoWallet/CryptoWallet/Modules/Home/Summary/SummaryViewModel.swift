// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine

final class SummaryViewModel: Alertable {
    
    @Published var networkFee: Double = 0.0
    @Published var gasPrice: String = "0.0"
    @Published var hasFetchedForGasPrice: Bool = false
    @Published var alertViewModel: AlertViewModel?
    
    var destinationAddress: String { summaryTokenUseCase.destinationAddress }
    var networkName: String { summaryTokenUseCase.tokenModel.network.chainName }
    
    let sendAmountText: String
    
    private let summaryTokenUseCase: SummaryTokenUseCase
    private let manageWalletUseCase: ManageWalletsUseCase
    private let nodeProviderUseCase: NodeProviderUseCase
    private let prepareTransactionUseCase: PrepareTransactionUseCase
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(summaryTokenUseCase: SummaryTokenUseCase,
         manageWalletUseCase: ManageWalletsUseCase,
         nodeProviderUseCase: NodeProviderUseCase,
         prepareTransactionUseCase: PrepareTransactionUseCase
    ) {
        self.summaryTokenUseCase = summaryTokenUseCase
        self.manageWalletUseCase = manageWalletUseCase
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
            guard let amount = convertEtherToHex(ether: summaryTokenUseCase.sendAmount),
                  let gasPrice = Int(convertGweiToWei(gwei: gasPrice)),
                  let smartContractAddress = summaryTokenUseCase.tokenModel.smartContractAddress else {
                throw SummaryViewModelError.smartContractAddressNotFound
            }
            
            manageWalletUseCase.getSelectedWalletAddressPublisher()
                .flatMap(nodeProviderUseCase.fetchTransactionCount(address:))
                .flatMap { nonce in
                    self.summaryTokenUseCase.isNativeTokenPublisher()
                        .map { (nonce, $0) }
                }
                .flatMap { (nonce, isNativeToken) in
                    let amount = amount.fullByteHexString()
                    let transactionPublisher = isNativeToken
                    ? self.prepareTransactionUseCase.buildTransferTransaction(amount: amount)
                    : self.prepareTransactionUseCase.buildERC20TransferTransaction(
                        amount: amount,
                        destinationAddress: self.summaryTokenUseCase.destinationAddress
                    )
                    return transactionPublisher
                        .map { transaction in return (nonce, transaction) }
                }
                .flatMap { (nonce, transaction) in
                    self.prepareTransactionUseCase.prepareSigningInput(
                        destinationAddress: smartContractAddress,
                        nonce: nonce,
                        gasPrice: gasPrice,
                        gasLimit: 21632,
                        transaction: transaction
                    )
                }
                .flatMap(prepareTransactionUseCase.signTransaction(message:))
                .flatMap(nodeProviderUseCase.sendTransaction(encodedSignedTransaction:))
                .flatMap(nodeProviderUseCase.pollTransactionReceiptPublisher(txHash:))
                .sink { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.handleError(error: error)
                    }
                } receiveValue: { [weak self] txHash in
                    print(txHash)
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
