// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine
import Foundation

protocol NodeProviderUseCase {
    func fetchEthereumBalance(address: String) -> AnyPublisher<String, Error>
    func fetchTokenBalances(address: String) -> AnyPublisher<[AddressToTokenModel], Error>
    func fetchTransactionCount(address: String) -> AnyPublisher<String, Error>
    func fetchTokenMetadata(address: String) -> AnyPublisher<TokenMetadataModel, Error>
    func fetchGasPrice() -> AnyPublisher<String, Error>
    func sendTransaction(encodedSignedTransaction: String) -> AnyPublisher<String, Error>
    func pollTransactionReceipt(txHash: String) -> AnyPublisher<String, Error>
}

final class NodeProviderImpl: NodeProviderUseCase {
    
    private let networkStack: NetworkStack
    private let networkPollingHandler: NetworkPollingHandlerProtocol
    private let HDWalletManager: HDWalletManager
    
    init(networkStack: NetworkStack,
         networkPollingHandler: NetworkPollingHandlerProtocol,
         HDWalletManager: HDWalletManager = .shared
    ) {
        self.networkStack = networkStack
        self.networkPollingHandler = networkPollingHandler
        self.HDWalletManager = HDWalletManager
    }
    
    func fetchEthereumBalance(address: String) -> AnyPublisher<String, Error> {
        let getBalanceResponsePubliser: AnyPublisher<JSONRPCResponse<String>, Error>
        = networkStack.fetchServiceProviderAPI(
            method: .getBalance,
            params: [address],
            nodeProvider: HDWalletManager.selectedNetwork.nodeProvider
        )
        
        return getBalanceResponsePubliser
            .flatMap { output in
                if let error = output.error {
                    let jsonRPCError = NetworkError.jsonRPCError(code: error.code, message: error.message)
                    return Fail<JSONRPCResponse<String>, Error>(error: jsonRPCError).eraseToAnyPublisher()
                }
                return Just(output).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .tryMap { response in
                guard let result = response.result else { throw NodeProviderUseCaseError.missingJSONRPCResult }
                return result
            }
            .eraseToAnyPublisher()
    }
    
    func fetchTransactionCount(address: String) -> AnyPublisher<String, Error> {
        let transactionCountPublisher: AnyPublisher<JSONRPCResponse<String>, Error>
        = networkStack.fetchServiceProviderAPI(
            method: .transactionCount,
            params: [address, "latest"],
            nodeProvider: HDWalletManager.selectedNetwork.nodeProvider
        )
        
        return transactionCountPublisher
            .flatMap { output in
                if let error = output.error {
                    let jsonRPCError = NetworkError.jsonRPCError(code: error.code, message: error.message)
                    return Fail<JSONRPCResponse<String>, Error>(error: jsonRPCError).eraseToAnyPublisher()
                }
                return Just(output).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .tryMap { response in
                guard let result = response.result else { throw NodeProviderUseCaseError.missingJSONRPCResult }
                return result.fullByteHexString()
            }
            .eraseToAnyPublisher()
    }
    
    func fetchTokenBalances(address: String) -> AnyPublisher<[AddressToTokenModel], Error> {
        let tokenBalancesResponsePublisher: AnyPublisher<JSONRPCResponse<TokenBalancesResponse>, Error>
        = networkStack.fetchServiceProviderAPI(
            method: .tokenBalances,
            params: [address],
            nodeProvider: HDWalletManager.selectedNetwork.nodeProvider
        )
        
        let modelsPublisher = tokenBalancesResponsePublisher
            .flatMap { output in
                if let error = output.error {
                    let jsonRPCError = NetworkError.jsonRPCError(code: error.code, message: error.message)
                    return Fail<JSONRPCResponse<TokenBalancesResponse>, Error>(error: jsonRPCError).eraseToAnyPublisher()
                }
                return Just(output).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .tryMap { response in
                guard let result = response.result else { throw NodeProviderUseCaseError.missingJSONRPCResult }
                let models: [AddressToTokenModel] = result.tokenBalances.compactMap {
                    return .init(address: $0.contractAddress, tokenBalance: $0.tokenBalance)
                }
                return models
            }
        
        return modelsPublisher.eraseToAnyPublisher()
    }
    
    func fetchTokenMetadata(address: String) -> AnyPublisher<TokenMetadataModel, Error> {
        let tokenMetadataResponsePublisher: AnyPublisher<JSONRPCResponse<TokenMetadataResponse>, Error>
        = networkStack.fetchServiceProviderAPI(
            method: .tokenMetadata,
            params: [address],
            nodeProvider: HDWalletManager.selectedNetwork.nodeProvider
        )
        
        let modelPublisher = tokenMetadataResponsePublisher
            .flatMap { output in
                if let error = output.error {
                    let jsonRPCError = NetworkError.jsonRPCError(code: error.code, message: error.message)
                    return Fail<JSONRPCResponse<TokenMetadataResponse>, Error>(error: jsonRPCError).eraseToAnyPublisher()
                }
                return Just(output).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .tryMap { response in
                guard let result = response.result,
                      let decimals = result.decimals,
                      let name = result.name,
                      let symbol = result.symbol else {
                    throw NodeProviderUseCaseError.missingTokenMetadataFields
                }
                let logo: URL? = result.logo.flatMap { .init(string: $0) }
                let model: TokenMetadataModel = .init(
                    decimals: decimals,
                    logo: logo,
                    name: name,
                    symbol: symbol
                )
                return model
            }
        
        
        return modelPublisher.eraseToAnyPublisher()
    }
    
    func fetchGasPrice() -> AnyPublisher<String, Error> {
        let gasPriceResponsePublisher: AnyPublisher<JSONRPCResponse<String>, Error> = networkStack.fetchServiceProviderAPI(
            method: .gasPrice,
            params: [],
            nodeProvider: HDWalletManager.selectedNetwork.nodeProvider
        )
        
        let gasPricePublsiher = gasPriceResponsePublisher
            .flatMap { response in
                if let error = response.error {
                    let jsonRPCError = NetworkError.jsonRPCError(code: error.code, message: error.message)
                    return Fail<JSONRPCResponse<String>, Error>(error: jsonRPCError).eraseToAnyPublisher()
                }
                return Just(response).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .tryMap { response in
                guard let gasPrice = response.result else {
                    throw NodeProviderUseCaseError.missingJSONRPCResult
                }
                return gasPrice
            }
        
        return gasPricePublsiher.eraseToAnyPublisher()
    }
    
    func sendTransaction(encodedSignedTransaction: String) -> AnyPublisher<String, Error> {
        let fetchServiceProviderPublisher: AnyPublisher<JSONRPCResponse<String>, Error> = networkStack.fetchServiceProviderAPI(
            method: .sendRawTransaction,
            params: [encodedSignedTransaction],
            nodeProvider: HDWalletManager.selectedNetwork.nodeProvider
        )
        
        return fetchServiceProviderPublisher
            .flatMap { response in
                if let error = response.error {
                    let jsonRPCError = NetworkError.jsonRPCError(code: error.code, message: error.message)
                    return Fail<JSONRPCResponse<String>, Error>(error: jsonRPCError).eraseToAnyPublisher()
                }
                return Just(response).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .tryMap { response in
                guard let txHash = response.result else {
                    throw NodeProviderUseCaseError.missingJSONRPCResult
                }
                return txHash
            }
            .eraseToAnyPublisher()
    }
    
    func pollTransactionReceipt(txHash: String) -> AnyPublisher<String, Error> {
        Future { promise in
            self.networkPollingHandler.startPolling { [weak self] completion in
                guard let self = self else { return }
                let cancellable = self.fetchTransactionReceipt(txHash: txHash)
                    .handleEvents(receiveOutput: { result in
                        let shouldStopPolling = result != nil
                        completion(shouldStopPolling)
                    })
                    .sink(receiveCompletion: { completionResult in
                        switch completionResult {
                        case .failure(let error):
                            promise(.failure(error))
                            completion(true)
                        case .finished:
                            break
                        }
                    }, receiveValue: { result in
                        if let receipt = result {
                            promise(.success(receipt))
                            completion(true)
                        }
                    })
            } pollingInvalidateCompletion: { error in
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}

// MARK: - Private
private extension NodeProviderImpl {
    func fetchTransactionReceipt(txHash: String) -> AnyPublisher<String?, Error> {
        let fetchTransactionReceiptPublisher: AnyPublisher<JSONRPCResponse<String>, Error> = networkStack.fetchServiceProviderAPI(
            method: .transactionReceipt,
            params: [txHash],
            nodeProvider: HDWalletManager.selectedNetwork.nodeProvider
        )
        
        return fetchTransactionReceiptPublisher
            .flatMap { response in
                if let error = response.error {
                    let jsonRPCError = NetworkError.jsonRPCError(code: error.code, message: error.message)
                    return Fail<JSONRPCResponse<String>, Error>(error: jsonRPCError).eraseToAnyPublisher()
                }
                return Just(response).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .tryMap { response in
                //TODO: Implement this
                return response.result == nil ? nil : ""
            }
            .eraseToAnyPublisher()
    }
}

private enum NodeProviderUseCaseError: Error {
    case missingTokenMetadataFields
    case missingJSONRPCResult
}
