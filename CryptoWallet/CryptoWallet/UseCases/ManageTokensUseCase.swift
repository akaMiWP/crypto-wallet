// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine

protocol ManageTokensUseCase {
    var models: [TokenModel] { get }
    
    func createTokensModelPublisher(
        dict: [AddressToTokenModel : TokenMetadataModel],
        ethBalance: Double,
        network: NetworkModel
    ) -> AnyPublisher<[TokenModel], Error>
    
    func clearModels()
}

final class ManageTokensImp: ManageTokensUseCase {
    var models: [TokenModel] = []
    
    func createTokensModelPublisher(
        dict: [AddressToTokenModel : TokenMetadataModel],
        ethBalance: Double,
        network: NetworkModel
    ) -> AnyPublisher<[TokenModel], Error> {
        Future { promise in
            do {
                if self.models.isEmpty {
                    let ethTokenModel: TokenModel = .init(
                        name: ChainNameConstants.ethereum,
                        symbol: SymbolsConstants.ethereum,
                        isNativeToken: true,
                        tokenBalance: ethBalance,
                        totalAmount: 0,
                        network: network
                    )
                    self.models.append(ethTokenModel)
                }
                
                try dict.forEach { key, value in
                    guard let balance = convertHexToDouble(hexString: key.tokenBalance, decimals: value.decimals)
                    else {
                        throw ManageTokensError.unableToRetrieveBalance
                    }
                    let model: TokenModel = .init(
                        name: value.name,
                        symbol: value.symbol,
                        address: key.address,
                        logo: value.logo,
                        tokenBalance: balance,
                        totalAmount: 0,
                        network: network
                    )
                    self.models.append(model)
                }
                
                promise(.success(self.models))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func clearModels() {
        models = []
    }
}

// MARK: - Private
private enum ManageTokensError: Error {
    case unableToRetrieveBalance
}
