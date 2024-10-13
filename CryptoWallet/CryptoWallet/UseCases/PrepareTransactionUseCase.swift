// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine
import WalletCore

protocol PrepareTransactionUseCase: DerivationPathRetriever {
    func buildTransferTransaction(amount amountInWei: String) -> AnyPublisher<EthereumTransaction, Error>
    func buildERC20TransferTransaction(
        amount amountInWei: String,
        smartContractAddress: String
    ) -> AnyPublisher<EthereumTransaction, Error>
    
    func prepareSigningInput(
        destinationAddress: String,
        gasPrice: String,
        gasLimit: String,
        transaction: EthereumTransaction
    ) -> AnyPublisher<EthereumSigningInput, Error>
    func signTransaction(message: EthereumSigningInput) -> AnyPublisher<Data, Never>
    func validateAddress(address: String) -> AnyPublisher<Bool, Never>
}

final class PrepareTransactionImp: PrepareTransactionUseCase {
    
    private let walletManager: HDWalletManager
    
    init(HDWalletManager: HDWalletManager = .shared) {
        self.walletManager = HDWalletManager
    }
    
    func validateAddress(address: String) -> AnyPublisher<Bool, Never> {
        Just(AnyAddress.isValid(string: address, coin: walletManager.selectedNetwork.coinType)).eraseToAnyPublisher()
    }
    
    func buildTransferTransaction(amount amountInWei: String) -> AnyPublisher<EthereumTransaction, Error> {
        Future { promise in
            do {
                guard let amount: Data = .init(hexString: amountInWei) else {
                    throw PrepareTransactionError.unableToInitializeHexStringFrom(types: [amountInWei])
                }
                
                let tx = EthereumTransaction.with {
                    $0.transfer = EthereumTransaction.Transfer.with {
                        $0.amount = amount
                    }
                }
                promise(.success(tx))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func buildERC20TransferTransaction(
        amount amountInWei: String,
        smartContractAddress: String
    ) -> AnyPublisher<EthereumTransaction, Error> {
        Future { promise in
            do {
                guard let amount: Data = .init(hexString: amountInWei) else {
                    throw PrepareTransactionError.unableToInitializeHexStringFrom(types: [amountInWei])
                }
                
                let tx = EthereumTransaction.with {
                    $0.erc20Transfer = EthereumTransaction.ERC20Transfer.with {
                        $0.amount = amount
                        $0.to = smartContractAddress
                    }
                }
                promise(.success(tx))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func prepareSigningInput(
        destinationAddress: String,
        gasPrice: String,
        gasLimit: String,
        transaction: EthereumTransaction
    ) -> AnyPublisher<EthereumSigningInput, Error> {
        Future { [weak self] promise in
            do {
                guard let self = self, let wallet = self.walletManager.retrieveWallet() else {
                    throw PrepareTransactionError.unableToRetrieveWallet
                }
                
                guard let chainIdHexString = self.walletManager.selectedNetwork.chainId.toHexadecimalString(),
                      let gasPriceHexString = gasPrice.toHexadecimalString(),
                      let gasLimitHexString = gasLimit.toHexadecimalString(),
                      let chainId: Data = .init(hexString: chainIdHexString),
                      let gasPrice: Data = .init(hexString: gasPriceHexString),
                      let gasLimit: Data = .init(hexString: gasLimitHexString) else {
                    throw PrepareTransactionError.unableToInitializeHexStringFrom(types: [
                        self.walletManager.selectedNetwork.chainId,
                        gasPrice,
                        gasLimit
                    ])
                }
                
                let coinType = self.walletManager.selectedNetwork.coinType
                let order = self.walletManager.orderOfSelectedWallet
                let privateKey = getPrivateKeyData(wallet: wallet, coinType: coinType, order: order)
                
                let input: EthereumSigningInput = EthereumSigningInput.with {
                    $0.chainID = chainId
                    $0.toAddress = destinationAddress
                    $0.gasPrice = gasPrice
                    $0.gasLimit = gasLimit
                    $0.transaction = transaction
                    $0.privateKey = privateKey
                }
                promise(.success(input))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func signTransaction(message: EthereumSigningInput) -> AnyPublisher<Data, Never> {
        let output: EthereumSigningOutput = AnySigner.sign(input: message, coin: walletManager.selectedNetwork.coinType)
        return Just(output.encoded).eraseToAnyPublisher()
    }
}

// MARK: - Private
private enum PrepareTransactionError: Error {
    case unableToInitializeHexStringFrom(types: [String])
    case unableToRetrieveWallet
}
