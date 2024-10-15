// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine
import WalletCore

protocol PrepareTransactionUseCase: DerivationPathRetriever {
    func buildTransferTransaction(amount amountInWei: String) -> AnyPublisher<EthereumTransaction, Error>
    func buildERC20TransferTransaction(
        amount amountInWei: String,
        destinationAddress: String
    ) -> AnyPublisher<EthereumTransaction, Error>
    
    func prepareSigningInput(
        destinationAddress: String,
        nonce: String,
        gasPrice: Int,
        gasLimit: Int,
        transaction: EthereumTransaction
    ) -> AnyPublisher<EthereumSigningInput, Error>
    func signTransaction(message: EthereumSigningInput) -> AnyPublisher<String, Never>
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
        destinationAddress: String
    ) -> AnyPublisher<EthereumTransaction, Error> {
        Future { promise in
            do {
                guard let amount: Data = .init(hexString: amountInWei) else {
                    throw PrepareTransactionError.unableToInitializeHexStringFrom(types: [amountInWei])
                }
                
                let tx = EthereumTransaction.with {
                    $0.erc20Transfer = EthereumTransaction.ERC20Transfer.with {
                        $0.amount = amount
                        $0.to = destinationAddress
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
        nonce: String,
        gasPrice: Int,
        gasLimit: Int,
        transaction: EthereumTransaction
    ) -> AnyPublisher<EthereumSigningInput, Error> {
        Future { [weak self] promise in
            do {
                guard let self = self, let wallet = self.walletManager.retrieveWallet() else {
                    throw PrepareTransactionError.unableToRetrieveWallet
                }
                
                guard let chainIdHexString = Int(self.walletManager.selectedNetwork.chainId)?.toHexString(),
                      let nonce: Data = .init(hexString: nonce),
                      let chainId: Data = .init(hexString: chainIdHexString),
                      let gasPrice: Data = .init(hexString: gasPrice.toHexString().fullByteHexString()),
                      let gasLimit: Data = .init(hexString: gasLimit.toHexString().fullByteHexString()) else {
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
                    $0.nonce = nonce
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
    
    func signTransaction(message: EthereumSigningInput) -> AnyPublisher<String, Never> {
        let output: EthereumSigningOutput = AnySigner.sign(input: message, coin: walletManager.selectedNetwork.coinType)
        let hexString = normalizeHexStringFormat(hexString: output.encoded.hexString)
        return Just(hexString).eraseToAnyPublisher()
    }
}

// MARK: - Private
private enum PrepareTransactionError: Error {
    case unableToInitializeHexStringFrom(types: [Any])
    case unableToRetrieveWallet
}
