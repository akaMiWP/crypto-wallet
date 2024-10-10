// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine

protocol ManageTokensUseCase {
    var models: [TokenModel] { get }
    
    func createTokensModelPublisher(
        dict: [AddressToTokenModel : TokenMetadataModel]
    ) -> AnyPublisher<[TokenModel], Error>
    
    func clearModels()
}

final class ManageTokensImp: ManageTokensUseCase {
    var models: [TokenModel] = []
    
    func createTokensModelPublisher(
        dict: [AddressToTokenModel : TokenMetadataModel]
    ) -> AnyPublisher<[TokenModel], Error> {
        Future { promise in
            do {
                if self.models.isEmpty {
                    let ethTokenModel: TokenModel = .init(
                        name: "Ethereum",
                        symbol: "ETH",
                        address: "",
                        logo: nil,
                        isNativeToken: true,
                        tokenBalance: 0
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
                        isNativeToken: false,
                        tokenBalance: balance
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
