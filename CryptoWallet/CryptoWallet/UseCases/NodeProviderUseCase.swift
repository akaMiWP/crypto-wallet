// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine
import Foundation

protocol NodeProviderUseCase {
    func fetchTokenBalances(address: String) -> AnyPublisher<[AddressToTokenModel], Error>
    func fetchTokenMetadata(address: String) -> AnyPublisher<TokenMetadataModel, Error>
}

final class NodeProviderImpl: NodeProviderUseCase {
    
    private let networkStack: NetworkStack
    
    init(networkStack: NetworkStack) {
        self.networkStack = networkStack
    }
    
    func fetchTokenBalances(address: String) -> AnyPublisher<[AddressToTokenModel], Error> {
        let tokenBalancesResponsePublisher: AnyPublisher<JSONRPCResponse<TokenBalancesResponse>, Error>
        = networkStack.fetchServiceProviderAPI(method: .tokenBalances, params: [address])
        
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
                    guard let tokenBalance = convertHexToDouble(hexString: $0.tokenBalance) else { return nil }
                    return .init(address: $0.contractAddress, tokenBalance: tokenBalance)
                }
                return models
            }
        
        return modelsPublisher.eraseToAnyPublisher()
    }
    
    func fetchTokenMetadata(address: String) -> AnyPublisher<TokenMetadataModel, Error> {
        let tokenMetadataResponsePublisher: AnyPublisher<JSONRPCResponse<TokenMetadataResponse>, Error>
        = networkStack.fetchServiceProviderAPI(method: .tokenMetadata, params: [address])
        
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
                      let logo = result.logo,
                      let name = result.name,
                      let symbol = result.symbol else {
                    throw NodeProviderUseCaseError.missingTokenMetadataFields
                }
                let model: TokenMetadataModel = .init(
                    decimals: decimals,
                    logo: .init(string: logo),
                    name: name,
                    symbol: symbol
                )
                return model
            }
        
        
        return modelPublisher.eraseToAnyPublisher()
    }
}

// MARK: - Private
private enum NodeProviderUseCaseError: Error {
    case missingTokenMetadataFields
    case missingJSONRPCResult
}
