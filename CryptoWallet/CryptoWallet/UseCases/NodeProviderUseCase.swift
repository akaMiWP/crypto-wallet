// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine
import Foundation

protocol NodeProviderUseCase {
    func fetchTokenBalances(address: String) -> AnyPublisher<[AddressToTokenModel], Error>
}

final class NodeProviderImpl: NodeProviderUseCase {
    
    private let networkStack: NetworkStack
    
    init(networkStack: NetworkStack) {
        self.networkStack = networkStack
    }
    
    func fetchTokenBalances(address: String) -> AnyPublisher<[AddressToTokenModel], Error> {
        let tokenBalancesResponsePublisher: AnyPublisher<JSONRPCResponse<TokenBalancesResponse>, Error> = networkStack
            .fetchServiceProviderAPI(method: .tokenBalances, params: [address])
        
        let modelsPublisher = tokenBalancesResponsePublisher.map { response in
            let models: [AddressToTokenModel] = response.result.tokenBalances.compactMap {
                guard let tokenBalance = convertHexToDouble(hexString: $0.tokenBalance) else { return nil }
                return .init(address: $0.contractAddress, tokenBalance: tokenBalance)
            }
            return models
        }
        
        return modelsPublisher.eraseToAnyPublisher()
    }
}
